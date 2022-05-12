// SPDX-License-Identifier: MIT
pragma experimental ABIEncoderV2;
pragma solidity >=0.5.0;
contract BuyContract {

    //storage
    mapping(uint => StructOfUsersWhoBought) public listOfUsersWhoBought;

    struct Date{
        uint _year;
        uint _month;
        uint _day;
        uint _hour;
        uint _minute;
        uint _second;
    }

    struct StructOfUsersWhoBought{
        uint[] listOfBoughtProducts;
        uint nBought;
        Date[] dayOfPurchase;
    }

    function buy(uint _userID, uint _postID, uint[] memory _date) public {
        listOfUsersWhoBought[_userID].listOfBoughtProducts.push(_postID);
        listOfUsersWhoBought[_userID].dayOfPurchase.push(Date(_date[0], _date[1], _date[2], _date[3], _date[4], _date[5]));
        listOfUsersWhoBought[_userID].nBought++;

        emit madePurchase(_userID, _postID);
    }

    function getBoughtList(uint _userID) public view returns(uint[] memory) {
        return listOfUsersWhoBought[_userID].listOfBoughtProducts;
    }

    function getBoughtDateList(uint _userID) public view returns(Date[] memory) {
        return listOfUsersWhoBought[_userID].dayOfPurchase;
    }


    event madePurchase(uint _userID, uint _postID);
}