// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./SettleInterface.sol";
import "./interfaces/AggregatorV3Interface.sol";
import "./interfaces/IERC20.sol"; 
import "./interfaces/SafeMath.sol";

contract Settle is SettleInterface {
    using SafeMath for uint;

    address public owner;
    address public currency;
    address[] public walletToken;
    mapping(address => address) public tokenPriceConfig;

    constructor(address _currency) {
        owner = msg.sender;
        currency = _currency;
    }

    function getCurrency() external view returns (address) {
        return currency;
    }

    function getWalletToken() external view returns (address[] memory) {
        return walletToken;
    }

    function getTokenPriceConfig(address _token) external view returns (address) {
        return tokenPriceConfig[_token];
    }

    function getWalletSettle(address account) external view returns (uint) {
        uint result;
        uint len = walletToken.length;
        for (uint i = 0; i < len; i++) {
            IERC20 wallet_token = IERC20(walletToken[i]);
            uint _balance = wallet_token.balanceOf(account);
            (,int256 answer,,,) = AggregatorV3Interface(tokenPriceConfig[walletToken[i]]).latestRoundData();
            uint _price = uint(answer);
            uint _settle = _balance.mul(_price);
            result = result.add(_settle);
        }
        return result;
    }

    function isTokenExists(address _token) public view returns (bool) {
        for (uint i = 0; i < walletToken.length; i++) {
            if (walletToken[i] == _token) {
                return true;
            }
        }
        return false;
    }

    function addWalletToken(address _token, address _priceLink) external returns (bool) {
        require(msg.sender == owner, "permission denied");
        require(isTokenExists(_token) == false, "token already exists");

        walletToken.push(_token);
        tokenPriceConfig[_token] = _priceLink;
        emit AddWalletToken(msg.sender, _token, _priceLink);
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
        delete tokenPriceConfig[_token];
        emit DelWalletToken(msg.sender, _token);
        return true;
    }

}