const hre = require('hardhat')

async function main() {
  const C1Adr = '0x20D2b4C589D38579515965FB13b4793B01189D2B'
  const C2Adr = '0x20D2b4C589D38579515965FB13b4793B01189D2B'
  const C3Adr = '0x20D2b4C589D38579515965FB13b4793B01189D2B'
  const openseaContract = '0x58807baD0B376efc12F5AD86aAc70E78ed67deaE'

  const CNDV2 = await hre.ethers.getContractFactory('ClonesNeverDieV2')
  const Nectar = await hre.ethers.getContractFactory('Nectar')
  const CNDV2Sale = await hre.ethers.getContractFactory('CNDV2Sale')
  const LotusStaking = await hre.ethers.getContractFactory('LotusStaking')

  const cndv2 = await CNDV2.deploy('test-uri/')
  await cndv2.deployed()

  const nectar = await Nectar.deploy()
  await nectar.deployed()

  const cndv2Sale = await CNDV2Sale.deploy(cndv2.address, C1Adr, C2Adr, C3Adr)
  await cndv2Sale.deployed()

  const lotus = await LotusStaking.deploy(cndv2.address, nectar.address)
  await lotus.deployed()

  await cndv2.setDevAddress(C2Adr)
  await cndv2.setMinterContract(cndv2Sale.address)
  await cndv2.setLotusContract(lotus.address)
  await cndv2.setOpenseaContract(openseaContract)
  await nectar.setStakingContract(lotus.address)

  console.log('CNDV2 deployed to:', cndv2.address)
  console.log('Nectar deployed to:', nectar.address)
  console.log('CNDV2Sale deployed to:', cndv2Sale.address)
  console.log('LotusStaking deployed to:', lotus.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error)
    process.exit(1)
  })
