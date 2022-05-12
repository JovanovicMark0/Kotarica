pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;

contract UsersContract{
    uint public usersCount = 0;
    uint public dateCount = 0;

    struct DateInfo{
        uint id;
        uint day;
        uint month;
        uint year;
        uint hour;
        uint minut;
        string picture;
    }

    struct UserInfo{
        uint id;
        string email;
        string password;
        string firstname;
        string lastname;
        string primaryAddress;
        string secondaryAddress;
        string phone;
        string privateKey;
    }

    mapping(uint => UserInfo) public users;
    mapping(uint => DateInfo) public dates;

    function createUser(string memory _email, string memory _password, string memory _firstname, string memory _lastname, string memory _primaryAddress, string memory _secondaryAddress, string memory _phone, string memory _privateKey) public{
        // add user to users
        // increment usersCount
        // emit event

        users[usersCount] = UserInfo(usersCount, _email, _password, _firstname, _lastname, _primaryAddress, _secondaryAddress, _phone, _privateKey);
        usersCount++;

        emit UserCreated(usersCount - 1, _email);
    }

    function editUser(uint _id, string memory _email, string memory _password, string memory _firstname, string memory _lastname, string memory _primaryAddress, string memory _secondaryAddress, string memory _phone, string memory _privateKey) public{
        // add user to users
        // increment usersCount
        // emit event
        delete users[_id];
        emit UserDeleted(_id);

        users[_id] = UserInfo(_id, _email, _password, _firstname, _lastname, _primaryAddress, _secondaryAddress, _phone, _privateKey);
        emit UserEdited(_id, _email);
    }

    function editPicture(uint _id, string memory _picture) public{
        DateInfo storage pom = dates[_id];
        delete dates[_id];

        dates[_id] = DateInfo(_id, pom.day, pom.month, pom.year, pom.hour, pom.minut, _picture);
    }

    function deleteUser(uint _id) public{
        delete users[_id];
        emit UserDeleted(_id);
    }

    function getPrivateKey(uint _id) public view returns(string memory) {
        return users[_id].privateKey;
    }

    function createDate(uint _id, uint _day, uint _month, uint _year, uint _hour, uint _minut, string memory _picture) public{

        dates[dateCount++] = DateInfo(_id, _day, _month, _year, _hour, _minut, _picture);

        emit DateCreated(_id);
    }


    event DateCreated(uint id);

    event UserDeleted(uint id);
    event UserCreated(uint id, string email);
    event UserEdited(uint id, string email);

}