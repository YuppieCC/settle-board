// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;


import "ds-test/console.sol";
import "ds-test/test.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IPriceOracle} from "../interfaces/IPriceOracle.sol";
import {Settle} from "../Settle.sol";
import {QuickswapOracleFactory} from "../QuickswapOracleFactory.sol";
import {ExponentialNoError}  from "../lib/ExponentialNoError.sol";

contract SettleTest is ExponentialNoError, DSTest {
    Settle settle;
    QuickswapOracleFactory qsOracleFactory;
    address public qsToken;
    address public chip = 0xfd29982Fa0b7d3eDcaE9B0c49D350C07c7cEC5c1;
    address public currency = 0xe19B95fB3bDE006E436c7C83DCb8018D55671490;
    address public sam = 0x16EAF3c5201F57A9cc0B35688269c082e215627c;
    address public myself = 0x6F82E3cc2a3d6b7A6d98e7941BCadd7f52919D53;
    address public SYTEST3 = 0xE3052163A213bD13fDB88dCfb00363d808d5DEf1;

    int8 public positiveNumSigned = 1;
    int8 public negativeNumSigned = -1;

    address public mumbaiBTCUSD = 0x007A22900a3B98143368Bd5906f8E17e9867581b;
    address public mumbaiUSDTUSD = 0x572dDec9087154dC5dfBB1546Bb62713147e0Ab0;

    // address public REWARD_WMATICUSDT = 0xc0eb5d1316b835F4B584B59f922d9c87cA5053E5;
    // address public WMATICUSDT = 0x604229c960e5CACF2aaEAc8Be68Ac07BA9dF81c3;
    address public MATIC = 0x0000000000000000000000000000000000001010;
    address public WMATICUSDC = 0x6e7a5FAFcec6BB1e78bAE2A1F0B612012BF14827;
    address public WATICUSD = 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0;
    address public USDTUSD = 0x0A6513e40db6EB1b165753AD52E80663aeA50545;
    address public WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address public USDT =  0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

    address public maticPrice = 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0;
    
    function setUp() public {
        settle = new Settle(currency);
        qsOracleFactory = new QuickswapOracleFactory();
        qsToken = qsOracleFactory.createOracleFeed(
            "WMATIC-USDC",
            WMATICUSDC,
            WMATIC,
            USDT,
            WATICUSD,
            USDTUSD
        );
    }

    function testExample() public {
        assertTrue(true);
    }
    
    // function testSettleOwner() public {
    //     assertEq(settle.owner(), address(this));
    // }

    // function testGetCurrency() public {
    //     assertEq(settle.getCurrency(), currency);
    // }

    // function testGetTokenPriceConfig() public {
    //     settle.addSettleToken(chip, mumbaiBTCUSD, positiveNumSigned);
    //     (address _oracleLink, int8 _numSigned) = settle.getTokenSettleConfig(chip);
    //     assertEq(_oracleLink, mumbaiBTCUSD);
    //     assertLe(_numSigned, positiveNumSigned);
    // }
    
    // function testAddSettleToken() public {
    //     assertTrue(settle.addSettleToken(chip, mumbaiBTCUSD, positiveNumSigned));
    // }

    // function testIsTokenExists() public {
    //     assertTrue(settle.addSettleToken(chip, mumbaiBTCUSD, positiveNumSigned));
    //     assertTrue(settle.isTokenExists(chip));
    //     assertTrue(!settle.isTokenExists(sam));
    // }

    function testGetWalletSettle() public {
        // settle.addSettleToken(chip, mumbaiUSDTUSD, positiveNumSigned);
        // settle.addSettleToken(currency, mumbaiBTCUSD, negativeNumSigned);
        settle.addSettleToken(WMATICUSDC, address(qsToken), positiveNumSigned);
        settle.addSettleToken(WMATIC, maticPrice, positiveNumSigned);
        settle.addSettleToken(MATIC, maticPrice, positiveNumSigned);
        (uint value, uint debt) = settle.getWalletSettle(myself);
        emit log_uint(value);
        emit log_uint(debt);
        // assertGt(value, 0);
        // assertGt(debt, 0);
    }

    // function testDelSettleToken() public {
    //     assertTrue(settle.addSettleToken(chip, mumbaiBTCUSD, positiveNumSigned));
    //     assertTrue(settle.delSettleToken(chip));
    //     assertTrue(!settle.isTokenExists(chip));
    // }

    // function testExponential() public {
    //     uint dec = IERC20(WMATIC).balanceOf(sam);
    //     Exp memory _res = Exp({mantissa: dec});
    //     console.log("exp", _res.mantissa);

    //     uint _test = truncate(_res);
    //     console.log("truncate", _test);

    //     uint _mul_ScalarTruncate = mul_ScalarTruncate(_res, 2);
    //     console.log("mul_ScalarTruncate", _mul_ScalarTruncate);
    // }
}
