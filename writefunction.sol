// SPDX-License-Identifier:MIT
pragma solidity >= 0.7.0 < 0.9.0;

contract learnFunctions{
    //function-name(paramter-list) scope returns()
    function remoteControlOpen(bool closedDoor) public returns(bool){

    }
    function addValues() public view returns(uint)
    {
        uint a=2;
        uint b=3;

        uint result=a+b;

        return result;

    }
    function multiplyCalc(uint a,uint b) public view returns (uint){
        

        uint ans=a*b;
        return ans;
    }
     function addNewValues() public view returns(uint)
    {
        uint a=7;
        uint b=11;

        uint result=a+b;

        return result;

    }

    function divideCalc(uint a,uint b) public view returns(uint){
        uint d=a/b;
        return d;
    }

}