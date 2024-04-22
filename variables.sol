// SPDX-License-Identifier:MIT
pragma solidity >=0.5.0 < 0.9.0;
//Write brief about every scope
contract A{
    int public x=10;
    int y=20;

    function get_y() public view returns(int){
        return y;
    }

    function f1() private  view returns(int){
        return x;
    }

    function f2() public view returns(int){
    int a;
    a=f1();
    return a;
    }
    function f3() internal view returns(int){
        return x;
    }
    function f4() external view returns(int){
        return x;
    }
}

contract B is A{
    int public xx=f3();
}

