// SPDX-License-Identifier:MIT
pragma solidity >= 0.7.0 < 0.9.0;
interface ERC20Interface {
    function totalSupply() external view returns (uint);
    function balanceOf(address tokenOwner) external view returns (uint balance);
    function transfer(address to, uint tokens) external returns (bool success);
    
    function allowance(address tokenOwner, address spender) external view returns (uint remaining);
    function approve(address spender, uint tokens) external returns (bool success);
    function transferFrom(address from, address to, uint tokens) external returns (bool success);
    
    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}
 
 
// The Cryptos Token Contract
contract Cryptos is ERC20Interface{
    string public name = "Cryptos";
    string public symbol = "CRPT";
    uint public decimals = 0;
    uint public override totalSupply;
    
    address public founder;
    mapping(address => uint) public balances;
    // balances[0x1111...] = 100;
    
    mapping(address => mapping(address => uint)) allowed;
    // allowed[0x111][0x222] = 100;
    
    
    constructor(){
        totalSupply = 1000000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }
    
    //Returns the balance of tokens for a given address.
    function balanceOf(address tokenOwner) public view override returns (uint balance){
        return balances[tokenOwner];
    }
    
    //Allows an address to transfer tokens to another address if the sender has a sufficient balance.
    function transfer(address to, uint tokens) public virtual override returns(bool success){
        require(balances[msg.sender] >= tokens);
        
        balances[to] += tokens;
        balances[msg.sender] -= tokens;
        //Emits a Transfer event
        emit Transfer(msg.sender, to, tokens);
        
        return true;
    }
    
    //Returns the allowed token amount for a spender on behalf of the token owner.
    function allowance(address tokenOwner, address spender) public view override returns(uint){
        return allowed[tokenOwner][spender];
    }
    
    //Allows an address to approve another address to spend a specified number of tokens on its behalf.
    function approve(address spender, uint tokens) public override returns (bool success){
        require(balances[msg.sender] >= tokens);
        require(tokens > 0);
        
        allowed[msg.sender][spender] = tokens;
        //Emits an Approval event.
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    //Allows a spender to transfer tokens from the owner's address to another address,
    // given proper approval and balance.
    
    function transferFrom(address from, address to, uint tokens) public virtual override returns (bool success){
         require(allowed[from][to] >= tokens);
         require(balances[from] >= tokens);
         
         balances[from] -= tokens;
         balances[to] += tokens;
         allowed[from][to] -= tokens;
         
         return true;
     }
}
 
 
contract CryptosICO is Cryptos{
    address public admin;
    address payable public deposit;
    uint tokenPrice = 0.001 ether;  // 1 ETH = 1000 CRTP, 1 CRPT = 0.001
    uint public hardCap = 300 ether;
    uint public raisedAmount; // this value will be in wei
    uint public saleStart = block.timestamp;
    uint public saleEnd = block.timestamp + 604800; //one week
    
    uint public tokenTradeStart = saleEnd + 604800; //transferable in a week after saleEnd
    uint public maxInvestment = 5 ether;
    uint public minInvestment = 0.1 ether;
    
    enum State { beforeStart, running, afterEnd, halted} // ICO states 
    State public icoState;
    
    constructor(address payable _deposit){
        deposit = _deposit; 
        admin = msg.sender; 
        icoState = State.beforeStart;
    }
 
    //Ensures that only the admin can call specific functions.
    modifier onlyAdmin(){
        require(msg.sender == admin);
        _;
    }
    
    
    // emergency stop
    function halt() public onlyAdmin{
        icoState = State.halted;
    }
    
    //Resumes the ICO.
    function resume() public onlyAdmin{
        icoState = State.running;
    }
    
    //Allows the admin to change the deposit address for ICO contributions.
    function changeDepositAddress(address payable newDeposit) public onlyAdmin{
        deposit = newDeposit;
    }
    
    //Returns the current ICO state based on the timestamps and halted status.
    function getCurrentState() public view returns(State){
        if(icoState == State.halted){
            return State.halted;
        }else if(block.timestamp < saleStart){
            return State.beforeStart;
        }else if(block.timestamp >= saleStart && block.timestamp <= saleEnd){
            return State.running;
        }else{
            return State.afterEnd;
        }
    }
 

    event Invest(address investor, uint value, uint tokens);
    //Allows users to invest Ether in the ICO within the specified limits.
 //Updates balances and sends Ether to the deposit addres 
    
    // function called when sending eth to the contract
    function invest() payable public returns(bool){ 
        icoState = getCurrentState();
        require(icoState == State.running);
        require(msg.value >= minInvestment && msg.value <= maxInvestment);
        
        raisedAmount += msg.value;
        require(raisedAmount <= hardCap);
        
        uint tokens = msg.value / tokenPrice;
 
        // adding tokens to the inverstor's balance from the founder's balance
        balances[msg.sender] += tokens;
        balances[founder] -= tokens; 
        deposit.transfer(msg.value); // transfering the value sent to the ICO to the deposit address
        
        emit Invest(msg.sender, msg.value, tokens);
        
        return true;
    }
   
   //A fallback function that forwards Ether sent to the contract to the invest function.
   // this function is called automatically when someone sends ETH to the contract's address
   receive () payable external{
        invest();
    }
  
    //Burns unsold tokens, setting the founder's balance to zero.
    // burning unsold tokens
    function burn() public returns(bool){
        icoState = getCurrentState();
        require(icoState == State.afterEnd);
        balances[founder] = 0;
        return true;
        
    }
    //transfer and transferFrom functions override the base contract's functions to add a check that 
    //tokens can only be transferred after a specific timestamp
    
    function transfer(address to, uint tokens) public override returns (bool success){
        require(block.timestamp > tokenTradeStart); // the token will be transferable only after tokenTradeStart
        
        // calling the transfer function of the base contract
        super.transfer(to, tokens);  // same as Cryptos.transfer(to, tokens);
        return true;
    }
    
    
    function transferFrom(address from, address to, uint tokens) public override returns (bool success){
        require(block.timestamp > tokenTradeStart); // the token will be transferable only after tokenTradeStart
       
        Cryptos.transferFrom(from, to, tokens);  // same as super.transferFrom(to, tokens);
        return true;
     
    }
}