// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import {ExponentialNoError}  from "./lib/ExponentialNoError.sol";
import {SafeMath} from "./openzepplin/SafeMath.sol";

contract BaseSettleMath is ExponentialNoError {
    using SafeMath for uint;
    uint8 public decimals = 18;

    function countDecimals(uint balanceDecimals, uint priceDecimals) public view returns (int8, uint) {
        uint _decimals = uint(decimals);
        uint _valueDecimals = add_(balanceDecimals, priceDecimals);
        if (_valueDecimals > _decimals) {
            return (1, sub_(_valueDecimals, _decimals));
        } else {
            return (-1, sub_(_decimals, _valueDecimals));
        }
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
}