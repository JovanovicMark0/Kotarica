// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
contract WishContract {

    //storage
    uint public wishAmount = 0;
    mapping(uint => Wish) public wishes;

    struct Wish{
        uint id;
        uint idPost;
    }

    function addToWishList(uint _idUser, uint _idPost) public {
        Wish storage temp = wishes[wishAmount];
        temp.id = _idUser;
        temp.idPost = _idPost;
        wishAmount++;
    }

    function removeFromWishList(uint _idUser, uint _idPost) public {
        for(uint i = 0; i<wishAmount; i++){
            if(wishes[i].id == _idUser && wishes[i].idPost == _idPost){
                wishes[i].id = 10000000;
                wishes[i].idPost = 10000000;

            }
        }
    }
}