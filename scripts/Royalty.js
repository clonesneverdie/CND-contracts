const hre = require('hardhat')

async function main() {
  const WETH = '0x7ceb23fd6bc0add59e62ac25578270cff1b9f619';
  const Creator1 = '0xDaE928d9382b299Bb7F3901073b1a82678ED038d';
  const Creator2 = '0xca027Fe02ff3aEa8dB89Aeb8aB2a5d08ceE3ddb8';
  const Creator3 = '0xED7Df3fE8cB3041090ebCb19964d18A20a4593b4';
  const Creator4 = '0xdfC60F088Dbbb8d89D761B6E017172aB92c04370';

  const Royalty = await hre.ethers.getContractFactory('Royalty')
  const royalty = await Royalty.deploy(WETH, Creator1, Creator2, Creator3, Creator4)

  await royalty.deployed()

  console.log('Royalty deployed to:', royalty.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
