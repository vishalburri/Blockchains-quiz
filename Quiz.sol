pragma solidity ^0.4.24;

contract Quiz
{
    uint[] gameBoard = new uint[](9);
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

    function startGame()   {
        require (numPlayers==2);
        require (owner==msg.sender);

        isStart = true;
        playerTurn=1;
    }

    function playGame(uint move) checkPlayer public {
        
        require (move >0 && move <=9,"Invalid move");
        require (gameBoard[move-1]==0,"Invalid Move");

        gameBoard[move-1] = playerTurn;
        winner = getWinner();
        if(winner > 0){
            endGame();
        }
        changePlayer();
    }
    
    function endGame() private {
        playerTurn=0;
        isStart=false;
    }

    function getWinner () private returns(uint res)  {
        
        for(uint i=0;i<8;i++){
            uint[] memory curstate = winnerStates[i];
            if(gameBoard[curstate[0]]!=0 && gameBoard[curstate[0]]==gameBoard[curstate[1]] && gameBoard[curstate[1]]==gameBoard[curstate[2]])
                return gameBoard[curstate[0]];
        }
        return 0;
    }
    
    function changePlayer () private {
        
        if(msg.sender==player1){
            playerTurn=2;
        }
        if(msg.sender==player2){
            playerTurn=1;
        }
    }

    function viewBoardState() public returns(uint[])  {
        return gameBoard;
    }
    
    

}








    