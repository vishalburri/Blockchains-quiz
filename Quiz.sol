pragma solidity ^0.4.24;

contract Quiz
{
    uint8[] gameBoard = new uint8[](9);
    address owner;

    address player1;
    address player2;

    uint8 playerTurn;
    uint winner;
    uint numPlayers;

    uint[][] winnerStates = [[0,1,2],[3,4,5],[6,7,8],
                          [0,3,6],[1,4,7],[2,5,8],
                          [0,4,8],[2,4,6]];
    constructor() public
    {
        owner = msg.sender;
    }

    function joinGame() public {

        require (numPlayers<=2,"Exceeded number");
        
        if(player1==address(0)){
            player1 = msg.sender;
        }
        if(player2==address(0)){
            player2 = msg.sender;
        }
    }
    function startGame()  {
        
        require (numPlayers==2);
        require (owner==msg.sender);
    }
    

}








    