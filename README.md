## Settle Board

## Overview

To make DeFi assets accessible and easy to track.The `settle` Contract can  display the networth and debt of account. Build an allowlist of asset tokens, map their Oracle, and return their asset value.


> But how to fetch the price of a liquidity pool ？
> I build a LP-Token Oracle Factory, it can generate an oracle contract for different pools.

[![XOuWXn.png](https://s1.ax1x.com/2022/06/18/XOuWXn.png)](https://imgtu.com/i/XOuWXn)

## Usage
When all contracts have been deployed, you can set the token allowlist, and call the `getWalletSettle()` method to fetch the `networth` and `debt`.
```solidity
settle.addSettleToken(
    0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174,  # USDC Token Address 
    0xfE4A8cc5b5B2366C1B58Bea3858e81843581b2F7,  # USDC/USD Oracle Address    
    1,  # balance: 1, debt: -1;
);
(uint value, uint debt) = settle.getWalletSettle(<yourAccountAddress>);
```

## Contracts

Name | Code | Address | Network
------------ | ------------- | ------------- | -------------
Settle |[GitHub](https://github.com/YuppieCC/settle-board/blob/master/src/Settle.sol)|[0xCde4d3522D80508bD06dbC36A2BAb4c70bf8584A](https://polygonscan.com/address/0xCde4d3522D80508bD06dbC36A2BAb4c70bf8584A) | Polygon
QuickswapOracleFactory |[GitHub](https://github.com/YuppieCC/settle-board/blob/master/src/QuickswapOracleFactory.sol) | [0x233D03a3B34d3f74F21608E57ACD51350Cff2935](https://polygonscan.com/address/0x233D03a3B34d3f74F21608E57ACD51350Cff2935) | Polygon

## Development

```Shell
# Apply an ETHERSCAN_KEY: https://polygonscan.com/apis
# PRIVATE_KEY: Export from your Wallet
cp .env.example .env
make test

# if tests all passed, deploy all contracts.
# scripting is a way to declaratively deploy contracts using Solidity
# instead of using the more limiting and less user friendly `forge create`.
make scripting

# if scripting isn't ok, you can deploy a single contract at once time.
make deploy-contract DEPLOY_CONTRACT={DEPLOY_CONTRACT}
```

## Gas Reports

```
╭──────────────────────┬─────────────────┬────────┬────────┬────────┬─────────╮
│ Settle contract      ┆                 ┆        ┆        ┆        ┆         │
╞══════════════════════╪═════════════════╪════════╪════════╪════════╪═════════╡
│ Deployment Cost      ┆ Deployment Size ┆        ┆        ┆        ┆         │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ 968768               ┆ 4867            ┆        ┆        ┆        ┆         │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ Function Name        ┆ min             ┆ avg    ┆ median ┆ max    ┆ # calls │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ addSettleToken       ┆ 47934           ┆ 52511  ┆ 47934  ┆ 69834  ┆ 49      │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ delSettleToken       ┆ 12882           ┆ 12882  ┆ 12882  ┆ 12882  ┆ 1       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ getTokenSettleConfig ┆ 731             ┆ 731    ┆ 731    ┆ 731    ┆ 1       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ getWalletSettle      ┆ 291999          ┆ 291999 ┆ 291999 ┆ 291999 ┆ 1       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ isTokenExists        ┆ 765             ┆ 1431   ┆ 765    ┆ 2765   ┆ 3       │
├╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌┼╌╌╌╌╌╌╌╌╌┤
│ owner                ┆ 2420            ┆ 2420   ┆ 2420   ┆ 2420   ┆ 1       │
╰──────────────────────┴─────────────────┴────────┴────────┴────────┴─────────╯
```

