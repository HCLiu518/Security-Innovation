pragma solidity ^0.4.21;





contract caller {
    address _addr;
    
    function _set (address addr) public{
        _addr = addr;
    }
    
    function _callLottery (uint32 _gas,bool _theans) public { 
        _addr.call.value(msg.value).gas(_gas)(bytes4(sha3("play(bool)")),_theans);
    }
    
    
    
}

contract Lottery is caller {
    
    function gogo(uint32 _gasuse) public payable  {
        bytes32 entropy = blockhash(block.number-1);
        bytes1 coinFlip = entropy[0] & 1;
        if (coinFlip == 1) {
            _callLottery(_gasuse, true);
        }
        else{
            _callLottery(_gasuse, false);
        }
    }
    
}
