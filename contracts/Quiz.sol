pragma solidity ^0.4.24;

contract Quiz
{
    uint[] gameBoard = new uint[](9);
    address owner;

    address player1;
    address player2;
    uint public joinFee;
    uint playerTurn;
    uint public winner;
    uint numPlayers;
    bool isStart;
    uint[][] winnerStates = [[0,1,2],[3,4,5],[6,7,8],
                          [0,3,6],[1,4,7],[2,5,8],
                          [0,4,8],[2,4,6]];
    bool isPaid;                      
    event gameEnded(uint winner);                      

    constructor(uint _fee) public 
    {
        owner = msg.sender;
        joinFee = _fee;
    }
    
    modifier checkPlayer(){
        if ((playerTurn == 1 && msg.sender == player1) || (playerTurn == 2 && msg.sender == player2))
        _;
        
    }

    modifier onlyOwner(){
        if (msg.sender==owner)
        _;
        
    }
    

    function joinGame() public payable {

        require (numPlayers<=2,"Exceeded number");
        require (msg.value >=joinFee);
        numPlayers++;        
        if(player1==address(0)){
            player1 = msg.sender;
            return;
        }
        if(player2==address(0)){
            player2 = msg.sender;
            return;
        }
        
    }

    function startGame() public onlyOwner{
        require (numPlayers==2);

        isStart = true;
        playerTurn=1;
    }

    function playGame(uint move) public checkPlayer {
        
        require (move >0 && move <=9,"Invalid move");
        require (gameBoard[move-1]==0,"Invalid Move");
        require (isStart==true);
        
        gameBoard[move-1] = playerTurn;
        winner = getWinner();
        if(winner != 0){
            endGame();
            emit gameEnded(winner);
            return;
        }
        if(playerTurn==1)
            playerTurn=2;
        else if(playerTurn==2)
            playerTurn=1;
    }
    
    function endGame() private {
        playerTurn=0;
        isStart=false;
    }

    function getWinner () private view returns(uint res)  {
        
        for(uint i=0;i<8;i++){
            uint[] memory curstate = winnerStates[i];
            if(gameBoard[curstate[0]]!=0 && gameBoard[curstate[0]]==gameBoard[curstate[1]] && gameBoard[curstate[1]]==gameBoard[curstate[2]])
                return gameBoard[curstate[0]];
        }
        return 0;
    }
    

    function viewBoardState() public view returns(uint[])  {
        
        require (msg.sender==player1 || msg.sender==player2);

        return gameBoard;
    }

    function sendPayment() public onlyOwner{
     
     require (isStart==false);
     require (isPaid==false);
     
      address winnerAddr;
      if(winner==1)
        winnerAddr=player1;
      else if(winner==2)
        winnerAddr=player2;
       
       isPaid=true; 
       winnerAddr.transfer(2*joinFee);
       selfdestruct(owner);             
    }


}

