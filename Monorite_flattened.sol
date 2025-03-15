// SPDX-License-Identifier: MIT
// File: @openzeppelin/contracts/token/ERC20/IERC20.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/IERC20.sol)

pragma solidity ^0.8.20;

/**
 * @dev Interface of the ERC-20 standard as defined in the ERC.
 */
interface IERC20 {
    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);

    /**
     * @dev Returns the value of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the value of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves a `value` amount of tokens from the caller's account to `to`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address to, uint256 value) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets a `value` amount of tokens as the allowance of `spender` over the
     * caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 value) external returns (bool);

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to` using the
     * allowance mechanism. `value` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

// File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol


// OpenZeppelin Contracts (last updated v5.1.0) (token/ERC20/extensions/IERC20Metadata.sol)

pragma solidity ^0.8.20;


/**
 * @dev Interface for the optional metadata functions from the ERC-20 standard.
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// File: @openzeppelin/contracts/utils/Context.sol


// OpenZeppelin Contracts (last updated v5.0.1) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }

    function _contextSuffixLength() internal view virtual returns (uint256) {
        return 0;
    }
}

// File: @openzeppelin/contracts/interfaces/draft-IERC6093.sol


// OpenZeppelin Contracts (last updated v5.1.0) (interfaces/draft-IERC6093.sol)
pragma solidity ^0.8.20;

/**
 * @dev Standard ERC-20 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-20 tokens.
 */
interface IERC20Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientBalance(address sender, uint256 balance, uint256 needed);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC20InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC20InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `spender`’s `allowance`. Used in transfers.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     * @param allowance Amount of tokens a `spender` is allowed to operate with.
     * @param needed Minimum amount required to perform a transfer.
     */
    error ERC20InsufficientAllowance(address spender, uint256 allowance, uint256 needed);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC20InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `spender` to be approved. Used in approvals.
     * @param spender Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC20InvalidSpender(address spender);
}

/**
 * @dev Standard ERC-721 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-721 tokens.
 */
interface IERC721Errors {
    /**
     * @dev Indicates that an address can't be an owner. For example, `address(0)` is a forbidden owner in ERC-20.
     * Used in balance queries.
     * @param owner Address of the current owner of a token.
     */
    error ERC721InvalidOwner(address owner);

    /**
     * @dev Indicates a `tokenId` whose `owner` is the zero address.
     * @param tokenId Identifier number of a token.
     */
    error ERC721NonexistentToken(uint256 tokenId);

    /**
     * @dev Indicates an error related to the ownership over a particular token. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param tokenId Identifier number of a token.
     * @param owner Address of the current owner of a token.
     */
    error ERC721IncorrectOwner(address sender, uint256 tokenId, address owner);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC721InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC721InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param tokenId Identifier number of a token.
     */
    error ERC721InsufficientApproval(address operator, uint256 tokenId);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC721InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC721InvalidOperator(address operator);
}

/**
 * @dev Standard ERC-1155 Errors
 * Interface of the https://eips.ethereum.org/EIPS/eip-6093[ERC-6093] custom errors for ERC-1155 tokens.
 */
interface IERC1155Errors {
    /**
     * @dev Indicates an error related to the current `balance` of a `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     * @param balance Current balance for the interacting account.
     * @param needed Minimum amount required to perform a transfer.
     * @param tokenId Identifier number of a token.
     */
    error ERC1155InsufficientBalance(address sender, uint256 balance, uint256 needed, uint256 tokenId);

    /**
     * @dev Indicates a failure with the token `sender`. Used in transfers.
     * @param sender Address whose tokens are being transferred.
     */
    error ERC1155InvalidSender(address sender);

    /**
     * @dev Indicates a failure with the token `receiver`. Used in transfers.
     * @param receiver Address to which tokens are being transferred.
     */
    error ERC1155InvalidReceiver(address receiver);

    /**
     * @dev Indicates a failure with the `operator`’s approval. Used in transfers.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     * @param owner Address of the current owner of a token.
     */
    error ERC1155MissingApprovalForAll(address operator, address owner);

    /**
     * @dev Indicates a failure with the `approver` of a token to be approved. Used in approvals.
     * @param approver Address initiating an approval operation.
     */
    error ERC1155InvalidApprover(address approver);

    /**
     * @dev Indicates a failure with the `operator` to be approved. Used in approvals.
     * @param operator Address that may be allowed to operate on tokens without being their owner.
     */
    error ERC1155InvalidOperator(address operator);

