pragma solidity ^0.4.2;

import "../BaseGame.sol";
import "../../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";


contract Royalties{

    using SafeMath for uint256;

    address private collectionsContract;
    address private artist;

    address[] private receiver;
    mapping(address => uint256) private receiverToPercentOfProfit;
    uint256 private percentRemaining;

    uint256 public amountPaid;

    function Royalties(address _manager, address _artist) public
    {
        collectionsContract = msg.sender;
        artist=_artist;

        receiver.push(_manager);
        receiverToPercentOfProfit[_manager] = 80;
        percentRemaining = 100 - receiverToPercentOfProfit[_manager];
    }

    modifier isCollectionsContract() { 
        require(msg.sender == collectionsContract);
        _;
    }

    modifier isArtist(){
        require(msg.sender == artist);
        _;
    }

    function addRoyaltyReceiver(address _receiver, uint256 _percent) external isArtist{
        require(_percent<percentRemaining);
        receiver.push(_receiver);
        receiverToPercentOfProfit[_receiver] = _percent;
        percentRemaining = percentRemaining.sub(_percent);
    }

    function payoutRoyalties() public payable isCollectionsContract{
        for (uint256 i = 0; i< receiver.length; i++){
            address current = receiver[i];
            uint256 payout = msg.value.mul(receiverToPercentOfProfit[current]).div(100);
            amountPaid = amountPaid.add(payout);
            current.transfer(payout);
        }
        msg.sender.call.value(msg.value-amountPaid)(bytes4(keccak256("collectRemainingFunds()")));
    }

    function getLastPayoutAmountAndReset() external isCollectionsContract returns(uint256){
        uint256 ret = amountPaid;
        amountPaid = 0;
        return ret;
    }

    function () public payable isCollectionsContract{
        payoutRoyalties();
    }
}

contract Manager{
    address public owner;

    function Manager(address _owner) public {
        owner = _owner;
    }

    function withdraw(uint256 _balance) public {
        owner.transfer(_balance);
    }

    function () public payable{
        // empty
    }
}

contract RecordLabel is BaseGame{

    uint256 public funds;
    address public royalties;

    function RecordLabel(address _home, address _player) public
        BaseGame(_home, _player)
    {
        royalties = new Royalties(new Manager(_home), _player);
    }
    
    function() external payable authorized{
        addGameBalance(msg.value);
        funds = funds.add(msg.value);
    }


    function withdrawFundsAndPayRoyalties(uint256 _withdrawAmount) external authorized{
        require(_withdrawAmount<=funds);
        funds = funds.sub(_withdrawAmount);
        royalties.call.value(_withdrawAmount)();
        uint256 royaltiesPaid = Royalties(royalties).getLastPayoutAmountAndReset();
        uint256 artistPayout = _withdrawAmount.sub(royaltiesPaid); 
        subtractGameBalance(artistPayout);
        msg.sender.transfer(artistPayout);
    }

    function collectRemainingFunds() external payable{
        require(msg.sender == royalties);
    }

}
