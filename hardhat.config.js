require('@nomiclabs/hardhat-waffle')
require('hardhat-abi-exporter')
require('dotenv').config()

module.exports = {
  solidity: '0.8.4',
  networks: {
    popcateum: {
      url: 'https://dataseed.popcateum.org',
      accounts: [process.env.PK || ''],
    },
  },
  abiExporter: {
    path: './abi',
    clear: true,
    flat: true,
    spacing: 2,
  },
}