    /**
     * @dev Indicates an array length mismatch between ids and values in a safeBatchTransferFrom operation.
     * Used in batch transfers.
     * @param idsLength Length of the array of token identifiers
     * @param valuesLength Length of the array of token amounts
     */
    error ERC1155InvalidArrayLength(uint256 idsLength, uint256 valuesLength);
}

// File: @openzeppelin/contracts/token/ERC20/ERC20.sol


// OpenZeppelin Contracts (last updated v5.2.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.20;





/**
 * @dev Implementation of the {IERC20} interface.
 *
 * This implementation is agnostic to the way tokens are created. This means
 * that a supply mechanism has to be added in a derived contract using {_mint}.
 *
 * TIP: For a detailed writeup see our guide
 * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
 * to implement supply mechanisms].
 *
 * The default value of {decimals} is 18. To change this, you should override
 * this function so it returns a different value.
 *
 * We have followed general OpenZeppelin Contracts guidelines: functions revert
 * instead returning `false` on failure. This behavior is nonetheless
 * conventional and does not conflict with the expectations of ERC-20
 * applications.
 */
abstract contract ERC20 is Context, IERC20, IERC20Metadata, IERC20Errors {
    mapping(address account => uint256) private _balances;

    mapping(address account => mapping(address spender => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name;
    string private _symbol;

    /**
     * @dev Sets the values for {name} and {symbol}.
     *
     * All two of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    /**
     * @dev Returns the name of the token.
     */
    function name() public view virtual returns (string memory) {
        return _name;
    }

    /**
     * @dev Returns the symbol of the token, usually a shorter version of the
     * name.
     */
    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the default value returned by this function, unless
     * it's overridden.
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view virtual returns (uint8) {
        return 18;
    }

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view virtual returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - the caller must have a balance of at least `value`.
     */
    function transfer(address to, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _transfer(owner, to, value);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view virtual returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-approve}.
     *
     * NOTE: If `value` is the maximum `uint256`, the allowance is not updated on
     * `transferFrom`. This is semantically equivalent to an infinite approval.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function approve(address spender, uint256 value) public virtual returns (bool) {
        address owner = _msgSender();
        _approve(owner, spender, value);
        return true;
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Skips emitting an {Approval} event indicating an allowance update. This is not
     * required by the ERC. See {xref-ERC20-_approve-address-address-uint256-bool-}[_approve].
     *
     * NOTE: Does not update the allowance if the current allowance
     * is the maximum `uint256`.
     *
     * Requirements:
     *
     * - `from` and `to` cannot be the zero address.
     * - `from` must have a balance of at least `value`.
     * - the caller must have allowance for ``from``'s tokens of at least
     * `value`.
     */
    function transferFrom(address from, address to, uint256 value) public virtual returns (bool) {
        address spender = _msgSender();
        _spendAllowance(from, spender, value);
        _transfer(from, to, value);
        return true;
    }

    /**
     * @dev Moves a `value` amount of tokens from `from` to `to`.
     *
     * This internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _transfer(address from, address to, uint256 value) internal {
        if (from == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        if (to == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(from, to, value);
    }

    /**
     * @dev Transfers a `value` amount of tokens from `from` to `to`, or alternatively mints (or burns) if `from`
     * (or `to`) is the zero address. All customizations to transfers, mints, and burns should be done by overriding
     * this function.
     *
     * Emits a {Transfer} event.
     */
    function _update(address from, address to, uint256 value) internal virtual {
        if (from == address(0)) {
            // Overflow check required: The rest of the code assumes that totalSupply never overflows
            _totalSupply += value;
        } else {
            uint256 fromBalance = _balances[from];
            if (fromBalance < value) {
                revert ERC20InsufficientBalance(from, fromBalance, value);
            }
            unchecked {
                // Overflow not possible: value <= fromBalance <= totalSupply.
                _balances[from] = fromBalance - value;
            }
        }

        if (to == address(0)) {
            unchecked {
                // Overflow not possible: value <= totalSupply or value <= fromBalance <= totalSupply.
                _totalSupply -= value;
            }
        } else {
            unchecked {
                // Overflow not possible: balance + value is at most totalSupply, which we know fits into a uint256.
                _balances[to] += value;
            }
        }

        emit Transfer(from, to, value);
    }

    /**
     * @dev Creates a `value` amount of tokens and assigns them to `account`, by transferring it from address(0).
     * Relies on the `_update` mechanism
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead.
     */
    function _mint(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidReceiver(address(0));
        }
        _update(address(0), account, value);
    }

    /**
     * @dev Destroys a `value` amount of tokens from `account`, lowering the total supply.
     * Relies on the `_update` mechanism.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * NOTE: This function is not virtual, {_update} should be overridden instead
     */
    function _burn(address account, uint256 value) internal {
        if (account == address(0)) {
            revert ERC20InvalidSender(address(0));
        }
        _update(account, address(0), value);
    }

    /**
     * @dev Sets `value` as the allowance of `spender` over the `owner` s tokens.
     *
     * This internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     *
     * Overrides to this logic should be done to the variant with an additional `bool emitEvent` argument.
     */
    function _approve(address owner, address spender, uint256 value) internal {
        _approve(owner, spender, value, true);
    }

    /**
     * @dev Variant of {_approve} with an optional flag to enable or disable the {Approval} event.
     *
     * By default (when calling {_approve}) the flag is set to true. On the other hand, approval changes made by
     * `_spendAllowance` during the `transferFrom` operation set the flag to false. This saves gas by not emitting any
     * `Approval` event during `transferFrom` operations.
     *
     * Anyone who wishes to continue emitting `Approval` events on the`transferFrom` operation can force the flag to
     * true using the following override:
     *
     * ```solidity
     * function _approve(address owner, address spender, uint256 value, bool) internal virtual override {
     *     super._approve(owner, spender, value, true);
     * }
     * ```
     *
     * Requirements are the same as {_approve}.
     */
    function _approve(address owner, address spender, uint256 value, bool emitEvent) internal virtual {
        if (owner == address(0)) {
            revert ERC20InvalidApprover(address(0));
        }
        if (spender == address(0)) {
            revert ERC20InvalidSpender(address(0));
        }
        _allowances[owner][spender] = value;
        if (emitEvent) {
            emit Approval(owner, spender, value);
        }
    }

    /**
     * @dev Updates `owner` s allowance for `spender` based on spent `value`.
     *
     * Does not update the allowance value in case of infinite allowance.
     * Revert if not enough allowance is available.
     *
     * Does not emit an {Approval} event.
     */
    function _spendAllowance(address owner, address spender, uint256 value) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance < type(uint256).max) {
            if (currentAllowance < value) {
                revert ERC20InsufficientAllowance(spender, currentAllowance, value);
            }
            unchecked {
                _approve(owner, spender, currentAllowance - value, false);
            }
        }
    }
}

