// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/console.sol";
import {SettleInterface} from "./SettleInterface.sol";
import {IPriceOracle} from "./interfaces/IPriceOracle.sol";
import {IERC20} from "./interfaces/IERC20.sol"; 
import {SafeMath} from "./interfaces/SafeMath.sol";
import {ExponentialNoError}  from "./ExponentialNoError.sol";

contract Settle is SettleInterface, ExponentialNoError {
    using SafeMath for uint;

    uint8 public decimals = 18;
    address public owner;
    address public currency;
    address[] public walletToken;
    struct Config {
        address oracleLink;
        int8 numSigned;
    }

    mapping(address => Config) public tokenSettleConfig;

    constructor(address _currency) {
        owner = msg.sender;
        currency = _currency;
    }

     function isTokenExists(address _token) public view returns (bool) {
        (address _oracleLink,) = getTokenSettleConfig(_token);
        return _oracleLink != address(0);
    }

    function getCurrency() external view returns (address) {
        return currency;
    }

    function getWalletToken() external view returns (address[] memory) {
        return walletToken;
    }

    function getTokenSettleConfig(address _token) public view returns (address, int8) {
        Config memory config =  tokenSettleConfig[_token];
        return (config.oracleLink, config.numSigned);
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

    function getWalletSettle(address account) external view returns (uint, uint) {
        uint value;
        uint debt;
        uint len = walletToken.length;
        for (uint i = 0; i < len; i++) {
            (address oracleLink, int8 numSigned) = getTokenSettleConfig(walletToken[i]);
            (,int256 answer,,,) = IPriceOracle(oracleLink).latestRoundData();
            if (answer == 0) {
                continue;
            }

            IERC20 wallet_token = IERC20(walletToken[i]);
            uint balance = wallet_token.balanceOf(account);
            uint _settle = getTokenSettle(
                balance, 
                uint(answer), 
                wallet_token.decimals(),  
                IPriceOracle(oracleLink).decimals()
            );
            if (numSigned == 1) {
                value = add_(_settle, value);
            } else {
                debt = add_(_settle, debt);
            }
        }
        return (value, debt);
    }
   
    function addWalletToken(address _token, address _priceLink, int8 _numSigned) external returns (bool) {
        require(msg.sender == owner, "permission denied");
        require(isTokenExists(_token) == false, "token already exists");

        walletToken.push(_token);
        tokenSettleConfig[_token] = Config({oracleLink: _priceLink, numSigned: _numSigned});
        emit AddWalletToken(msg.sender, _token, _priceLink, _numSigned);
        return true;
    }

    function delWalletToken(address _token) external returns (bool) {
        require(msg.sender == owner, "permission denied");
        require(isTokenExists(_token), "token not found");

        uint len = walletToken.length;
        for (uint i = 0; i < len; i++) {
            if (walletToken[i] == _token) {
                delete walletToken[i];
            }
        }
        delete tokenSettleConfig[_token];
        emit DelWalletToken(msg.sender, _token);
        return true;
    }

}