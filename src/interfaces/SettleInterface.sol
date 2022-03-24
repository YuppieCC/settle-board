// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

interface SettleInterface {
    // views
    function getCurrency() external view returns (address);
    function getWalletToken() external view returns (address[] memory);
    // function getSavingsToken() external view returns (address[] memory);
    // function getPoolToken() external view returns (address[] memory);
    // function getDebtToken() external view returns (address[] memory);

    function getTokenPriceConfig(address _token) external view returns (address);
    function getWalletSettle(address account) external view returns (uint256);
    // function getSavingsSettle(address account) external view returns (uint256);
    // function getPoolSettle(address account) external view returns (uint256);
    // function getDebtSettle(address account) external view returns (uint256);
    // function getTotalSettle(address account) external view returns (uint256);

    // actions
    function addWalletToken(address _token, address _priceLink) external returns (bool);
    // function addSavingsToken() external;
    // function addPoolToken() external;
    // function addDebtToken() external;

    // event
    event AddWalletToken(address _sender, address _token, address _priceLink);
    // event addSavingsToken(address sender, address Token);
    // event addPoolToken(address sender, address Token);
    // event addDebtToken(address sender, address Token);

}