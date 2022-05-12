// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;
contract LikesContract {

    //storage
    uint256 public likedUsersAmount = 0;
    uint256 public iGradedLikesAmount = 0;
    uint256 private flag;
    uint256 private indexUser;
    mapping(uint256 => LikedUsers) public likedUsers;
    mapping(uint256 => IGraded) public iGradedLikes;



    struct LikedUsers{
        uint idUser;
        uint idLikedMe;
        uint isLiked;
        string message;
    }

    struct IGraded{
        uint idUser;
        uint idILiked;
        uint isLiked;
        string message;
    }

    function addILiked(uint _myId, uint _idLiked, string memory _mess) public {
        flag = 0;

        if(_idLiked == _myId)
        {
            flag = 1;
        }

        else
        {
            for(uint i=0; i<iGradedLikesAmount; i++)
            {
                if(iGradedLikes[i].idUser == _myId)
                {
                    indexUser = i;
                    if(iGradedLikes[i].idILiked == _idLiked)
                    {
                        flag = 1;
                        break;
                    }
                }
            }
        }

        if(flag == 0)
        {
            IGraded storage like = iGradedLikes[iGradedLikesAmount];
            like.idUser = _myId;
            like.idILiked = _idLiked;
            like.isLiked = 1;
            like.message = _mess;
            iGradedLikesAmount++;
        }
    }

    function addIDisLiked(uint _myId, uint _idLiked, string memory _mess) public {
        flag = 0;

        if(_idLiked == _myId)
        {
            flag = 1;
        }

        else
        {
            for(uint i=0; i<iGradedLikesAmount; i++)
            {
                if(iGradedLikes[i].idUser == _myId)
                {
                    indexUser = i;
                    if(iGradedLikes[i].idILiked == _idLiked)
                    {
                        flag = 1;
                        break;
                    }
                }
            }
        }

        if(flag == 0)
        {
            IGraded storage like = iGradedLikes[iGradedLikesAmount];
            like.idUser = _myId;
            like.idILiked = _idLiked;
            like.isLiked = 0;
            like.message = _mess;
            iGradedLikesAmount++;
        }
    }

    function addLike(uint _idUser, uint _idLiked, string memory _mess) public {
        flag = 0;

        if(_idLiked == _idUser)
        {
            flag = 1;
        }

        else
        {
            for(uint i=0; i<likedUsersAmount; i++)
            {
                if(likedUsers[i].idUser == _idLiked)
                {
                    indexUser = i;
                    if(likedUsers[i].idLikedMe == _idUser)
                    {
                        flag = 1;
                        break;
                    }
                }
            }
        }

        if(flag == 0)
        {
            LikedUsers storage like = likedUsers[likedUsersAmount];
            like.idUser = _idLiked;
            like.idLikedMe = _idUser;
            like.isLiked = 1;
            like.message = _mess;
            likedUsersAmount++;
        }
    }

    function addDislike(uint _idUser, uint _idLiked, string memory _mess) public {
        flag = 0;

        if(_idLiked == _idUser)
        {
            flag = 1;
        }

        else
        {
            for(uint i=0; i<likedUsersAmount; i++)
            {
                if(likedUsers[i].idUser == _idLiked)
                {
                    indexUser = i;
                    if(likedUsers[i].idLikedMe == _idUser)
                    {
                        flag = 1;
                        break;
                    }
                }
            }
        }

        if(flag == 0)
        {
            LikedUsers storage like = likedUsers[likedUsersAmount];
            like.idUser = _idLiked;
            like.idLikedMe = _idUser;
            like.isLiked = 0;
            like.message = _mess;
            likedUsersAmount++;
        }
    }

}