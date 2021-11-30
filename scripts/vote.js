const hre = require("hardhat");

async function main() {
  const CNDVote = await hre.ethers.getContractFactory("CNDVote");
  const cndvote = await CNDVote.deploy();

  await cndvote.deployed();

  console.log("CNDVote deployed to:", cndvote.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
