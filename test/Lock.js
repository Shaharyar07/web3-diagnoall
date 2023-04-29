// Import necessary modules from Hardhat
const { expect } = require("chai");
const { ethers } = require("hardhat");

// Start describing the test
describe("Transactions contract", function () {
  // Define a variable to hold the deployed contract instance
  let transactions;

  // Define some sample data for testing
  const amount = 0.001;
  const receiver = "0xEf192f0f22D8f81C473880A3808904b880989100";

  // Deploy the contract before each test
  before(async function () {
    const Transactions = await ethers.getContractFactory("Transactions");
    transactions = await Transactions.deploy();
    await transactions.deployed();
    console.log("Deployed at:", transactions.address);
  });

  // Test case for adding a transaction
  it("Should add a transaction", async function () {
    await transactions.addToBlockchain(receiver, amount);

    const allTransactions = await transactions.getAllTransactions();
    const latestTransaction = allTransactions[allTransactions.length - 1];

    expect(latestTransaction.sender).to.equal(
      await ethers.provider.getSigner().getAddress()
    );
    expect(latestTransaction.receiver).to.equal(receiver);
    expect(latestTransaction.amount).to.equal(amount);
  });

  // Test case for getting all transactions
  it("Should get all transactions", async function () {
    await transactions.addToBlockchain(receiver, amount);
    await transactions.addToBlockchain(receiver, amount + 0.001);

    const allTransactions = await transactions.getAllTransactions();

    expect(allTransactions.length).to.equal(2);
  });
});
