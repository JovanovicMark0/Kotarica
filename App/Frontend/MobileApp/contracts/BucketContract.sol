// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
contract BucketContract {

    //storage
    uint256 public bucketAmount = 0;
    uint256 private flag;
    uint256 private indexUser;
    mapping(uint256 => Bucket) public bucket;
    
    struct Bucket{
        uint id;
        uint[] bucketList;
        uint nBucket;
    }

    function addToBucketList(uint _idUser, uint _idPost) public {
        
        flag = 0;
        for(uint i=0; i<bucketAmount; i++)
        {
            if(bucket[i].id == _idPost)
            {
                flag = 1;
                indexUser = i;
            }
        }
        
        if(flag == 0)
        {
            Bucket storage temp = bucket[bucketAmount];
            temp.id = _idUser;
            temp.bucketList.push(_idPost);
            temp.nBucket = 1;
            bucketAmount++;   
        }
        else
        {
            bucket[indexUser].bucketList.push(_idPost);
            bucket[indexUser].nBucket++;
        }
    }
    
    function getBasket(uint256 _userIndex) public view returns(uint[] memory) {
        Bucket memory temp = bucket[_userIndex];
        return temp.bucketList;
    }
}