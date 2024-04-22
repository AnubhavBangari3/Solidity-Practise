// SPDX-License-Identifier:MIT
pragma solidity >=0.7.0 < 0.9.0;

contract FixedSizeArrays{
    uint[3] public numbers=[4,3,2];
    bytes1 public b1;
    bytes2 public b2;
    bytes3 public b3;
    function setElements(uint index,uint value) public{
        numbers[index]=value;
    }
    function getLength() public view returns(uint){
        return numbers.length;
    }
    function setBytesArray() public{
        b1='a';
        b2='ab';
        b3='abc';
    }
}