// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.12 <9.0.0; 

contract TicTacToe {
    
    struct Match{
        address player1;
        address player2;             
        Turn nextTurn;
        address winner;        
        address [9] board;
    }   

    struct Turn{
        uint number; 
        address player;  
    }

    Match[] public matches;
    mapping(address => uint) public victories;
    Achievement private achievement5Wins;
    Achievement private achievementBoardNotFull;
    Token private pointsToken;

    constructor(address _achievement5WinsAddress, address _achievementBoardNotFullAddress, address pointsTokenAddress) {
        achievement5Wins = Achievement(_achievement5WinsAddress);
        achievementBoardNotFull = Achievement(_achievementBoardNotFullAddress);
        pointsToken = Token(pointsTokenAddress);
    }

    event newMatch(   
        uint idMatch,
        address player1, 
        address player2 
    ); 

    event newPlay(  
        uint idMatch,
        uint cell,
        address player
    );

    event winnerMatch(  
        uint idMatch,        
        address player
    );

    modifier matchExist(uint idMatch){
        require(matches.length > idMatch, "The match does not exist");         
        _;
    }

    modifier playerOfTheMatch(uint idMatch){
        require(matches[idMatch].player1 == _msgSender() || matches[idMatch].player2 == _msgSender(), "You are not a player of this match");         
        _;
    }

    modifier matchInProgress(uint idMatch){
        require(matches[idMatch].nextTurn.number < 10 && matches[idMatch].winner == address(0), "The match has already ended");         
        _;
    }

     modifier myTurn(uint idMatch){
        require(matches[idMatch].nextTurn.player == _msgSender() || matches[idMatch].nextTurn.player == address(0), "It's not your turn");         
        _;
    }

    modifier wrongPlay(uint cell){
        require(cell >= 1 && cell <= 9, "Wrong move, the possible plays are from 1 to 9");         
        _;
    }
  
    modifier allowedPlay(uint idMatch, uint cell){
        require(matches[idMatch].board[cell-1] == address(0), "That move was already made");         
        _;
    }
   

    function initMatch(address player1, address player2) public returns (uint){

        address[9] memory newBoard = [address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0),address(0)];  
        Match memory game = Match(player1,player2,Turn(1,address(0)),address(0),newBoard);
        matches.push(game);
        emit newMatch(matches.length - 1, player1, player2);

        return matches.length - 1;
    }

    function play(uint idMatch, uint cell) matchExist(idMatch) playerOfTheMatch(idMatch) matchInProgress(idMatch) myTurn(idMatch) wrongPlay(cell) allowedPlay(idMatch,cell)  public{
 
        matches[idMatch].board[cell-1] = _msgSender();
        matches[idMatch].nextTurn = Turn(matches[idMatch].nextTurn.number + 1, _msgSender() == matches[idMatch].player1 ? matches[idMatch].player2 : matches[idMatch].player1);
        emit newPlay(idMatch, cell, _msgSender());

        if ( _getWinner(idMatch) != address(0) ){
            matches[idMatch].winner = _msgSender();            
            emit winnerMatch(idMatch, _msgSender());

            victories[_msgSender()] ++;
            if(victories[_msgSender()] == 5){
                achievement5Wins.safeMint(_msgSender());    
            } 

            if(_isNotFull(idMatch)){
                achievementBoardNotFull.safeMint(_msgSender());    
            }

            uint tokenMultiplier = 1;
            if(achievement5Wins.balanceOf(_msgSender()) > 0 || achievementBoardNotFull.balanceOf(_msgSender()) > 0 ){
                tokenMultiplier = 2;
            }
            pointsToken.mint(_msgSender(),1*tokenMultiplier);
            
        }  
    }

    function _getWinner(uint idMatch) internal view returns (address) {

        address result = address(0);

        if(  matches[idMatch].board[0] != address(0)                       && 
           ((matches[idMatch].board[0] == matches[idMatch].board[0+1] && 
             matches[idMatch].board[0] == matches[idMatch].board[0+2])   ||
            (matches[idMatch].board[0] == matches[idMatch].board[0+3] &&
             matches[idMatch].board[0] == matches[idMatch].board[0+6])   || 
            (matches[idMatch].board[0] == matches[idMatch].board[0+4] && 
             matches[idMatch].board[0] == matches[idMatch].board[0+8])))
        {
            result = matches[idMatch].board[0];    
        }
        else if( matches[idMatch].board[1] != address(0)                    && 
                (matches[idMatch].board[1] == matches[idMatch].board[1+3] && 
                matches[idMatch].board[1] == matches[idMatch].board[1+6]))                       
        {
            result = matches[idMatch].board[1];   
        }
        else if(  matches[idMatch].board[2] != address(0)                      && 
                ((matches[idMatch].board[2] == matches[idMatch].board[2+2] && 
                  matches[idMatch].board[2] == matches[idMatch].board[2+4])  ||
                 (matches[idMatch].board[2] == matches[idMatch].board[2+3] && 
                  matches[idMatch].board[2] == matches[idMatch].board[2+6])))                      
        {
            result = matches[idMatch].board[2];   
        }
        else if( matches[idMatch].board[3] != address(0)                    &&
                (matches[idMatch].board[3] == matches[idMatch].board[3+1] && 
                 matches[idMatch].board[3] == matches[idMatch].board[3+2]))                       
        {
            result = matches[idMatch].board[3];   
        }
        else if( matches[idMatch].board[6] != address(0)                    &&
                (matches[idMatch].board[6] == matches[idMatch].board[6+1] && 
                 matches[idMatch].board[6] == matches[idMatch].board[6+2]))                       
        {
            result = matches[idMatch].board[6];   
        }

        return result;
    }

    function _isNotFull (uint idMatch) internal view returns (bool){
        bool result;

        for (uint i = 0; i < 9; i++) 
        {
            if(matches[idMatch].board[i] == address(0)){
                result = true;
                break;
            }   
        }

        return result;
    }
 
    function _msgSender() internal view returns (address) {
        return msg.sender;
    }    
}

interface Achievement {    
  function safeMint(address to) external returns(bool);
  function balanceOf(address to) external returns(uint);
}

interface Token {    
  function mint(address to, uint256 amount) external;
}
