// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {QuickswapOracleFeed} from "./QuickswapOracleFeed.sol";
import {Ownable} from "./openzepplin/Ownable.sol";

contract QuickswapOracleFactory is Ownable {
    struct OracleInfo {
        string OracleName;
        address lpToken;
        address token0;
        address token1; 
        address token0Oracle;
        address token1Oracle;
    }

    mapping(address => OracleInfo) public oracleInfo;

    function createOracleFeed(
        string memory _oracleName,
        address _lpToken, 
        address _token0, 
        address _token1,
        address _token0Oracle, 
        address _token1Oracle
    ) external onlyOwner returns (address) {
        address OracleFeed = address(new QuickswapOracleFeed(_lpToken, _token0, _token1, _token0Oracle, _token1Oracle));
        OracleInfo memory info = OracleInfo({
            OracleName: _oracleName,
            lpToken: _lpToken,
            token0: _token0,
            token1: _token1,
            token0Oracle: _token0Oracle,
            token1Oracle: _token1Oracle
        });
        oracleInfo[OracleFeed] = info;
        emit CreateOracleFeed(_lpToken, _token0, _token1, _token0Oracle, _token1Oracle, OracleFeed);
        return OracleFeed;
    }

    event CreateOracleFeed(
        address _lpToken, 
        address _token0, 
        address _token1, 
        address _token0Oracle, 
        address _token1Oracle,
        address OracleFeed
    );
}