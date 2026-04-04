const hre = require("hardhat");

async function main() {
  const usdcAddress = "0x036CbD53842c5426634e7929541eC2318f3dCF7e";

  const StableStay = await hre.ethers.getContractFactory("StableStay");
  const stableStay = await StableStay.deploy(usdcAddress);

  await stableStay.waitForDeployment();

  console.log("StableStay deployed to:", await stableStay.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
