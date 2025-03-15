// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/// @title Monorite Token (MNR)
/// @notice An ERC20 token with dynamic exchange rate and automated minting
/// @dev Implements incremental rate changes and transaction-based minting
contract Monorite is ERC20Capped, ReentrancyGuard {
    // Constants
    uint256 public constant MAX_SUPPLY = 40_000_000 * 1e18; // 40M tokens
    uint256 public constant INITIAL_RATE = 41_000_000_000_000; // 0.000041 ETH
    uint256 public constant INITIAL_INCREMENT = 2_500_000_000; // 0.0000000025 ETH
    uint256 public constant TOKENS_PER_MINT = 7 * 1e18; // 7 tokens
    
    // Creator addresses
    address public constant CREATOR_ADDRESS_1 = 0x64b767D9935a8171DD976F98d54ab42797017714;
    address public constant CREATOR_ADDRESS_2 = 0xA6116D0da69fa6b4808edce08349B71b4Ca03f27;
    address public constant CREATOR_ADDRESS_3 = 0xC65A83390c69552AAd4e177C08480a1bCAa5DF3D;

    // State variables
    uint256 public exchangeRate;
    uint256 public transactionCount;
    uint256 public currentIncrement;
    uint256 public nextHalvingThreshold = 400_000_000;
    uint256 private immutable chainId;

    // Events
    event ExchangeRateUpdated(uint256 oldRate, uint256 newRate);
    event TokenPurchase(address buyer, uint256 ethSpent, uint256 tokensBought, uint256 newRate);
    event TokenSale(address seller, uint256 tokensSold, uint256 ethReceived, uint256 newRate);
    event LiquidityChanged(uint256 contractEthBalance, uint256 contractTokenBalance);
    event TokenMinted(address destination, uint256 amountMinted);
    event PartialFill(address user, uint256 fulfilledAmount, uint256 returnedAmount);
    event MaxSupplyReached(uint256 totalSupply);
    event TransactionCountIncremented(uint256 newTransactionCount);
    event HalvingOccurred(uint256 transactionCountAtHalving, uint256 newIncrement);
    event HalvingCountdownUpdated(uint256 transactionsLeftToNextHalving, uint256 currentIncrement);
    event PartialBuyOrderRefunded(address buyer, uint256 refundedETH);
    event BuyOrderRefunded(address buyer, uint256 refundedETH);

    // Custom errors
    error DirectTransferDisabled();
    error DirectETHTransferNotAllowed();
    error InvalidRecipient();
    error ETHTransferFailed();
    error RateOverflow();
    error InsufficientBalance(uint256 requested, uint256 available);
    error AmountTooSmall();
    error NoLiquidity();
    error WrongChain();
    error TransactionCountOverflow();

    /// @notice Contract constructor
    /// @dev Sets initial exchange rate and mints initial supply
    constructor() ERC20("Monorite", "MNR") ERC20Capped(MAX_SUPPLY) {
        chainId = block.chainid;
        require(chainId != 0, "Invalid chain ID");
        
        exchangeRate = INITIAL_RATE;
        currentIncrement = INITIAL_INCREMENT;

        // Mint initial supply to creator addresses
        _mint(CREATOR_ADDRESS_1, 2_000_000 * 1e18); // 2M to creator address 1
        _mint(CREATOR_ADDRESS_2, 3_000_000 * 1e18); // 3M to creator address 2
        _mint(CREATOR_ADDRESS_3, 3_000_000 * 1e18); // 3M to creator address 3
        _mint(address(this), 2_000_000 * 1e18);     // 2M to contract
    }

    /// @notice Calculates token amount with precision safeguards
    function _calculateTokenAmount(uint256 ethAmount, uint256 _rate) internal pure returns (uint256) {
        require(_rate > 0, "Invalid rate");
        
        // Prevent overflow in multiplication
        uint256 numerator = ethAmount * 1e18;
        require(numerator / 1e18 == ethAmount, "Multiplication overflow");
        
        // Prevent division by zero and tiny amounts
        uint256 tokens = numerator / _rate;
        require(tokens > 0, "Amount too small");
        
        return tokens;
    }

    /// @notice Safe rate calculation with overflow checks
    function _calculateEthAmount(uint256 tokenAmount, uint256 _rate) internal pure returns (uint256) {
        require(_rate > 0, "Invalid rate");
        
        // Check multiplication overflow
        uint256 numerator = tokenAmount * _rate;
        require(numerator / _rate == tokenAmount, "Multiplication overflow");
        
        // Check division and minimum amount
        uint256 ethAmount = numerator / 1e18;
        require(ethAmount > 0, "Amount too small");
        
        return ethAmount;
    }

    /// @notice Validates chain ID
    function _validateChainId() internal view {
        if (block.chainid != chainId) revert WrongChain();
        if (chainId == 0) revert("Invalid chain ID");
    }

    /// @notice Allows users to buy tokens with ETH
    function buyTokens() external payable nonReentrant {
        _validateChainId();
        if (msg.value == 0) revert AmountTooSmall();

        // Cache exchange rate for consistent pricing
        uint256 _exchangeRate = exchangeRate;

        // Use new calculation function
        uint256 tokensRequested = _calculateTokenAmount(msg.value, _exchangeRate);

        uint256 contractBalance = balanceOf(address(this));
        if (contractBalance == 0) revert NoLiquidity();

        // Process transaction
        if (tokensRequested > contractBalance) {
            _handlePartialBuy(contractBalance, _exchangeRate);
        } else {
            _handleFullBuy(tokensRequested, _exchangeRate);
        }

        // Update state
        _incrementTransactionProgress();

        // Check for minting
        if (transactionCount % 100 == 0) {
            _mintTokensIfRequired(transactionCount);
        }

        emit LiquidityChanged(address(this).balance, balanceOf(address(this)));
    }

    /// @notice Allows users to sell tokens for ETH
    function sellTokens(uint256 tokenAmount) external nonReentrant {
        _validateChainId();
        if (tokenAmount == 0) revert AmountTooSmall();
        
        uint256 balance = balanceOf(msg.sender);
        if (balance < tokenAmount) revert InsufficientBalance(tokenAmount, balance);

        // Cache exchange rate for consistent pricing
        uint256 _exchangeRate = exchangeRate;
        
        uint256 contractEthBalance = address(this).balance;
        require(contractEthBalance > 0, "No ETH available");

        // Process transaction
        if ((tokenAmount * _exchangeRate) / 1e18 > contractEthBalance) {
            _handlePartialSell(tokenAmount, contractEthBalance);
        } else {
            _handleFullSell(tokenAmount);
        }

        // Update state using the common function
        _incrementTransactionProgress();

        // Use the updated transaction count for minting check
        if (transactionCount % 100 == 0) {
            _mintTokensIfRequired(transactionCount);
        }

        emit LiquidityChanged(address(this).balance, balanceOf(address(this)));
    }

    /// @notice Increments transaction count and handles halving logic
    function _incrementTransactionProgress() internal {
        uint256 _transactionCount = transactionCount;
        
        // Check for overflow
        if (_transactionCount >= type(uint256).max) revert TransactionCountOverflow();
        
        // Increment count
        _transactionCount++;
        
        // Update transaction count first
        transactionCount = _transactionCount;
        
        // Update exchange rate
        _updateExchangeRate();
        
        // Required event
        emit TransactionCountIncremented(_transactionCount);
        
        // Check halving threshold
        if (_transactionCount >= nextHalvingThreshold) {
            uint256 _currentIncrement = currentIncrement / 2;
            uint256 _nextHalvingThreshold = nextHalvingThreshold + 400_000_000;
            
            // Update storage
            currentIncrement = _currentIncrement;
            nextHalvingThreshold = _nextHalvingThreshold;
            
            // Required events
            emit HalvingOccurred(_transactionCount, _currentIncrement);
            emit HalvingCountdownUpdated(
                _nextHalvingThreshold - _transactionCount,
                _currentIncrement
            );
        }
    }

    /// @notice Handles minting logic every 100 transactions
    function _mintTokensIfRequired(uint256 /* _count */) internal {
        uint256 currentSupply = totalSupply();
        uint256 remainingToMint = MAX_SUPPLY - currentSupply;
        
        // Calculate how many tokens to mint (either TOKENS_PER_MINT or remaining amount)
        uint256 amountToMint = remainingToMint >= TOKENS_PER_MINT ? 
            TOKENS_PER_MINT : remainingToMint;
        
        // Perform minting
        _mint(address(this), amountToMint);
        emit TokenMinted(address(this), amountToMint);
        
        // Check if we've hit max supply
        if (totalSupply() == MAX_SUPPLY) {
            emit MaxSupplyReached(MAX_SUPPLY);
        }
    }

    /// @notice Override of ERC20 transfer to prevent direct transfers
    function transfer(address, uint256) public pure override returns (bool) {
        revert DirectTransferDisabled();
    }

    /// @notice Override of ERC20 transferFrom to prevent direct transfers
    function transferFrom(address, address, uint256) public pure override returns (bool) {
        revert DirectTransferDisabled();
    }

    /// @notice Prevents direct ETH transfers
    receive() external payable {
        revert DirectETHTransferNotAllowed();
    }

    /// @notice Prevents direct ETH transfers
    fallback() external payable {
        revert DirectETHTransferNotAllowed();
    }

    /// @notice Safe ETH transfer with additional checks
    function _safeTransferETH(address to, uint256 amount) internal {
        if (to == address(0)) revert InvalidRecipient();
        if (amount == 0) revert AmountTooSmall();
        if (address(this).balance < amount) revert("Insufficient ETH balance");
        
        (bool success,) = to.call{value: amount}("");
        if (!success) revert ETHTransferFailed();
    }

    /// @notice Handles partial buy orders when contract has insufficient tokens
    function _handlePartialBuy(uint256 availableTokens, uint256 _rate) internal {
        // Calculate amounts first
        uint256 ethToSpend = _calculateEthAmount(availableTokens, _rate);
        uint256 refund = msg.value - ethToSpend;
        
        // State changes first
        _transfer(address(this), msg.sender, availableTokens);
        
        // Events next
        emit TokenPurchase(msg.sender, ethToSpend, availableTokens, _rate);
        
        // ETH transfer last
        if (refund > 0) {
            _safeTransferETH(msg.sender, refund);
            emit PartialBuyOrderRefunded(msg.sender, refund);
        }
    }

    /// @notice Handles full buy orders
    function _handleFullBuy(uint256 tokenAmount, uint256 _rate) internal {
        _transfer(address(this), msg.sender, tokenAmount);
        emit TokenPurchase(msg.sender, msg.value, tokenAmount, _rate);
    }

    /// @notice Handles partial sell orders when contract has insufficient ETH
    function _handlePartialSell(uint256 tokenAmount, uint256 availableEth) internal {
        // Calculate amounts first
        uint256 partialTokenAmount = _calculateTokenAmount(availableEth, exchangeRate);
        uint256 returnedTokens = tokenAmount - partialTokenAmount;
        
        // State changes first
        _transfer(msg.sender, address(this), partialTokenAmount);
        
        // All events before ETH transfer
        emit TokenSale(msg.sender, partialTokenAmount, availableEth, exchangeRate);
        emit PartialFill(msg.sender, partialTokenAmount, returnedTokens);
        emit LiquidityChanged(address(this).balance, balanceOf(address(this)));
        
        // ETH transfer absolutely last
        _safeTransferETH(msg.sender, availableEth);
    }

    /// @notice Handles full sell orders with balance checks
    function _handleFullSell(uint256 tokenAmount) internal {
        // Calculate ETH amount first
        uint256 ethToSend = _calculateEthAmount(tokenAmount, exchangeRate);
        
        // Verify contract has enough ETH
        require(address(this).balance >= ethToSend, "Insufficient ETH");
        
        // Execute transfers
        _transfer(msg.sender, address(this), tokenAmount);
        _safeTransferETH(msg.sender, ethToSend);

        emit TokenSale(msg.sender, tokenAmount, ethToSend, exchangeRate);
    }

    /// @notice Updates exchange rate with precision checks
    function _updateExchangeRate() internal {
        uint256 oldRate = exchangeRate;
        uint256 _currentIncrement = currentIncrement;
        
        // Explicit overflow check for rate addition
        uint256 newRate = oldRate + _currentIncrement;
        if (newRate < oldRate || newRate < _currentIncrement) revert RateOverflow();
        
        // Update storage and emit event
        exchangeRate = newRate;
        emit ExchangeRateUpdated(oldRate, newRate);
    }
} 
