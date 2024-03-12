// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./UtilityFunctions.sol";

contract IdentityManagement is UtilityFunctions  {
    uint256 internal totalRegistered;

    struct Identity {
        string fullName;
        string dateOfBirth;
        string governmentID; 
        bool isRegistered;
    }

    mapping(address => Identity) internal identities;

    modifier notRegistered() {
        require(!identities[msg.sender].isRegistered, "User is already registered");
        _;
    }
    modifier isRegistered() {
        require(identities[msg.sender].isRegistered, "User not registered");
        _;
    }

    function convertAddress(address _address) private pure returns (string memory) {
        bytes20 addrBytes = bytes20(_address);
        bytes memory addrString = new bytes(40); 
        for (uint256 i = 0; i < 20; i++) {
            uint8 char = uint8(addrBytes[i]);
            uint8 char1 = char / 16;
            uint8 char2 = char % 16;

            addrString[i * 2] = char1 < 10 ? bytes1(uint8(char1) + 48) : bytes1(uint8(char1) + 87);
            addrString[i * 2 + 1] = char2 < 10 ? bytes1(uint8(char2) + 48) : bytes1(uint8(char2) + 87);
        }
        return string(addrString);
    }

    function registerIdentity(string memory _fullName, string memory _dateOfBirth) internal notRegistered {
        string memory govtID = convertAddress(msg.sender);
        identities[msg.sender] = Identity({
            fullName: _fullName,
            dateOfBirth: _dateOfBirth,
            governmentID: govtID,
            isRegistered: true
        });

        totalRegistered += 1;

    }
    function getIdentity(address _address) internal view returns (string memory fullName, string memory dateOfBirth, string memory governmentID) {
        Identity storage identity = identities[_address];
        return (identity.fullName, identity.dateOfBirth, identity.governmentID);
    }

    function getIdentityAddress() internal view returns(address){
        return address(this);
    }


}
