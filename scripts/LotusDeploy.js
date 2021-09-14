const hre = require('hardhat')

async function main() {
  const Lotus = await hre.ethers.getContractFactory('LotusStaking')
  const lotus = await Lotus.deploy('0x6c15030A0055D7350c89EbbD460EB4F145462Fbd','0x662e0c208238Fc014429c8C4F28f82AaC6F59b9D','0x135a62F90C9030Fcd7F0553Bc9795a2cBf82e440')

  await lotus.deployed()

  console.log('Lotus deployed to:', lotus.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
