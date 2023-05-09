/* Note:
Replace `<infura-project-id>` with your Infura project ID and `<your-mnemonic>` with your mnemonic for the wallet you will be using to deploy the smart contracts. 
This configuration file includes network configurations for the local development network, Ropsten, and Mainnet. It also specifies the Solidity compiler version and enables optimization.*/


const HDWalletProvider = require('@truffle/hdwallet-provider');
const infuraKey = "!!<infura-project-id>!! READ ABOVE NOTE"; // read above note 
const mnemonic = "!!<your-mnemonic>!! READ ABOVE NOTE"; //  read above note 

module.exports = 
{
  networks: 
  {
    development: 
    {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*",
    },
    ropsten: 
    {
      provider: () => new HDWalletProvider(mnemonic, `https://ropsten.infura.io/v3/${infuraKey}`),
      network_id: 3,
      gas: 5500000,
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
    mainnet: {
      provider: () => new HDWalletProvider(mnemonic, `https://mainnet.infura.io/v3/${infuraKey}`),
      network_id: 1,
      gasPrice: 10000000000, // 10 gwei
      confirmations: 2,
      timeoutBlocks: 200,
      skipDryRun: true,
    },
  },
  compilers: {
    solc: {
      version: "0.8.9",
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
};
