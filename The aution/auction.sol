// SPDX-License-Identifier:MIT
pragma solidity >=0.8.0 < 0.9.0;

contract AuctionCreator{
    Auction[] public auctions;

    function createAuction() public{
        Auction newAuction=new Auction(msg.sender);
        auctions.push(newAuction);

    }
}

contract Auction{
    address payable public owner;
    uint public startBlock;
    uint public endBlock;

    string public ipfsHash;
    enum State {Started,Running,Ended,Canceled}

    State public auctionState;

    uint public highestBindingBid;

    address payable public highestBidder;

    mapping(address => uint) public bids;
    uint bidIncrement;

    constructor(address eoa){
        owner=payable(eoa);
        auctionState=State.Running;
        startBlock=block.number;
        endBlock=startBlock+3;
        ipfsHash="";
        bidIncrement=1000000000000000000;
    }

    modifier notOwner(){
        require(msg.sender != owner);
        _;
    }

    modifier afterStart(){
        require(block.number >= startBlock);
        _;
    }

    modifier beforeEnd(){
        require(block.number <= endBlock);
        _;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    function min(uint a,uint b) pure internal returns(uint){
        if (a<=b){
            return a;
        }
        else{
            return b;
        }
    }

    function cancelAuction() public onlyOwner{
        auctionState=State.Canceled;
    }

    function placeBid() public payable notOwner afterStart beforeEnd{
        require(auctionState == State.Running);
        require(msg.value >= 100);

        uint currentBid = bids[msg.sender]+msg.value;
        require(currentBid > highestBindingBid);

        bids[msg.sender]=currentBid;

        if(currentBid <= bids[highestBidder]){
            highestBindingBid=min(currentBid+bidIncrement,bids[highestBidder]);

        }
        else{
            highestBindingBid=min(currentBid,bids[highestBidder]+bidIncrement);
            highestBidder=payable(msg.sender);
        }

    }

    function finalizeAuction() public{
        require(auctionState == State.Canceled || block.number > endBlock);
        require(msg.sender == owner || bids[msg.sender] > 0);
        address payable recipient;
        uint value;

        if (auctionState == State.Canceled){//auction was canceled
            recipient=payable(msg.sender);
            value=bids[msg.sender];

        }
        else{ //auction ended(not canceled)
            if(msg.sender == owner){ //this is the owner
                recipient=owner;
                value=highestBindingBid;
            }
            else{ //this is the bidder
                if(msg.sender==highestBidder){
                    recipient=highestBidder;
                    value=bids[highestBidder]-highestBindingBid;
                }
                else{ //this is neither the owner nor the highest bidder
                    recipient=payable(msg.sender);
                    value=bids[msg.sender];
                }
            }
        }
        //resetting the bids of recipient to zero
        bids[recipient]=0;

    recipient.transfer(value);
    }

}