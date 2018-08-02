/**
 * filename : ERC20Token.sol
 *
 */

pragma solidity ^0.4.24;

import "./ERC20.sol";
import "./SafeMath.sol";

/**
 * @title TokenRecipient 
 */
interface TokenRecipient
{
    /* fundtion definitions */
    function receiveApproval (address _from, uint256 _value, address _token, bytes _extraData) external;
}

/**
 * @title ERC20Token
 * @dev   Implementation of the ERC20 Token
 */
contract ERC20Token is ERC20
{
    using SafeMath for uint256;

    /* balance of each account */
    mapping (address => uint256) balances;
    mapping (address => mapping (address => uint256)) allowed;

    string  public name;
    string  public symbol;
    uint8   public decimals;
    uint256 public totalSupply;

    /**
     * @dev   Creates a ERC20 Contract with its name, symbol, decimals, and total supply of token
     * @param _name name of token
     * @param _symbol name of symbol
     * @param _decimals decimals
     * @param _initSupply total supply of tokens
     */
    constructor (string _name, string _symbol, uint8 _decimals, uint256 _initSupply) public
    {
        name        = _name;                                    // set the name   for display purpose
        symbol      = _symbol;                                  // set the symbol for display purpose
        decimals    = _decimals;                                // 18 decimals is the strongly suggested 
        totalSupply = _initSupply * (10 ** uint256 (decimals)); // update total supply with the decimal amount
        balances[msg.sender] = totalSupply;                     // give the creator all initial tokens

        emit Transfer (address(0), msg.sender, totalSupply);
    }

    /**
     * @dev Get the token balance for account `_owner`
     */
    function balanceOf (address _owner) public view returns (uint256 balance)
    {
        return balances[_owner];
    }

    /* function to access name, symbol, decimals, total-supply of token. */
    function name        () public view returns (string  _name    ) { return name;        } 
    function symbol      () public view returns (string  _symbol  ) { return symbol;      } 
    function decimals    () public view returns (uint8   _decimals) { return decimals;    }
    function totalSupply () public view returns (uint256 _supply  ) { return totalSupply; }

    /**
     * @dev Internal transfer, only can be called by this contract
     */
    function _transfer (address _from, address _to, uint256 _value) internal
    {
        require (_to != 0x0);                               // prevent transfer to 0x0 address
        require (balances[_from] >= _value);                // check if the sender has enough
        require (balances[_to  ] +  _value > balances[_to]);// check for overflows

        uint256 previous = balances[_from] + balances[_to]; // save this for an assertion in the future

        balances[_from] = balances[_from].sub (_value);     // subtract from the sender
        balances[_to  ] = balances[_to  ].add (_value);     // add the same to the recipient
        emit Transfer (_from, _to, _value);

        /* Asserts are used to use static analysis to find bugs in your code. They should never fail */
        assert (balances[_from] + balances[_to] == previous);
    }

    /**
     * @dev    Transfer the balance from owner's account to another account "_to" 
     *         owner's account must have sufficient balance to transfer
     *         0 value transfers are allowed
     * @param  _to The address of the recipient
     * @param  _value The amount to send
     * @return true if the operation was successful.
     */
    function transfer (address _to, uint256 _value) public returns (bool success)
    {
        _transfer (msg.sender, _to, _value); return true;
    }

    /**
     * @dev    Send `_value` amount of tokens from `_from` account to `_to` account
     *         The calling account must already have sufficient tokens approved for
     *         spending from the `_from` account
     * @param  _from The address of the sender
     * @param  _to The address of the recipient
     * @param  _value The amount to send
     * @return true if the operation was successful.
     */
    function transferFrom (address _from, address _to, uint256 _value) public returns (bool success)
    {
        require (allowed[_from][msg.sender] >= _value); // check allowance 
        allowed [_from][msg.sender] = allowed [_from][msg.sender].sub (_value);

        _transfer (_from, _to, _value); return true;
    }

    /**
     * @dev    Get the amount of tokens approved by the owner that can be transferred
     *         to the spender's account
     * @param  _owner The address owner
     * @param  _spender The address authorized to spend
     * @return The amount of tokens remained for the approved by the owner that can
     *         be transferred
     */
    function allowance (address _owner, address _spender) public constant returns (uint remaining)
    {
        return allowed[_owner][_spender];
    }

    /**
     * @dev    Set allowance for other address
     *         Allow `_spender` to withdraw from your account, multiple times,
     *         up to the `_value` amount. If this function is called again it
     *         overwrites the current allowance with _value.
     *         Token owner can approve for `spender` to transferFrom (...) `tokens`
     *         from the token owner's account
     * @param  _spender The address authorized to spend
     * @param  _value the max amount they can spend
     * @return true if the operation was successful.
     */
    function approve (address _spender, uint256 _value) public returns (bool success)
    {
        allowed[msg.sender][_spender] = _value;
        emit Approval (msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev    Set allowance for other address and notify
     *         Allows `_spender` to spend no more than `_value` tokens in your behalf,
     *         and then ping the contract about it
     * @param  _spender   the address authorized to spend
     * @param  _value     the max amount they can spend
     * @param  _extraData some extra information to send to the approved contract
     * @return true if the operation was successful.
     */
    function approveAndCall (address _spender, uint256 _value, bytes _extraData) public returns (bool success)
    {
        TokenRecipient spender = TokenRecipient (_spender);

        if (approve (_spender, _value))
        {
            spender.receiveApproval (msg.sender, _value, address (this), _extraData);
            return true;
        }
    }
}
