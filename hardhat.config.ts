require('dotenv').config();

import '@nomiclabs/hardhat-ethers';
import '@nomiclabs/hardhat-etherscan';
import '@nomiclabs/hardhat-waffle';
import '@typechain/hardhat';
import 'hardhat-abi-exporter';
import 'hardhat-deploy';
import 'hardhat-gas-reporter';
import 'hardhat-spdx-license-identifier';
import "@openzeppelin/hardhat-upgrades";
import { HardhatUserConfig } from 'hardhat/config';

/** @type import('hardhat/config').HardhatUserConfig */
const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.9',
    settings: {
      optimizer: {
        enabled: true,
        runs: 1000,
      },
    },
  },
  paths: {
    artifacts: './build/artifacts',
    cache: './build/cache',
  },
  typechain: {
    outDir: './types',
  },
  mocha: {
    timeout: 200000,
  },
  abiExporter: {
    flat: true,
    clear: true,
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY || '',
      goerli: process.env.GOERLI_API_KEY || '',
    },
  },
  namedAccounts: {
    deployer: 0,
    alice: 1, // Test Account 1
    bob: 2, // Test Account 2

    supraRouter: {
      421613: "0xe0c0c4b7fe7d07fcde1a4f0959006a71c0ebe787", // Arbitrum Goerli
    },
    freedomWorldAssetsAddress: {
      421613: '0xA272fB0D17DC50652Fda5cF1651C6f8f21Fb02A8', // address of the contract instance
    }
  },
  networks: {
    hardhat: {
      live: false,
      chainId: 421613,
      forking: {
        enabled: true,
        url: process.env.GOERLI_NODE_URL ?? '',
        blockNumber: 43713499,
      },
    },
    arbitrum: {
      chainId: 42161,
      url: process.env.ARBITRUM_NODE_URL || '',
    },
    goerli: {
      chainId: 421613,
      url: process.env.GOERLI_NODE_URL || '',
    },
  },
};

if (process.env.ACCOUNT_PRIVATE_KEYS) {
  config.networks = {
    ...config.networks,
    arbitrum: {
      ...config.networks?.arbitrum,
      accounts: JSON.parse(process.env.ACCOUNT_PRIVATE_KEYS),
    },
    goerli: {
      ...config.networks?.goerli,
      accounts: JSON.parse(process.env.ACCOUNT_PRIVATE_KEYS),
    },
  };
}

export default config;
