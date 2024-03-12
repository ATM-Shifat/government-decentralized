// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IdentityManagement.sol";

contract Bank is IdentityManagement{
    struct Account {
        uint256 balance;
        uint256 lastTransactionTimestamp;
        Transaction[] transactions;
        uint256 transactionCount;
    }

    struct Transaction {
        address from;
        address to;
        uint256 amount;
        uint256 timestamp;
        bytes32 hash;
    }

    mapping(address => Account) private accounts;
    mapping(bytes32=>Transaction) internal allTransactions;


    

    function createBankAccount() internal returns(bytes32){
        require(accounts[msg.sender].balance == 0, "Account already exists");
        
        bytes32 hash = transactionHash(address(this), msg.sender, 0, block.timestamp);
        
        accounts[msg.sender].balance = 0;
        accounts[msg.sender].lastTransactionTimestamp = block.timestamp;
        accounts[msg.sender].transactions.push(Transaction(address(this), msg.sender, 0, block.timestamp, hash)); 
        accounts[msg.sender].transactionCount++;
        
        allTransactions[hash] = Transaction(address(this), msg.sender, 0, block.timestamp, hash);
        return hash;

    }

    function depositFunds() external payable isRegistered returns(bytes32){
        require(msg.value > 0, "Deposit amount must be greater than 0");
       
        bytes32 hash = transactionHash(msg.sender, address(this),  msg.value, block.timestamp);
        Transaction memory transaction = Transaction(msg.sender, address(this),  msg.value, block.timestamp, hash);
        
        accounts[msg.sender].balance += msg.value;
        accounts[msg.sender].lastTransactionTimestamp = block.timestamp;
        accounts[msg.sender].transactions.push(transaction); 
        accounts[msg.sender].transactionCount++;

        allTransactions[hash] = transaction;
        return hash;
    }

    function withdrawFunds(uint256 _amount) external isRegistered returns(bytes32){
        require(accounts[msg.sender].balance >= _amount, "Insufficient balance");
        payable(msg.sender).transfer(_amount);
        
        bytes32 hash = transactionHash(address(this), msg.sender, _amount, block.timestamp);
        Transaction memory transaction =  Transaction(address(this), msg.sender, _amount, block.timestamp, hash);
        
        accounts[msg.sender].balance -= _amount;
        accounts[msg.sender].lastTransactionTimestamp = block.timestamp;
        accounts[msg.sender].transactions.push(transaction); 
        accounts[msg.sender].transactionCount++;

        allTransactions[hash] = transaction;
        return hash;
    }

    function transferFunds(address _to, uint256 _amount) external isRegistered returns(bytes32){
        require(accounts[msg.sender].balance >= _amount, "Insufficient balance");
        bytes32 hash = transactionHash(msg.sender, _to, _amount, block.timestamp);
        Transaction memory transaction = Transaction(msg.sender, _to, _amount, block.timestamp, hash);
        accounts[msg.sender].balance -= _amount;
        accounts[_to].balance += _amount;
       
        accounts[msg.sender].lastTransactionTimestamp = block.timestamp;
        accounts[msg.sender].transactions.push(transaction); 
        accounts[msg.sender].transactionCount++;
        
        accounts[_to].lastTransactionTimestamp = block.timestamp;
        accounts[_to].transactions.push(transaction);
        accounts[_to].transactionCount++;


        allTransactions[hash] = transaction;
        return hash;
    }

    function transactionHistory(address _address) internal view returns(Transaction[] memory){
        return accounts[_address].transactions;
    }

    function getBalance(address _address) internal view returns (uint256) {
        return accounts[_address].balance;
    }

    function getBankAddress() internal view returns(address){
        return address(this);
    }
}
