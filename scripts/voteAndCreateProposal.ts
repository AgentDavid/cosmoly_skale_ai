import { ethers } from "hardhat";

async function main() {
  const provider = new ethers.JsonRpcProvider(process.env.SKALE_RPC);
  const wallet = new ethers.Wallet(process.env.ADMIN_ACCOUNT!);
  const signer = wallet.connect(provider);

  const contractAddress = process.env.COSMOLYAI_CONTRACT_ADDRESS!;
  const cosmolyAI = await ethers.getContractAt(
    "CosmolyAI",
    contractAddress,
    signer
  );

  // Crear una propuesta
  const proposalDescription = "Should we increase rewards for predictions?";
  console.log("Creating proposal...");
  const createTx = await cosmolyAI.createProposal(proposalDescription);
  await createTx.wait();
  console.log("Proposal created!");

  const proposalId = 0;
  const support = true;

  const userWallet = new ethers.Wallet(process.env.USER_ACCOUNT!);
  const userSigner = userWallet.connect(provider);

  const cosmolyAIUser = await ethers.getContractAt(
    "CosmolyAI",
    contractAddress,
    userSigner
  );
  console.log("Casting vote...");
  const voteTx = await cosmolyAIUser.vote(proposalId, support);
  await voteTx.wait();
  console.log("Vote casted!");
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
