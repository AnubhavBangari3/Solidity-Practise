// SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 < 0.9.0;


contract Lottery{
    //: An array of payable addresses that represents the players participating in the lottery.
    address payable[] public players;
    //An address variable that stores the address of the manager or organizer of the lottery.
    address public manager;

    //The constructor is executed once when the contract is deployed. 
    //It sets the manager variable to the address of the account that deploys the contract.
    constructor(){
        manager=msg.sender;

    }
//     The receive function is a special function that is called when the contract receives 
//     Ether without any function call. In this case, it allows anyone to send 0.1 ether to
//     the contract, and the sender's address is added to the players array.
//     It includes a require statement to ensure that the sent value is exactly 0.1 ether.
    receive() external payable{
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender));
    }

    // The getBalance function allows the manager (the address that deployed the contract) 
    // to check the current balance (in Wei) of the contract.
    // It includes a require statement to ensure that only the manager can call this function.
    function getBalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }
    // The random function generates a pseudo-random number based on various parameters, including block.
    // difficulty, block.timestamp, and the number of players in the lottery. Note 
    // that this method is not suitable for secure random number generation and is used for educational 
    //purposes.
    function random() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,players.length)));
    }

    function pickWinner() public{
        //The sender must be the manager.
        require(msg.sender == manager);
        //There must be at least three players to pick a winner.
        require(players.length >= 3);
        uint r=random();
        // It generates a random number, calculates the winner's index, transfers 
        // the entire balance of the contract to the winner, and then resets the players array for a new round.

        address payable winner;
        uint index=r%players.length;
        winner=players[index];
        winner.transfer(getBalance());

        players=new address payable[](0); //resetting the lottery


    }

}