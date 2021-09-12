const hre = require("hardhat");

async function main() {
  const C1Adr = "0xED7Df3fE8cB3041090ebCb19964d18A20a4593b4";
  const C2Adr = "0xe9b4C1e5883A34dB52807197AD391Fc23f5C6d0f";
  const C3Adr = "0x50ee4b8f2ff7a2b81f94fe1be247e154cfd9c754";
  const CNDV2Address = "0x6c15030A0055D7350c89EbbD460EB4F145462Fbd";

  const Nectar = await hre.ethers.getContractFactory("Nectar");
  const CNDV2Sale = await hre.ethers.getContractFactory("CNDV2Sale");
  // const LotusStaking = await hre.ethers.getContractFactory('LotusStaking')

  const nectar = await Nectar.deploy();
  await nectar.deployed();

  const cndv2Sale = await CNDV2Sale.deploy(CNDV2Address, C1Adr, C2Adr, C3Adr);
  await cndv2Sale.deployed();

  // const lotus = await LotusStaking.deploy(CNDV2Address, nectar.address)
  // await lotus.deployed()

  // await nectar.setStakingContract(lotus.address)

  console.log("Nectar deployed to:", nectar.address);
  console.log("CNDV2Sale deployed to:", cndv2Sale.address);
  // console.log('LotusStaking deployed to:', lotus.address)
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
