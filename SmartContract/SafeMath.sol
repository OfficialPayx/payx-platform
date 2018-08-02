/**
 * filename : SafeMath.sol
 *
 */

pragma solidity ^0.4.24;


/**
 * @title SafeMath math library
 * @dev   Math operations with safety checks that throw on error
 */
library SafeMath
{
    /**
     * @dev 'a + b', Adds two numbers, throws on overflow
     */
    function add (uint256 a, uint256 b) internal pure returns (uint256 c)
    {
        c = a + b;
        require (c >= a); return c;
    }

    /**
     * @dev 'a - b', Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend)
     */
    function sub (uint256 a, uint256 b) internal pure returns (uint256 c)
    {
        require (a >= b);
        c = a - b; return c;
    }

    /**
     * @dev 'a * b', multiplies two numbers, throws on overflow
     */
    function mul (uint256 a, uint256 b) internal pure returns (uint256 c)
    {
        c = a * b;
        require (a == 0 || c / a == b); return c;
    }

    /**
     * @dev 'a / b', Integer division of two numbers, truncating the quotient
     */
    function div (uint256 a, uint256 b) internal pure returns (uint256 c)
    {
        require (b > 0);
        c = a / b; return c;
    }
}
