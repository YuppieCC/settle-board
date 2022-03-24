// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "../interfaces/IERC20.sol";
import "../interfaces/AggregatorV3Interface.sol";
import "../Settle.sol";

contract SettleTest is DSTest {
    Settle settle;
    address public chip = 0xfd29982Fa0b7d3eDcaE9B0c49D350C07c7cEC5c1;
    address public currency = 0xe19B95fB3bDE006E436c7C83DCb8018D55671490;
    address public sam = 0x16EAF3c5201F57A9cc0B35688269c082e215627c;

    address public mumbaiBTCUSD = 0x007A22900a3B98143368Bd5906f8E17e9867581b;
    
    function setUp() public {
        settle = new Settle(currency);
    }

    function testExample() public {
        assertTrue(true);
    }

    function testSettleOwner() public {
        assertEq(settle.owner(), address(this));
    }

    function testGetCurrency() public {
        assertEq(settle.getCurrency(), currency);
    }

    function testGetTokenPriceConfig() public {
        assertEq(settle.getCurrency(), currency);
    }
    
    function testAddWalletToken() public {
        assertTrue(settle.addWalletToken(chip, mumbaiBTCUSD));
        assertEq(settle.getTokenPriceConfig(chip), mumbaiBTCUSD);
    }

    function testGetWalletSettle() public {
        settle.addWalletToken(chip, mumbaiBTCUSD);
        uint result = settle.getWalletSettle(sam);
        emit log_uint(result);
        assertGt(result, 0);
    }
}
