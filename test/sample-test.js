const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Sample", function () {
  it("Sample test function", async function () {
    const Sample = await ethers.getContractFactory("Sample");
    const sample = await Sample.deploy();
    await sample.deployed();

    expect(await sample.test()).to.equal("Hello World");
  });
});
