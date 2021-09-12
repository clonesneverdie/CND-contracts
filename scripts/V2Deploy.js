const hre = require("hardhat");

async function main() {
  const C1Adr = "0xED7Df3fE8cB3041090ebCb19964d18A20a4593b4";
  const C2Adr = "0x50ee4b8f2ff7a2b81f94fe1be247e154cfd9c754";
  const C3Adr = "0xe9b4C1e5883A34dB52807197AD391Fc23f5C6d0f";
  const openseaContract = "0x58807baD0B376efc12F5AD86aAc70E78ed67deaE";

  const CNDV2 = await hre.ethers.getContractFactory("ClonesNeverDieV2");

  const cndv2 = await CNDV2.deploy("test-uri/");
  await cndv2.deployed();

  await cndv2.setDevAddress(C2Adr);
  await cndv2.setOpenseaContract(openseaContract);

  console.log("CNDV2 deployed to:", cndv2.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
