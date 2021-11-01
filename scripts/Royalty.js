const hre = require('hardhat')

async function main() {
  const WETH;
  const Creator1;
  const Creator2;
  const Creator3;
  const Creator4;

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
