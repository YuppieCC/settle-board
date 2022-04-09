// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;

interface IQuickswapLPTokenPrice {
    function getTokenSettle(
        uint tokenAmount, 
        uint tokenPrice, 
        uint amountDeciamls, 
        uint priceDecimals
    ) external view returns (uint);

    function setLpOraclePriceConfig(address _token, address _oracleLink) external;
    function latestRoundData(address lpToken) external returns (uint);
}