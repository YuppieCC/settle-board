// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

interface SettleInterface {
    // views
    function getCurrency() external view returns (address);
    function getWalletToken() external view returns (address[] memory);
    
    function isTokenExists(address _token) external view returns (bool);
    function getTokenSettleConfig(address _token) external view returns (address, int8);
    function getWalletSettle(address account) external view returns (uint, uint);

    // actions
    function addWalletToken(address _token, address _priceLink, int8 numSigned) external returns (bool);
    function delWalletToken(address _token) external returns (bool);

    // event
    event AddWalletToken(address _sender, address _token, address _priceLink, int8 numSigned);
    event DelWalletToken(address _sender, address _token);

}