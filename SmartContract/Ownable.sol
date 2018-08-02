/**
 * filename : Ownable.sol
 *
 */

pragma solidity ^0.4.24;

/**
 * @title  Ownable
 * @notice For user and inter-contract ownership and safe ownership transfers.
 * @dev    The Ownable contract has an owner address, and provides basic
 *         authorization control functions
 */
contract Ownable
{
    address public owner;   /* the address of the contract's owner  */

    /* logged on change & renounce of owner */
    event OwnershipTransferred (address indexed _owner, address indexed _to);
    event OwnershipRenounced   (address indexed _owner);

    /**
     * @dev Sets the original 'owner' of the contract to the sender account
     */
    constructor () public 
    {
        owner = msg.sender;
    }

    /**
     * @dev Throws if called by any account other than the owner
     */
    modifier onlyOwner 
    {
        require (msg.sender == owner);
        _;
    }

    /**
     * @dev   Allows the current owner to transfer control of the contract to a '_to'
     * @param _to The address to transfer ownership to
     */
    function transferOwnership (address _to) public onlyOwner
    {
        require (_to != address(0));
        emit OwnershipTransferred (owner, _to);
        owner = _to;
    }

    /**
     * @dev   Allows the current owner to relinquish control of the contract.
     *        This will remove all ownership of the contract, _safePhrase must
     *        be equal to "This contract is to be disowned"
     * @param _safePhrase Input string to prevent one's mistake
     */
    function renounceOwnership (bytes32 _safePhrase) public onlyOwner
    {
        require (_safePhrase == "This contract is to be disowned.");
        emit OwnershipRenounced (owner);
        owner = address(0);
    }
}
