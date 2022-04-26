// SPDX-License-Identifier: MIT

// Always begin by declaring solidity version
pragma solidity >=0.6.0 <0.9.0;

// Similar to Class
contract SimpleStorage {

    uint256 favoriteNumber; // Unsigned Integer of up to 256 bits
    // bool favoriteBool = false;
    // string favoriteString = "String";
    // int256 favoriteInt = -5;
    // address favoriteAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    // bytes32 favoriteBytes = "cat"; // Object with max size of 32 bits
    
    struct People {
        uint256 favoriteNumber;
        string name;
    }

    //Initialize a dynamic array of People
    People[] public people;
    mapping(string => uint256) public nameToFavoriteNumber;


    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    //view, pure ---view functions don't need to be transacted upon
    // pure functions do some type of math, but don't save anything
    function retrieve() public view returns(uint256) {
        return favoriteNumber;
    }

    // Storing in Memory will only be stored within the function
    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

}