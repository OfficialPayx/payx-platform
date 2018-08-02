/**
 * filename : ERC20.sol
 *
 */

pragma solidity ^0.4.24;

/**
 * @title ERC20
 * @dev   ERC20 Contract interface(s)
 */
contract ERC20
{
    function balanceOf    (address _owner) public constant returns (uint256 balance);
    function transfer     (               address _to, uint256 _value) public returns (bool success);
    function transferFrom (address _from, address _to, uint256 _value) public returns (bool success);
    function approve      (address _spender, uint256 _value) public returns (bool success);
    function allowance    (address _owner, address _spender) public constant returns (uint256 remaining);
    function totalSupply  () public constant returns (uint);

    event Transfer (address indexed _from,  address indexed _to,      uint _value);
    event Approval (address indexed _owner, address indexed _spender, uint _value);
}

