// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/console.sol";
import {IQuickswapLPTokenPrice} from "./interfaces/IQuickswapLPTokenPrice.sol";
import {IPriceOracle} from "./interfaces/IPriceOracle.sol";
import {IUniswapV2Pair} from "./interfaces/IUniswapV2Pair.sol";
import {IERC20} from "./interfaces/IERC20.sol";
import {ExponentialNoError}  from "./ExponentialNoError.sol";


contract QuickswapLPTokenPrice is IQuickswapLPTokenPrice, ExponentialNoError{
    uint8 public decimals = 18;
    mapping(address => address) public lpOraclePriceConfig;

    function countDecimals(uint balanceDecimals, uint priceDecimals) public view returns (int8, uint) {
        uint _decimals = uint(decimals);
        uint _valueDecimals = add_(balanceDecimals, priceDecimals);
        if (_valueDecimals > _decimals) {
            return (1, sub_(_valueDecimals, _decimals));
        } else {
            return (-1, sub_(_decimals, _valueDecimals));
        }
    }

    function getTokenSettle(
        uint tokenAmount, 
        uint tokenPrice, 
        uint amountDeciamls, 
        uint priceDecimals
    ) public view returns (uint) {

        uint _decimals = uint(decimals);
        uint _settle = mul_(tokenAmount, tokenPrice);
        uint _valueDecimals = add_(amountDeciamls, priceDecimals);

        if (_valueDecimals > _decimals) {
            uint diffDecimals = sub_(_valueDecimals, _decimals);
            return div_(_settle, 10 ** diffDecimals);
        } else {
            uint diffDecimals = sub_(_decimals, _valueDecimals);
            return mul_(_settle, 10 ** diffDecimals);
        }
    }

    function setLpOraclePriceConfig(address _token, address _oracleLink) external {
        lpOraclePriceConfig[_token] = _oracleLink;
    }
    
    function latestRoundData(address lpToken) external view returns (uint) {
        (uint reserve0, uint reserve1, ) = IUniswapV2Pair(lpToken).getReserves();
        uint totalSupply = IUniswapV2Pair(lpToken).totalSupply();
        address token0 = IUniswapV2Pair(lpToken).token0();
        address token1 = IUniswapV2Pair(lpToken).token1();

        address token0PriceLink = lpOraclePriceConfig[token0];
        address token1PriceLink = lpOraclePriceConfig[token1];
        (,int256 answer0,,,) = IPriceOracle(token0PriceLink).latestRoundData();
        (,int256 answer1,,,) = IPriceOracle(token1PriceLink).latestRoundData();

        uint settle0 = getTokenSettle(
            reserve0,
             uint(answer0),
             IERC20(token0).decimals(),
             IPriceOracle(token0PriceLink).decimals()
        );
        uint settle1 = getTokenSettle(
            reserve1,
            uint(answer1),
            IERC20(token1).decimals(),
            IPriceOracle(token1PriceLink).decimals()
        );
      
        uint settle = add_(settle0, settle1);
        uint price = div_(settle, totalSupply);

        return mul_(price, 10 ** decimals);
    }
}