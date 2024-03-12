// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 
import "./Bank.sol";


contract LandManagement is IdentityManagement, Bank {

    struct Land {
        uint256 id;
        address owner;
        uint256 size; // Arbitrary units
        bool isOwned;
        address[] prevOwners;
    }

    uint256 internal nextLandId = 1;
    mapping(uint256 => Land) internal lands;
    
    //To Retrieve All Land Infromation
    uint256[] internal landIndex;
    Land[] private landList;

    // mapping(address => uint256[]) internal ownerLand;


    // function removeLandId(uint256 value, address _address) private {

    //     for (uint i = 0; i < ownerLand[_address].length; i++) {
    //         if (ownerLand[_address][i] == value) {
                
    //             for (uint j = i; j < ownerLand[_address].length - 1; j++) {
    //                 ownerLand[_address][j] = ownerLand[_address][j + 1];
    //             }
    //             ownerLand[_address].pop(); 
    //             return;
    //         }
    //     }
    // }

    function landRegistry(address _owner, uint256 _size, bool _isOwned, address[] memory _prevOwner) internal {
        
        Land memory newLand = Land({
            id: nextLandId,
            owner: _owner,
            size: _size,
            isOwned: _isOwned,
            prevOwners: _prevOwner
        });

        lands[nextLandId] = newLand;
        landIndex.push(nextLandId);
        //ownerLand[_owner].push(nextLandId);
       
        nextLandId++;
    }

    function landInfo() internal returns(Land[] memory){
        uint256 i;
        
        for(i = 0; i < landIndex.length; i++){
            landList.push(lands[landIndex[i]]);
        }

        return landList;
    }

    // function userLandId(address _address) internal view returns(uint256[] memory){
    //     return ownerLand[_address];
    // }

    function transferLand(uint256 _landId, address _newOwner) public isRegistered {
        require(lands[_landId].owner == msg.sender, "Not the owner of the land");
        require(identities[_newOwner].isRegistered, "New owner is not registered");
        
        lands[_landId].owner = _newOwner;
        lands[_landId].prevOwners.push(msg.sender);
        //ownerLand[_newOwner].push(_landId);
        //removeLandId(_landId, msg.sender);
    }

    function transferLandPayment(uint256 _landId, address _newOwner, uint256 _amount, bytes32 hash) external isRegistered{
        
        require(allTransactions[hash].from == _newOwner && allTransactions[hash].to == msg.sender && allTransactions[hash].amount == _amount, "Payment not receiveed");
        
        transferLand(_landId, _newOwner);
        
    }

    function splitLand(uint256 landId, uint256 newSize) external isRegistered{
        require(lands[landId].owner == msg.sender, "Not the owner of the land");
        require(newSize < lands[landId].size, "New size must be smaller than the current size");

        uint256 remainingSize = lands[landId].size - newSize;
        lands[landId].size = newSize;

        Land memory newLand = Land({
            id: nextLandId,
            owner: msg.sender,
            size: remainingSize,
            isOwned: true,
            prevOwners: lands[landId].prevOwners

        });

        lands[nextLandId] = newLand;
        landIndex.push(nextLandId);
        //ownerLand[msg.sender].push(nextLandId);
        nextLandId++;
    }

    function mergeLands(uint256 landId1, uint256 landId2) internal isRegistered{
        require(lands[landId1].owner == msg.sender && lands[landId2].owner == msg.sender, "Must own both lands to merge");

        uint256 newSize = lands[landId1].size + lands[landId2].size;

        lands[landId1].size = newSize;
        lands[landId1].prevOwners = merge(lands[landId1].prevOwners, lands[landId2].prevOwners);

        delete lands[landId2];
        delete landIndex[landId2];
        //removeLandId(landId2, msg.sender);
        

    }
}
