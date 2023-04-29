// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

contract DiagnoALL {
    address payable public admin;
    uint256 public testFee;

    event Transfer(
        address indexed from,
        address indexed to,
        uint256 amount,
        uint256 timestamp
    );

    struct TransferStruct {
        address sender;
        uint256 amount;
        uint256 timestamp;
    }

    TransferStruct[] public transactions;

    event TestReport(
        address indexed user,
        string ipfsHash,
        uint256 timestamp
    );

    mapping(address => string) public testReports;

    constructor() {
        admin = payable(msg.sender);
        testFee = 0.01 ether;
    }

    function sendTestFee() public payable {
        require(msg.value == testFee, "Test fee amount is incorrect.");
        transactions.push(
            TransferStruct(msg.sender, msg.value, block.timestamp)
        );
        emit Transfer(msg.sender, admin, msg.value, block.timestamp);
    }

    function getAllTransactions()
        public
        view
        returns (TransferStruct[] memory)
    {
        require(msg.sender == admin, "Only admin can view transactions.");
        return transactions;
    }

    function getMyTransactions()
        public
        view
        returns (TransferStruct[] memory)
    {
        uint256 count = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].sender == msg.sender) {
                count++;
            }
        }
        TransferStruct[] memory myTransactions =
            new TransferStruct[](count);
        uint256 index = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (transactions[i].sender == msg.sender) {
                myTransactions[index] = transactions[i];
                index++;
            }
        }
        return myTransactions;
    }

    function saveTestReport(string memory _ipfsHash) public {
        testReports[msg.sender] = _ipfsHash;
        emit TestReport(msg.sender, _ipfsHash, block.timestamp);
    }

    function getAllTestReports()
        public
        view
        returns (address[] memory, string[] memory, uint256[] memory)
    {
        require(msg.sender == admin, "Only admin can view test reports.");
        address[] memory users = new address[](transactions.length);
        string[] memory ipfsHashes = new string[](transactions.length);
        uint256[] memory timestamps = new uint256[](transactions.length);
        uint256 index = 0;
        for (uint256 i = 0; i < transactions.length; i++) {
            if (bytes(testReports[transactions[i].sender]).length > 0) {
                users[index] = transactions[i].sender;
                ipfsHashes[index] = testReports[transactions[i].sender];
                timestamps[index] = block.timestamp;
                index++;
            }
        }
        return (users, ipfsHashes, timestamps);
    }

    function getMyTestReport() public view returns (string memory) {
        return testReports[msg.sender];
    }
}
