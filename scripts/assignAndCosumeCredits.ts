import { ethers } from "hardhat";

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.SKALE_RPC);
  const wallet = new ethers.Wallet(process.env.ADMIN_ACCOUNT!); // Admin's wallet
  const signer = wallet.connect(provider);

  const contractAddress = process.env.COSMOLYAI_CONTRACT_ADDRESS!;
  const cosmolyAI = await ethers.getContractAt(
    "CosmolyAI",
    contractAddress,
    signer
  );

  const userAddress = new ethers.Wallet(process.env.USER_ACCOUNT!).address; // The user whose credits will be modified
  const assignAmount = 100; // Amount of credits to assign
  const consumeAmount = 20; // Amount of credits to consume

  // Assign credits to the user
  console.log(`Assigning ${assignAmount} credits to ${userAddress}...`);
  const assignTx = await cosmolyAI.assignCredits(userAddress, assignAmount);
  await assignTx.wait();
  console.log(`Assigned ${assignAmount} credits to ${userAddress}.`);

  // Consume credits from the user
  console.log(`Consuming ${consumeAmount} credits from ${userAddress}...`);
  const consumeTx = await cosmolyAI.consumeCredits(userAddress, consumeAmount);
  await consumeTx.wait();
  console.log(`Consumed ${consumeAmount} credits from ${userAddress}.`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
