// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0;
contract GradeContract {

    //storage
    uint public gradeAmount = 0;
    mapping(uint => Grade) public grades;

    struct Grade{
        uint idUser;
        uint idPost;
        uint grade;
    }

    function addToGradeList(uint _idUser, uint _idPost, uint _grade) public {
        Grade storage temp = grades[gradeAmount];
        temp.idUser = _idUser;
        temp.idPost = _idPost;
        temp.grade = _grade;
        gradeAmount++;
    }
}