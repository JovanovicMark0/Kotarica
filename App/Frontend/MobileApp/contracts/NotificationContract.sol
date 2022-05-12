// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
contract NotificationContract {

    //storage
    uint public notificationAmount = 0;
    mapping(uint => Notification) public notifications;

    struct Notification{
        uint idUser;
        uint idPost;
        uint idPostOwner;
    }

    function addNotification(uint _idUser, uint _idPost, uint _idOwner) public {
        Notification storage temp = notifications[notificationAmount];
        temp.idUser = _idUser;
        temp.idPost = _idPost;
        temp.idPostOwner = _idOwner;
        notificationAmount++;
    }
}