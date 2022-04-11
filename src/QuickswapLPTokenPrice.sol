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
  
    address public lpToken;
    address public token0;
    address public token1;
    address public token0Oracle;
    address public token1Oracle;

    constructor(address _lpToken, address _token0, address _token1, address _token0Oracle, address _token1Oracle) {
        lpToken = _lpToken;        
        token0 = _token0;
        token1 = _token1;
        token0Oracle = _token0Oracle;
        token1Oracle = _token1Oracle;   
    }

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
        uint _settle = mul_(tokenAmount, tokenPrice);
        uint _valueDecimals = add_(amountDeciamls, priceDecimals);

        if (_valueDecimals > decimals) {
            uint diffDecimals = sub_(_valueDecimals, decimals);
            return div_(_settle, 10 ** diffDecimals);
        } else {
            uint diffDecimals = sub_(decimals, _valueDecimals);
            return mul_(_settle, 10 ** diffDecimals);
        }
    }
    
    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    ) {
        (uint reserve0, uint reserve1, ) = IUniswapV2Pair(lpToken).getReserves();
        uint totalSupply = IUniswapV2Pair(lpToken).totalSupply();
        (,int256 answer0,,,) = IPriceOracle(token0Oracle).latestRoundData();
        (,int256 answer1,,,) = IPriceOracle(token1Oracle).latestRoundData();

        uint settle0 = getTokenSettle(
            reserve0,
             uint(answer0),
             IERC20(token0).decimals(),
             IPriceOracle(token0Oracle).decimals()
        );
        uint settle1 = getTokenSettle(
            reserve1,
            uint(answer1),
            IERC20(token1).decimals(),
            IPriceOracle(token1Oracle).decimals()
        );
      
        uint settle = add_(settle0, settle1);
        uint price = mul_(div_(settle, totalSupply), 10 ** decimals);
        return (1, int(price), 1, 1, 1);
    }
}