const hre = require("hardhat");

async function main() {
  const C3Adr = "0x50ee4b8f2ff7a2b81f94fe1be247e154cfd9c754";

  const CNDV2 = await hre.ethers.getContractFactory("ClonesNeverDieV2");
  const cndv2 = await CNDV2.deploy("test-uri/");
  
  await cndv2.deployed();
  await cndv2.setDevAddress(C3Adr);

  console.log("CNDV2 deployed to:", cndv2.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
