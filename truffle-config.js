const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",     // Localhost (default: none)
      port: 8545,            // Standard Ethereum port (default: none)
      network_id: "*",       // Any network (default: none)
    },
    matic: {
      provider: () => new HDWalletProvider(mnemonic, `https://rpc-mumbai.maticvigil.com`),
      network_id: 80001,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true
    },
  },  
  plugins: [
    'truffle-plugin-verify'
  ],
  compilers: {
    solc: {
      version: "0.5.16",
      // optimizer: {
      //   enabled: true,
      //   runs: 200
      // }
    }
  },
  api_keys: {
    polygonscan: ""
  }
}
