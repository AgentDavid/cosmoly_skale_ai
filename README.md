# CosmolyAI Smart Contract

## Overview

The **CosmolyAI** smart contract is designed to manage user interactions, including submitting cryptocurrency predictions, validating those predictions, rewarding or penalizing users based on accuracy, and enabling decentralized governance via voting. It also integrates a credit system to facilitate participation in the platform.

### Key Features

- **User Predictions & Opinions**: Users can submit predictions about the price movement of cryptocurrencies.
- **Prediction Validation**: Admin can validate user predictions and reward or penalize users based on their accuracy.
- **Governance Voting**: Users can participate in governance decisions, where votes are weighted based on the user's credits.
- **Credit System**: Credits are used for submitting opinions and voting. Admins can assign or consume credits from users.

---

## Contract Functions

1. **User Interaction**:

   - `submitOpinion(cryptocurrency, prediction)`: Users can submit a prediction on whether a cryptocurrency will go up or down. Requires at least 10 credits.
   - `validatePrediction(index, isCorrect)`: Admin validates a prediction and rewards or penalizes the user. Rewards are 5 credits for correct predictions, 6 credits are deducted for incorrect predictions.

2. **Governance**:

   - `createProposal(description)`: Admin can create governance proposals.
   - `vote(proposalId, support)`: Users can vote on governance proposals. Voting power is determined by the user's credits.
   - `executeProposal(proposalId)`: Admin executes the proposal after the voting period ends, determining if it passes based on votes.

3. **Credit Management**:
   - `assignCredits(user, amount)`: Admin can assign credits to a user.
   - `consumeCredits(user, amount)`: Admin can consume credits from a user.

---

## Installation

### Prerequisites

- [Node.js](https://nodejs.org/) (v20.0.0 or later)
- [Hardhat](https://hardhat.org/) (for deploying and interacting with smart contracts)
- [pnpm](https://pnpm.io/) (for run commands and packages manager)
- [ethers.js](https://docs.ethers.io/v5/)

### Setup

1. Clone the repository to your local machine:

   ```bash
   git clone github.com/AgentDavid/cosmoly_skale_node
   cd cosmoly_skale_node
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Create a `.env` file in the root of the project and add the necessary environment variables:

   ```env
   DEPLOYER_KEY=<Your Deployer Private Key>
   SKALE_RPC=<Your Skale RPC URL>
   COSMOLYAI_CONTRACT_ADDRESS=<Your CosmolyAI Contract Address>
   ADMIN_ACCOUNT=<Admin Account Private Key>
   USER_ACCOUNT=<User Account Private Key>
   ```

---

## Deployment

To deploy the contract to the network, run the deployment script:

```bash
pnpm run deploy
```

- The contract will be deployed to the specified network, and the contract address will be logged in the console.

---

## Scripts

### 1. **/scripts/deploy.ts**

This script deploys the **CosmolyAI** smart contract to the specified network.

```bash
pnpm run deploy
```

### 2. **/scripts/assignAndConsumeCredits.ts**

This script tests the functionality for assigning and consuming credits for users.

```bash
pnpm run assignAndConsumeCredits
```

### 3. **/scripts/voteAndCreateProposal.ts**

This script allows you to create a proposal and then vote on it. The admin creates the proposal and users vote with their credits.

```bash
pnpm run voteAndCreateProposal
```

### 4. **/scripts/validatePrediction.ts**

This script is for the admin, who validates whether a prediction is correct and rewards or penalizes the user.

```bash
pnpm run validatePrediction
```

---

## Interacting with the Contract

Once the contract is deployed and the necessary environment variables are set, you can interact with the contract using the provided scripts. You can:

1. **Assign credits to users** using the `assignCredits` function.
2. **Consume credits from users** using the `consumeCredits` function.
3. **Submit predictions** using the `submitOpinion` function (requires at least 10 credits).
4. **Validate predictions** using the `validatePrediction` function (only accessible by the admin).
5. **Create and vote on proposals** for governance.

---

## For a better decentralized future

The **CosmolyAI** smart contract facilitates a decentralized prediction system, governance voting, and a credit-based reward system. By using the provided deployment and interaction scripts, you can test and deploy the contract on your desired blockchain network.

If you encounter any issues, please refer to the [Hardhat documentation](https://hardhat.org/) or raise an issue in the repository.
