// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/console.sol";
import {Ownable} from "./openzepplin/Ownable.sol";
import {ISettle} from "./interfaces/ISettle.sol";
import {IPriceOracle} from "./interfaces/IPriceOracle.sol";
import {IERC20} from "./interfaces/IERC20.sol"; 
import {SafeMath} from "./openzepplin/SafeMath.sol";
import {BaseSettleMath} from "./BaseSettleMath.sol";

contract Settle is BaseSettleMath, Ownable {
    using SafeMath for uint;

    // address public currency;
    address[] public settleToken;
    struct Config {
        address oracleLink;
        int8 numSigned;
    }

    mapping(address => Config) public tokenSettleConfig;

    // constructor(address _currency) {
    //     currency = _currency;
    // }

     function isTokenExists(address _token) public view returns (bool) {
        (address _oracleLink,) = getTokenSettleConfig(_token);
        return _oracleLink != address(0);
    }

    function getSettleToken() external view returns (address[] memory) {
        return settleToken;
    }

    function getTokenSettleConfig(address _token) public view returns (address, int8) {
        Config memory config =  tokenSettleConfig[_token];
        return (config.oracleLink, config.numSigned);
    }

    function getWalletSettle(address account) external view returns (uint, uint) {
        uint value;
        uint debt;
        uint len = settleToken.length;
        for (uint i = 0; i < len; i++) {
            (address oracleLink, int8 numSigned) = getTokenSettleConfig(settleToken[i]);
            (,int256 answer,,,) = IPriceOracle(oracleLink).latestRoundData();
            if (answer == 0) {
                continue;
            }

            IERC20 wallet_token = IERC20(settleToken[i]);
            uint balance = wallet_token.balanceOf(account);
            uint _settle = getTokenSettle(
                balance, 
                uint(answer), 
                wallet_token.decimals(),  
                IPriceOracle(oracleLink).decimals()
            );
            console.log("settle:", _settle);
            if (numSigned == 1) {
                value = add_(_settle, value);
            } else {
                debt = add_(_settle, debt);
            }
        }
        console.log("getWalletSettle", value, debt);
        return (value, debt);
    }
   
    function addSettleToken(address _token, address _priceLink, int8 _numSigned) external onlyOwner returns (bool) {
        require(isTokenExists(_token) == false, "token already exists");

        settleToken.push(_token);
        tokenSettleConfig[_token] = Config({oracleLink: _priceLink, numSigned: _numSigned});
        emit AddSettleToken(msg.sender, _token, _priceLink, _numSigned);
        return true;
    }

    function delSettleToken(address _token) external onlyOwner returns (bool) {
        require(isTokenExists(_token), "token not found");

        uint len = settleToken.length;
        for (uint i = 0; i < len; i++) {
            if (settleToken[i] == _token) {
                delete settleToken[i];
            }
        }
        delete tokenSettleConfig[_token];
        emit DelSettleToken(msg.sender, _token);
        return true;
    }

    event AddSettleToken(address indexed sender, address token, address priceLink, int8 numSigned);
    event DelSettleToken(address indexed sender, address token);
}