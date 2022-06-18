// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {IPriceOracle} from "./interfaces/IPriceOracle.sol";
import {IUniswapV2Pair} from "./interfaces/IUniswapV2Pair.sol";
import {IERC20} from "./interfaces/IERC20.sol";
import {ExponentialNoError}  from "./lib/ExponentialNoError.sol";
import {BaseSettleMath} from "./BaseSettleMath.sol";


contract QuickswapOracleFeed is BaseSettleMath {  
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
    
    // get latest price of lp token
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