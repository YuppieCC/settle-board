// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/console.sol";
import "ds-test/test.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IPriceOracle} from "../interfaces/IPriceOracle.sol";
import {QuickswapLPTokenPrice} from "../QuickswapLPTokenPrice.sol";
import {ExponentialNoError}  from "../ExponentialNoError.sol";

contract QuickswapLPTokenPriceTest is DSTest {
    QuickswapLPTokenPrice qsToken;
    address public WMATICUSDT = 0x604229c960e5CACF2aaEAc8Be68Ac07BA9dF81c3;
    address public WATICUSD = 0xAB594600376Ec9fD91F8e885dADF0CE036862dE0;
    address public USDTUSD = 0x0A6513e40db6EB1b165753AD52E80663aeA50545;
    address public WMATIC = 0x0d500B1d8E8eF31E21C99d1Db9A6444d3ADf1270;
    address public USDT =  0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

    function setUp() public {
        qsToken = new QuickswapLPTokenPrice(
            WMATICUSDT,
            WMATIC,
            USDT,
            WATICUSD,
            USDTUSD
        );
    }

    function testLatestRoundData() public {
        (,int256 answer,,,) = qsToken.latestRoundData();
        emit log_uint(uint(answer));
        assertGt(uint(answer), 0);   
    }
}