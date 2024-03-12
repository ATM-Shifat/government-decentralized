// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./LandManagement.sol";
import "./EducationalCredentials.sol";

contract Government is IdentityManagement, Bank, LandManagement, EducationalCredentials {
    
    address[] private govtEmployees;
    
    modifier onlyEmployee() {
        require(findAddress( govtEmployees, msg.sender), "Only the Government Employee can call this function");
        _;
    }

    constructor(){
        govtEmployees.push(msg.sender);
    }

    
    //---------------------------------------------------------
    //---------------------------------------------------------
    //Identity Creation

    function createIdentityBankAccount(string memory _fullName, string memory _dateOfBirth) external {
        registerIdentity(_fullName, _dateOfBirth);
        createBankAccount();
    }

    function myInfo() external view isRegistered returns (string memory fullName, string memory dateOfBirth, string memory governmentID, address myAddress, uint256 balance) {
        
        (fullName, dateOfBirth, governmentID) = getIdentity(msg.sender);
        return (fullName, dateOfBirth, governmentID, msg.sender, getBalance(msg.sender));
    }

    function personInfo(address _address) external view onlyEmployee returns (string memory fullName, string memory dateOfBirth, string memory governmentID, address userAddress, uint256) {
        (fullName, dateOfBirth, governmentID) = getIdentity(_address);
        return (fullName, dateOfBirth, governmentID, _address, getBalance(_address));
    }

    //---------------------------------------------------------
    //---------------------------------------------------------
    //Bank

    function userTransactions(address _address) external view onlyEmployee returns (Transaction[] memory) {
        return transactionHistory(_address);
    }

    function myTransactions() external view isRegistered returns (Transaction[] memory) {
        return transactionHistory(msg.sender);
    }

    function UserBalance(address _address) external view onlyEmployee returns (uint256) {
        return getBalance(_address);
    }

    function myBalance() external view isRegistered returns (uint256) {
        return getBalance(msg.sender);
    }

    //---------------------------------------------------------
    //---------------------------------------------------------
    //Land Management

    function landRegister(address _owner, uint256 _size, bool _isOwned, address[] memory _prevOwner) external onlyEmployee {
        landRegistry(_owner,  _size, _isOwned, _prevOwner);
    }

    function allLandInfo() external onlyEmployee returns(Land[] memory){
        return landInfo();
    }

    // function myLandInfo() external view isRegistered returns(uint256[] memory){
    //     return userLandId(msg.sender);
    // }

    // function userLandInfo(address _address) external view onlyEmployee returns(uint256[] memory){
    //     return userLandId(_address);
    // }

    //---------------------------------------------------------
    //---------------------------------------------------------
    //Eductional Credential Store and Verification

    function storeCredentials(string memory _name, uint256 _roll, uint256 _examId, string memory _gpa, address _address) external onlyEmployee returns(bytes32){
        
        return credentialsStore( _name, _roll,  _examId, _gpa,  _address);
    }

    function verifyCredentials(string memory _name, uint256 _roll, uint256 _examId, string memory _gpa, address _address) external view onlyEmployee returns(bool){
        
        return credentialsVerification( _name, _roll,  _examId, _gpa,  _address);
    }

    //---------------------------------------------------------
    //---------------------------------------------------------


    function totalUser() external view onlyEmployee returns (uint256){
        return totalRegistered;
    }
    
    function addEmployee(address _newEmployee) external onlyEmployee {
        require(identities[_newEmployee].isRegistered, "Employee not registered");
        require(!findAddress( govtEmployees, msg.sender), "Already Employee");
        govtEmployees.push(_newEmployee);
    }

    function employeeList() external view onlyEmployee returns (address[] memory){
        return govtEmployees;
    }
}
