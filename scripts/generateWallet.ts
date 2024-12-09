import { ethers } from "hardhat";

async function main() {
  console.log("Preparing signer for network");
  const wallet = ethers.Wallet.createRandom();
  console.log("Wallet Address:", wallet.address);
  console.log("Private Key:", wallet.privateKey);
  console.log("Mnemonic:", wallet.mnemonic?.phrase);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
