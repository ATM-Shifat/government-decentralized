// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IdentityManagement.sol";

contract EducationalCredentials is IdentityManagement {

    mapping(address => bytes32) private credentialHashList;

    // Function to hash and store credentials
    function credentialsStore(string memory _name, uint256 _roll, uint256 _examId, string memory _gpa, address _address) internal returns(bytes32){
        require(identities[_address].isRegistered, "User is not registered");
        
        bytes32 credentialsHash = keccak256(abi.encodePacked(convertToString(_name, _roll, _examId, _gpa, _address)));
        
       
        credentialHashList[_address] = credentialsHash;

        return credentialsHash;
    }

    // Function to verify credentials 
    function credentialsVerification(string memory _name, uint256 _roll, uint256 _examId, string memory _gpa, address _address) internal view returns (bool) {
        require(identities[_address].isRegistered, "User is not registered");

        bytes32 credentialsHash = keccak256(abi.encodePacked(convertToString(_name, _roll, _examId, _gpa, _address)));

        return credentialHashList[_address] == credentialsHash;
    }
}
