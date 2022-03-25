## Settle Protocol

### Deploy
```code
forge create --rpc-url <your_rpc_url> --private-key <your_private_key> src/Settle.sol:Settle
```

### Verify
```code
forge verify-contract --chain-id 80001 --num-of-optimizations 200 --constructor-args <constructor_abi_encoded> --compiler-version v0.8.10+commit.fc410830 <the_contract_address> src/Settle.sol:Settle <your_etherscan_api_key>
```

### Verify Check
```code
forge verify-check --chain-id 80001 <GUID> <your_etherscan_api_key>
```

