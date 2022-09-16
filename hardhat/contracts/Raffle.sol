// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";


contract Raffle is VRFConsumerBaseV2, Ownable {
  VRFCoordinatorV2Interface COORDINATOR;


  //VRFCoordinator Variables and Instructions //
  // Your subscription ID. //
  uint64 s_subscriptionId;

  // Goerli coordinator. For other networks,
  // see https://docs.chain.link/docs/vrf-contracts/#configurations //
  address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;

  // The gas lane to use, which specifies the maximum gas price to bump to. //
  // For a list of available gas lanes on each network,
  // see https://docs.chain.link/docs/vrf-contracts/#configurations //
  bytes32 keyHash = 0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;

  // Depends on the number of requested values that you want sent to the
  // fulfillRandomWords() function. Storing each word costs about 20,000 gas,
  // so 100,000 is a safe default for this example contract. Test and adjust
  // this limit based on the network that you select, the size of the request,
  // and the processing of the callback request in the fulfillRandomWords()
  // function. //
  uint32 callbackGasLimit = 500000;
    // The default is 3, but you can set this higher. //
  uint16 requestConfirmations = 3;
  // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS. //
  uint32 numWords =  1;

  uint256[] public s_randomWords;
  uint256 public s_requestId;
  address s_owner;


    address private s_recentWinner;
  // Address of the players //
    address[] public players;
    //Max number of players in one game //
    uint8 maxPlayers;
    // Variable to indicate if the game has started or not //
    bool public gameStarted = false;
    // the fees for entering the game //
    uint256 entryFee;
    // current game id //
    uint256 public gameId;

    // emitted when the game starts //
    event GameStarted(uint256 gameId, uint8 maxPlayers, uint256 entryFee);
    // emitted when someone joins a game //
    event PlayerJoined(uint256 gameId, address player);
    // emitted when a winner is picked //
    event WinnerPicked();
    // emitted when the game ends //
    event GameEnded(uint256 gameId);

    error Raffle__TransferFailed();

  constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
    COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    s_owner = msg.sender;
    s_subscriptionId = subscriptionId;
  }

  

  // Assumes the subscription is funded sufficiently. //
  function requestRandomWords() internal {
    // Will revert if subscription is not set and funded. //
    s_requestId = COORDINATOR.requestRandomWords(
      keyHash,
      s_subscriptionId,
      requestConfirmations,
      callbackGasLimit,
      numWords
    );
  }

  function fulfillRandomWords(
    uint256, /* requestId */
    uint256[] memory randomWords
  ) internal override {
        // Find the winning address index //
        uint256 indexOfWinner = randomWords[0] % players.length;
        // Assign the winning address to local storage //
        address recentWinner = players[indexOfWinner];
        // Assign the winning address to our global storage //
        s_recentWinner = recentWinner;
        // Clear the players array for our next game //
        players = new address payable[](0);
        // Call the endGame function //
        endGame();
  }

function startGame(uint8 _maxPlayers, uint256 _entryFee) public onlyOwner {
        // Check if there is a game already running //
        require(!gameStarted, "Game is currently running");
        // set the max players for this game //
        maxPlayers = _maxPlayers;
        // set the game started to true //
        gameStarted = true;
        // setup the entryFee for the game //
        entryFee = _entryFee;
        // Increase game ID //
        gameId += 1;
        emit GameStarted(gameId, maxPlayers, entryFee);
    }

    function joinGame() public payable {
        // Check if a game is already running //
        require(gameStarted, "Game has not been started yet");
        // Check if the value sent by the user matches the entryFee //
        require(msg.value == entryFee, "Value sent is not equal to entryFee");
        // Check if there is still some space left in the game to add another player //
        require(players.length < maxPlayers, "Game is full");
        // add the sender to the players list //
        players.push(msg.sender);
        emit PlayerJoined(gameId, msg.sender);
        // If the list is full start the winner selection process //
        
         if(players.length == maxPlayers) {
            requestRandomWords();
            emit WinnerPicked();
            emit GameEnded(gameId);
            gameStarted = false;
        }
    }

    function endGame() public {
        (bool success, ) = s_owner.call{value: address(this).balance}("");
        // require(success, "Transfer failed"); //
        if (!success) {
            revert Raffle__TransferFailed();
        } 
    }


}