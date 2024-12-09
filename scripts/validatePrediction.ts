import { ethers } from "hardhat";

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.SKALE_RPC);
  const wallet = new ethers.Wallet(process.env.ADMIN_ACCOUNT!); // La cuenta del admin
  const signer = wallet.connect(provider);

  const contractAddress = process.env.COSMOLYAI_CONTRACT_ADDRESS!;
  const cosmolyAI = await ethers.getContractAt(
    "CosmolyAI",
    contractAddress,
    signer
  );

  const index = 0;
  const isCorrect = true;

  console.log("Validating prediction...");
  const tx = await cosmolyAI.validatePrediction(index, isCorrect);
  await tx.wait();
  console.log("Prediction validated!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
