//SPDX-License-Identifier:MIT

pragma solidity ^0.8.0;

contract Property{
    bool public sold;
    uint8 public x=255;
    int8 public y=-10;

    function f1() public{
        x+=1;
    }
}