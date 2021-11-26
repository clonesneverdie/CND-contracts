const hre = require("hardhat");

async function main() {
  const TokenURI =
    "https://cnd.mypinata.cloud/ipfs/QmTZBQdpc1GapAvDNjKhA8W4mhSYWynSLu3rHdzdW9WKyK/";
  const CNDDev = "0x0C06a4DEed7530536Bd2D02a305828fB38AA14e3";
  const OpenseaCA = "0x58807baD0B376efc12F5AD86aAc70E78ed67deaE"

  const CNDV1 = await hre.ethers.getContractFactory("ClonesNeverDieV1");
  const cndv1 = await CNDV1.deploy(TokenURI, CNDDev, OpenseaCA);

  await cndv1.deployed();

  console.log("CNDV1 deployed to:", cndv1.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
