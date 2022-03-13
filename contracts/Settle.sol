pragma solidity ^0.5.16;

import "./SettleInterface.sol";

contract Settle is SettleInterface {
    address public owner;
    address public currency;
    address[] public walletToken;

    constructor(address _currency) public {
        owner = msg.sender;
        currency = _currency;
    }

    function getCurrency() external view returns (address) {
        return currency;
    }

    function getWalletToken() external view returns (address[] memory) {
        return walletToken;
    }

    function addWalletToken(address _token) external returns (bool) {
        require(msg.sender == owner, "permission denied");
        walletToken.push(_token);
        emit AddWalletToken(msg.sender, _token);
        return true;
    }

}