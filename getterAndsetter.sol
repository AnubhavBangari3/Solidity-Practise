// SPDX-License-Identifier:MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract Property{
    int public price;
    string public location="New Delhi";

    function setPrice(int _price) public{
        price=_price;
    }

    function getPrice() public view returns(int){
        return price;
    }

    function setLocation(string memory mem_location) public{
        location=mem_location;
    }
    function getLocation() public view returns(string memory){
        return location;
    }
    

}