// SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 < 0.9.0;

contract DynamicArray{
    uint[] public numbers;

    function getLength() public view returns(uint){

        return numbers.length;

    }

    function addElement(uint item) public{
        numbers.push(item);
    }

    function getElement(uint i) public view returns(uint){
        if (i < numbers.length){
            return numbers[i];
        }
        return 0;
    }

    function popElement() public{
        numbers.pop();
    }

    function f() public{
        //declaring a memory dynamic array
        //It's not possible to resize memory array(push and pop are not available
        uint[] memory y=new uint[](3);
        y[0]=10;
        y[1]=2;
        y[2]=7;
        numbers=y;

    }


}