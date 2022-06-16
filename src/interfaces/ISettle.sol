// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

interface ISettle {
    // views
    function getCurrency() external view returns (address);
    function getSettleToken() external view returns (address[] memory);
    
    function isTokenExists(address _token) external view returns (bool);
    function getTokenSettleConfig(address _token) external view returns (address, int8);
    function getWalletSettle(address account) external view returns (uint, uint);

    // actions
    function addSettleToken(address _token, address _priceLink, int8 numSigned) external returns (bool);
    function delSettleToken(address _token) external returns (bool);

    // event
    event AddSettleToken(address _sender, address _token, address _priceLink, int8 numSigned);
    event DelSettleToken(address _sender, address _token);

}