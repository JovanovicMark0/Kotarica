pragma solidity >=0.5.0;
pragma experimental ABIEncoderV2;
contract PosterContract{
    uint public postersCount = 0;
    uint public dateCount = 0;
    uint public pictureCount = 0;
    uint private index;
    uint private flag;

    struct DateInfo{
        uint id;
        uint day;
        uint month;
        uint year;
        uint hour;
        uint minut;
        uint idOwner;
    }

    struct Picture{
        uint id;
        string[] pictures;
    }

    struct PosterInfo{
        uint id; //id proizvoda
        string name; //naziv proizvoda
        string description; //opis
        string category; // kategorija
        string subcategory;// kategorija
        string price; // ako je aukcija bice kupiodmah|pocetna
        string typeofPoster;// fiksna ili licitacija
        string wayOfPayment;//nacin placanja
        string additionalInfo;
        string currentBid; // poslednja ponuda inicijalno setovana na price.split("|")[1]
        string currentBider; // id kupca inicijalno setovan na -1
        uint deleted;
    }

    mapping(uint => Picture) public mainpictures;
    mapping(uint => PosterInfo) public posters;
    mapping(uint => DateInfo) public dates;

    function createPoster(string memory _name, string memory _description, string memory _category, string memory _subcategory, string memory _price, string memory _typeofPoster, string memory _wayOfPayment, string memory _additionalInfo) public{
        // add post to posters
        // increment postersCount
        // emit event
        if(keccak256(abi.encodePacked((_typeofPoster))) == keccak256(abi.encodePacked(("Oglas")))){
            posters[postersCount] = PosterInfo(postersCount, _name, _description, _category, _subcategory, _price, _typeofPoster, _wayOfPayment, _additionalInfo, "0", "-1",0);
        }
        else{

            bytes memory stringAsBytesArray = bytes(_price);
            string memory tmp = new string(stringAsBytesArray.length);
            bytes memory tempWord = bytes(tmp);
            uint k = 0;
            for(uint i = 0; i < stringAsBytesArray.length; i++) {
                if (stringAsBytesArray[i] != "|") {
                    tempWord[k] = stringAsBytesArray[i];
                    k++;
                }
                else{
                    break;
                }

            }
            string memory bidPrice = string(tempWord);
            posters[postersCount] = PosterInfo(postersCount, _name, _description, _category, _subcategory, _price, _typeofPoster, _wayOfPayment, _additionalInfo, bidPrice, "-1", 0);
        }

        emit PosterCreated(postersCount++, _name);
    }

    function createDate(uint _id, uint _day, uint _month, uint _year, uint _hour, uint _minut, uint _idOwner) public{

        dates[dateCount++] = DateInfo(_id, _day, _month, _year, _hour, _minut, _idOwner);

        emit DateCreated(_id);
    }


    function addPicture(uint _idPost, string memory _pic) public {

        flag = 0;
        for(uint i=0; i<pictureCount; i++)
        {
            if(mainpictures[i].id == _idPost)
            {
                flag = 1;
                index = i;
                break;
            }
        }

        if(flag == 0)
        {
            Picture storage temp = mainpictures[pictureCount];
            temp.id = _idPost;
            temp.pictures.push(_pic);
            pictureCount++;
        }
        else
        {
            mainpictures[index].pictures.push(_pic);
        }
    }

    function getPictures(uint _idPost) public view returns(string[] memory){
        string[] memory s;
        for(uint i=0; i<pictureCount; i++)
        {
            if(mainpictures[i].id == _idPost)
            {
                return mainpictures[i].pictures;
            }

        }
        return s;
    }

    function stringToUint(string memory s) public pure returns (uint) {
        bytes memory b = bytes(s);
        uint result = 0;
        for (uint i = 0; i < b.length; i++) { // c = b[i] was not needed
            uint8 c = uint8(b[i]);
            if (c >= 48 && c <= 57) {
                result = result * 10 + (uint(c) - 48); // bytes and int are not compatible with the operator -.
            }
        }
        return result; // this was missing
    }

    function addNewBid(uint _idPost, string memory _newBid, string memory _newBidder) public returns(bool) {
        bool a = false;
        if(stringToUint(posters[_idPost].currentBid) >= stringToUint(_newBid)){
            a = false;
        }
        else{
            posters[_idPost].currentBid = _newBid;
            posters[_idPost].currentBider = _newBidder;
            a = true;
        }
        return a;
    }

    function deletePoster(uint _idPost) public {
        posters[_idPost].deleted = 1;
    }

    function getCurrentBid(uint _idPost) public view returns(string memory) {
        return posters[_idPost].currentBid;
    }


    event PosterCreated(uint id, string name);
    event DateCreated(uint id);

}
