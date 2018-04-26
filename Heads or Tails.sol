pragma solidity ^0.4.2;

import "../BaseGame.sol";

contract HeadsOrTails is BaseGame{

    uint256 public gameFunds;
    uint256 public cost;

    function HeadsOrTails(address _home, address _player) public
        BaseGame(_home, _player)
    {
    }
    
    function() external payable authorized{
        require(cost==0);
        addGameBalance(msg.value);
        gameFunds = gameFunds.add(msg.value);
        cost = gameFunds.div(10);
    }

    function play(bool _heads) external payable authorized{
        require(msg.value == cost);
        require(gameFunds >= cost.div(2));
        bytes32 entropy = block.blockhash(block.number-1);
        bytes1 coinFlip = entropy[0] & 1;
        if ((coinFlip == 1 && _heads) || (coinFlip == 0 && !_heads)) {
            //win
            subtractGameBalance(msg.value.div(2));
            gameFunds = gameFunds.sub(msg.value.div(2));
            msg.sender.transfer(msg.value.mul(3).div(2));
        }
        else {
            //loser
            addGameBalance(msg.value);
            gameFunds = gameFunds.add(msg.value);
        }
    }

}
