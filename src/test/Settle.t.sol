// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../interfaces/IERC20.sol"; 
import "../Settle.sol";

contract SettleTest is DSTest {
    Settle settle;
    address public chip = 0xfd29982Fa0b7d3eDcaE9B0c49D350C07c7cEC5c1;
    address public currency = 0xe19B95fB3bDE006E436c7C83DCb8018D55671490;
    address public sam = 0x16EAF3c5201F57A9cc0B35688269c082e215627c;
    
    function setUp() public {
        settle = new Settle(currency);
    }

    function testExample() public {
        assertTrue(true);
    }

    function testSettleOwner() public {
        assertEq(settle.owner(), address(this));
    }

    function testCurrency() public {
        assertEq(settle.getCurrency(), currency);
    }
    
    function testAddWalletToken() public {
        assertTrue(settle.addWalletToken(chip));
    }

    function testGetWalletSettle() public {
        settle.addWalletToken(chip);
        uint chipBalance = IERC20(chip).balanceOf(sam);
        assertEq(settle.getWalletSettle(sam), chipBalance);
    }
}
