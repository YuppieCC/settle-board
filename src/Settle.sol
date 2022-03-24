// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./interfaces/SettleInterface.sol";
import "./interfaces/IERC20.sol"; 
import "./interfaces/SafeMath.sol";

contract Settle is SettleInterface {
    using SafeMath for uint;

    address public owner;
    address public currency;
    address[] public walletToken;

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

    function getWalletSettle(address account) external view returns (uint) {
        uint result;
        uint len = walletToken.length;
        for (uint i = 0; i < len; i++) {
            IERC20 wallet_token = IERC20(walletToken[i]);
            uint _balance = wallet_token.balanceOf(account);
            result = result.add(_balance);
        }
        return result;
    }

    function addWalletToken(address _token) external returns (bool) {
        require(msg.sender == owner, "permission denied");
        walletToken.push(_token);
        emit AddWalletToken(msg.sender, _token);
        return true;
    }

}