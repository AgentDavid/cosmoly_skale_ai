// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CosmolyAI is Ownable {
    // Struct to store user details
    struct User {
        uint256 credits; // User's credits
        uint256 lastOpinionTimestamp; // Last time the user submitted an opinion
        uint256 opinionCount; // Total number of opinions submitted
    }

    // Struct to store pending predictions
    struct PendingPrediction {
        address user; // User who made the prediction
        string cryptocurrency; // Cryptocurrency predicted
        bool prediction; // Prediction (true for "up", false for "down")
        uint256 timestamp; // Time of prediction
    }

    // Mapping to store user data
    mapping(address => User) public users;

    // Array to store pending predictions
    PendingPrediction[] public pendingPredictions;

    // Event to track opinions
    event OpinionSubmitted(
        address indexed user,
        string cryptocurrency,
        bool prediction,
        uint256 timestamp,
        uint256 index // Added index to the event
    );

    // Event to reward users
    event UserRewarded(address indexed user, uint256 reward, bool isCorrect);

    // Event to track governance votes
    event ProposalCreated(
        uint256 proposalId,
        string description,
        uint256 endTime
    );
    event VoteCasted(address indexed voter, uint256 proposalId, uint256 weight);

    // Event to signal proposal execution
    event ProposalExecuted(uint256 proposalId, bool approved);

    // Governance proposal structure
    struct Proposal {
        string description; // Description of the proposal
        uint256 votesFor; // Total credits supporting the proposal
        uint256 votesAgainst; // Total credits opposing the proposal
        uint256 endTime; // Voting deadline
        bool executed; // Whether the proposal was executed
    }

    // Array to store governance proposals
    Proposal[] public proposals;

    // Constants
    uint256 public constant predictionCooldown = 3 hours;
    uint256 public constant predictionCost = 10;
    uint256 public constant rewardCredits = 5;
    uint256 public constant penaltyCredits = 6;

    // Minimum credits required to vote
    uint256 public constant minimumVotingCredits = 1;

    // Constructor to initialize the contract with the admin (owner)
    constructor() Ownable(msg.sender) {}

    /**
     * @dev Submit an opinion about a cryptocurrency.
     * @param cryptocurrency The name of the cryptocurrency (e.g., "Bitcoin").
     * @param prediction The prediction (true for "up", false for "down").
     */
    function submitOpinion(
        string calldata cryptocurrency,
        bool prediction
    ) external {
        User storage user = users[msg.sender];

        // Check if user is eligible to submit an opinion
        require(
            user.credits >= predictionCost,
            "Not enough credits to predict."
        );
        require(
            block.timestamp >= user.lastOpinionTimestamp + predictionCooldown,
            "You can submit an opinion only every 3 hours."
        );

        // Deduct prediction cost
        user.credits -= predictionCost;

        // Register the prediction
        pendingPredictions.push(
            PendingPrediction(
                msg.sender,
                cryptocurrency,
                prediction,
                block.timestamp
            )
        );

        user.lastOpinionTimestamp = block.timestamp;
        user.opinionCount++;

        // Emit event with index of the prediction
        emit OpinionSubmitted(
            msg.sender,
            cryptocurrency,
            prediction,
            block.timestamp,
            pendingPredictions.length - 1
        );
    }

    /**
     * @dev Validate a user's prediction (admin-only).
     * @param index The index of the prediction in the array.
     * @param isCorrect Whether the prediction was correct or not.
     */
    function validatePrediction(
        uint256 index,
        bool isCorrect
    ) external onlyOwner {
        require(index < pendingPredictions.length, "Invalid prediction index.");

        PendingPrediction memory prediction = pendingPredictions[index];
        User storage user = users[prediction.user];

        if (isCorrect) {
            user.credits += rewardCredits;
        } else {
            // Prevent underflow
            if (user.credits > penaltyCredits) {
                user.credits -= penaltyCredits;
            } else {
                user.credits = 0;
            }
        }

        emit UserRewarded(
            prediction.user,
            isCorrect ? rewardCredits : penaltyCredits,
            isCorrect
        );

        // Remove the prediction from the list
        pendingPredictions[index] = pendingPredictions[
            pendingPredictions.length - 1
        ];
        pendingPredictions.pop();
    }

    /**
     * @dev Create a governance proposal (admin-only).
     * @param description The description of the proposal.
     */
    function createProposal(string calldata description) external onlyOwner {
        proposals.push(
            Proposal(description, 0, 0, block.timestamp + 7 days, false)
        );
        emit ProposalCreated(
            proposals.length - 1,
            description,
            block.timestamp + 7 days
        );
    }

    /**
     * @dev Vote on a governance proposal.
     * @param proposalId The ID of the proposal to vote on.
     * @param support Whether to vote for (true) or against (false) the proposal.
     */
    function vote(uint256 proposalId, bool support) external {
        require(proposalId < proposals.length, "Invalid proposal ID.");
        Proposal storage proposal = proposals[proposalId];

        require(
            block.timestamp <= proposal.endTime,
            "Voting period has ended."
        );
        require(
            users[msg.sender].credits >= minimumVotingCredits,
            "Not enough credits to vote."
        );

        uint256 votingWeight = users[msg.sender].credits;

        if (support) {
            proposal.votesFor += votingWeight;
        } else {
            proposal.votesAgainst += votingWeight;
        }

        emit VoteCasted(msg.sender, proposalId, votingWeight);
    }

    /**
     * @dev Execute a governance proposal if it passed (admin-only).
     * @param proposalId The ID of the proposal to execute.
     */
    function executeProposal(uint256 proposalId) external onlyOwner {
        require(proposalId < proposals.length, "Invalid proposal ID.");
        Proposal storage proposal = proposals[proposalId];

        require(
            block.timestamp > proposal.endTime,
            "Voting period is still active."
        );
        require(!proposal.executed, "Proposal already executed.");

        // Mark the proposal as executed
        proposal.executed = true;

        bool approved = proposal.votesFor > proposal.votesAgainst;

        emit ProposalExecuted(proposalId, approved);
    }

    /**
     * @dev Get user data (credits, last opinion timestamp, opinion count).
     * @param user The address of the user to query.
     * @return credits, lastOpinionTimestamp, opinionCount.
     */
    function getUserData(
        address user
    ) external view returns (uint256, uint256, uint256) {
        User memory userData = users[user];
        return (
            userData.credits,
            userData.lastOpinionTimestamp,
            userData.opinionCount
        );
    }

    /**
     * @dev Assign credits to a user (admin-only).
     * @param user The address of the user to assign credits.
     * @param amount The amount of credits to assign.
     */
    function assignCredits(address user, uint256 amount) external onlyOwner {
        users[user].credits += amount;
    }

    /**
     * @dev Consume credits from a user (admin-only).
     * @param user The address of the user to consume credits from.
     * @param amount The amount of credits to consume.
     */
    function consumeCredits(address user, uint256 amount) external onlyOwner {
        User storage userData = users[user];
        require(userData.credits >= amount, "Not enough credits to consume.");
        userData.credits -= amount;
    }
}
