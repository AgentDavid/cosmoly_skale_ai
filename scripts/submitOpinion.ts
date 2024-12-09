import { ethers } from "hardhat";

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.SKALE_RPC);
  const wallet = new ethers.Wallet(process.env.USER_ACCOUNT!);
  const signer = wallet.connect(provider);

  const contractAddress = process.env.COSMOLYAI_CONTRACT_ADDRESS!;
  const cosmolyAI = await ethers.getContractAt(
    "CosmolyAI",
    contractAddress,
    signer
  );

  const cryptocurrency = "bitcoin";
  const prediction = true;

  console.log("Submitting opinion...");
  const tx = await cosmolyAI.submitOpinion(cryptocurrency, prediction);
  await tx.wait();
  console.log("Opinion submitted!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
