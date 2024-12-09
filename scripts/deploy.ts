import { ethers } from "hardhat";

async function main() {
  if (!process.env.DEPLOYER_KEY) {
    console.log("Please specify DEPLOYER_KEY in .env file");
    throw new Error("DEPLOYER_KEY is empty");
  }

  console.log("Preparing signer for network");
  const wallet = new ethers.Wallet(process.env.DEPLOYER_KEY);
  const provider = new ethers.JsonRpcProvider(process.env.SKALE_RPC);
  const signer = wallet.connect(provider);

  console.log("Deploying Contract");
  const skaleContract = await ethers.deployContract("CosmolyAI", [], signer);
  await skaleContract.waitForDeployment();

  console.log("Configure recipient address");
  const contractAddress = await skaleContract.getAddress();

  console.log("Contracts were deployed");
  console.log("Address: ", contractAddress);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
