pragma solidity ^0.4.2;

//https://github.com/OpenZeppelin/zeppelin-solidity/blob/master/contracts/math/SafeMath.sol
import "../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";

contract BaseGame{
    
    using SafeMath for uint256;

    uint256 public contractBalance;
    mapping(address => bool) internal authorizedToPlay;
    
    event BalanceUpdate(uint256 balance);

    function BaseGame(address _home, address _player) public {
        authorizedToPlay[_home] = true;
        authorizedToPlay[_player] = true;
    }
    
    // This modifier is added to all external and public game functions
    // It ensures that only the correct player can interact with the game
    modifier authorized() { 
        require(authorizedToPlay[msg.sender]);
        _;
    }
    
    // This is called whenever the contract balance changes to synchronize the game state
    function addGameBalance(uint256 _value) internal{
        require(_value > 0);
        contractBalance = contractBalance.add(_value);
        BalanceUpdate(contractBalance);
    }

    // This is called whenever the contract balance changes to synchronize the game state    
    function subtractGameBalance(uint256 _value) internal{
        require(_value<=contractBalance);
        contractBalance = contractBalance.sub(_value);
        BalanceUpdate(contractBalance);
    }

    // Add an authorized wallet or contract address to play this game
    function addAuthorizedWallet(address _wallet) external authorized{
        authorizedToPlay[_wallet] = true;
    }

}
