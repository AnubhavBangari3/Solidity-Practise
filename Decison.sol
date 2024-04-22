// SPDX-License-Identifier:MIT

pragma solidity >= 0.7.0 < 0.9.0;

contract  DecisionMaking{ 
    uint a=2;

    function validateCond() public view returns (bool){
        if (a == 2){
            return true;
        }
    }

    uint stakingWallet=10;

    function airDrop() public view returns(uint){
        if (stakingWallet == 10){
           return stakingWallet+10;
            
        }
    }
}