// File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol


// OpenZeppelin Contracts (last updated v5.0.0) (token/ERC20/extensions/ERC20Capped.sol)

pragma solidity ^0.8.20;


/**
 * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
 */
abstract contract ERC20Capped is ERC20 {
    uint256 private immutable _cap;

    /**
     * @dev Total supply cap has been exceeded.
     */
    error ERC20ExceededCap(uint256 increasedSupply, uint256 cap);

    /**
     * @dev The supplied cap is not a valid cap.
     */
    error ERC20InvalidCap(uint256 cap);

    /**
     * @dev Sets the value of the `cap`. This value is immutable, it can only be
     * set once during construction.
     */
    constructor(uint256 cap_) {
        if (cap_ == 0) {
            revert ERC20InvalidCap(0);
        }
        _cap = cap_;
    }

    /**
     * @dev Returns the cap on the token's total supply.
     */
    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    /**
     * @dev See {ERC20-_update}.
     */
    function _update(address from, address to, uint256 value) internal virtual override {
        super._update(from, to, value);

        if (from == address(0)) {
            uint256 maxSupply = cap();
            uint256 supply = totalSupply();
            if (supply > maxSupply) {
                revert ERC20ExceededCap(supply, maxSupply);
            }
        }
    }
}

// File: @openzeppelin/contracts/security/ReentrancyGuard.sol


// OpenZeppelin Contracts (last updated v4.9.0) (security/ReentrancyGuard.sol)

pragma solidity ^0.8.0;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant _NOT_ENTERED = 1;
    uint256 private constant _ENTERED = 2;

    uint256 private _status;

    constructor() {
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be _NOT_ENTERED
        require(_status != _ENTERED, "ReentrancyGuard: reentrant call");

        // Any calls to nonReentrant after this point will fail
        _status = _ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = _NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == _ENTERED;
    }
}

// File: Monorite.sol


pragma solidity ^0.8.20;




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