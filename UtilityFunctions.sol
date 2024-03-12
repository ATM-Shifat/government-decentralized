// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UtilityFunctions {

    //Function to generate transaction hash
    function transactionHash(address _from, address _to, uint256 _amount, uint256 _timestamp) internal pure returns(bytes32){
        return keccak256(abi.encodePacked(_from, _to, _amount, _timestamp));
    }

    // Function to convert uint256 to string
    function uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    // Function to convert address to string
    function addressToString(address _addr) internal pure returns(string memory) {
        bytes32 value = bytes32(uint256(uint160(_addr)));
        bytes memory alphabet = "0123456789abcdef";
        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint256 i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint8(value[i + 12] >> 4)];
            str[3+i*2] = alphabet[uint8(value[i + 12] & 0x0f)];
        }
        return string(str);
    }

    // Function to concatenate various data types into a string
    function convertToString(string memory name, uint256 roll, uint256 examId, string memory gpa, address _address) internal pure returns (string memory) {
        return string(abi.encodePacked(name, ".", uintToString(roll), ".", uintToString(examId), ".", gpa, ".", addressToString(_address)));
    }

    //Function to merge 2 address type array
    function merge(address[] memory array1, address[] memory array2) internal pure returns (address[] memory) {
        uint256 totalLength = array1.length + array2.length;
        address[] memory mergedArray = new address[](totalLength);

        for (uint256 i = 0; i < array1.length; i++) {
            mergedArray[i] = array1[i];
        }

        for (uint256 j = 0; j < array2.length; j++) {
            mergedArray[array1.length + j] = array2[j];
        }

        return mergedArray;
    }


    //Function to find address
    function findAddress(address[] memory _array, address _address) internal pure returns (bool) {
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _address) {
                return true; 
            }
        }
        return false; 
    }
}
