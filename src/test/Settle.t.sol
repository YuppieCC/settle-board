// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;


import "ds-test/console.sol";
import "ds-test/test.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IPriceOracle} from "../interfaces/IPriceOracle.sol";
import {Settle} from "../Settle.sol";
import {ExponentialNoError}  from "../ExponentialNoError.sol";

contract SettleTest is ExponentialNoError, DSTest {
    Settle settle;
    address public chip = 0xfd29982Fa0b7d3eDcaE9B0c49D350C07c7cEC5c1;
    address public currency = 0xe19B95fB3bDE006E436c7C83DCb8018D55671490;
    address public sam = 0x16EAF3c5201F57A9cc0B35688269c082e215627c;
    int8 public positiveNumSigned = 1;
    int8 public negativeNumSigned = -1;

    address public mumbaiBTCUSD = 0x007A22900a3B98143368Bd5906f8E17e9867581b;
    address public mumbaiUSDTUSD = 0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0;
    
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
        settle.addWalletToken(chip, mumbaiBTCUSD, positiveNumSigned);
        (address _oracleLink, int8 _numSigned) = settle.getTokenSettleConfig(chip);
        assertEq(_oracleLink, mumbaiBTCUSD);
        assertLe(_numSigned, positiveNumSigned);
    }
    
    function testAddWalletToken() public {
        assertTrue(settle.addWalletToken(chip, mumbaiBTCUSD, positiveNumSigned));
    }

    function testIsTokenExists() public {
        assertTrue(settle.addWalletToken(chip, mumbaiBTCUSD, positiveNumSigned));
        assertTrue(settle.isTokenExists(chip));
        assertTrue(!settle.isTokenExists(sam));
    }

    function testGetWalletSettle() public {
        settle.addWalletToken(chip, mumbaiUSDTUSD, positiveNumSigned);
        settle.addWalletToken(currency, mumbaiBTCUSD, negativeNumSigned);
        (uint value, uint debt) = settle.getWalletSettle(sam);
        emit log_uint(value);
        emit log_uint(debt);
        assertGt(value, 0);
        assertGt(debt, 0);
    }

    function testDelWalletToken() public {
        assertTrue(settle.addWalletToken(chip, mumbaiBTCUSD, positiveNumSigned));
        assertTrue(settle.delWalletToken(chip));
        assertTrue(!settle.isTokenExists(chip));
    }

    function testExponential() public {
        uint dec = IERC20(chip).balanceOf(sam);
        Exp memory _res = Exp({mantissa: dec});
        console.log("exp", _res.mantissa);

        uint _test = truncate(_res);
        console.log("truncate", _test);

        uint _mul_ScalarTruncate = mul_ScalarTruncate(_res, 2);
        console.log("mul_ScalarTruncate", _mul_ScalarTruncate);
    }
}
