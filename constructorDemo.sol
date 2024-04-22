// SPDX-License-Identifier:MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract Property2{
    uint public price;
    string public location;
    address immutable public owner;

    constructor(uint _price,string memory _location){
        price=_price;
        location=_location;
        owner=msg.sender;
    }

    function setPrice(uint _price) public{
        price=_price;
    }

    function getPrice() public view returns(uint){
        return price;
    }

    function setLocation(string memory _location) public{
        location=_location;
    }
    function getLocation() public view returns(string memory){
        return location;
    }
    

}