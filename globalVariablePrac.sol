// SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 < 0.9.0;

contract Globalvars{
    uint public this_moment=block.timestamp;
    uint public block_number=block.number;
    uint public difficulty=block.difficulty;
    uint public gaslimit=block.gaslimit;

    address public owner;
    uint public sentValue;

    constructor(){
        owner=msg.sender;

    }

    function changeOwner() public{
        owner=msg.sender;
    }

    function sendEther() public payable{
        sentValue=msg.value;
    }

    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}