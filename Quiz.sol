pragma solidity ^0.4.24;

contract Quiz
{
    uint8[] gameBoard = new uint[](9);
    address owner;

    address player1;
    address player2;

    uint playerTurn;
    uint winner;
    uint numPlayers;
    bool isStart;
    uint[][] winnerStates = [[0,1,2],[3,4,5],[6,7,8],
                          [0,3,6],[1,4,7],[2,5,8],
                          [0,4,8],[2,4,6]];
    constructor() public
    {
        owner = msg.sender;
    }

    modifier checkPlayer() { 
        if((player1==msg.sender && playerTurn==1) || (player2==msg.sender && playerTurn==2)) 
        _; 
        else
            throw;
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

        isStart = true;
        playerTurn=1;
    }

    function playGame(uint move) checkPlayer public {
        
        require (move >0 && move <=9,"Invalid move");
        require (gameBoard[move-1]==0,"Invalid Move");

        gameBoard[move-1] = move;
        winner = getWinner();
        if(winner > 0){
            endGame();
        }
        changePlayer();
    }

    function getWinner () returns(uint res) private {
        
    }
    
    function changePlayer () private {
        if(msg.sender==player1){
            playerTurn=2;
        }
        if(msg.sender==player2){
            playerTurn=1;
        }
    }
    

}








    