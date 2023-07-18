# Tic-Tac-Toe


How to deploy on the blockchain?

- Deploy the contracts "TicTacToeToken," "Achievement5Wins," and "AchievementBoardNotFull."
- Deploy the contract "TicTacToe" and pass the addresses of the contracts as arguments to its constructor.
- Change the owner of the contracts "TicTacToeToken," "Achievement5Wins," and "AchievementBoardNotFull" to the address of "TicTacToe" using the transferOwnership() function.

---------------------------------------------

How to play?

- Initialize a match by calling the initMatch() function, which will return the match ID. You will need this ID for further actions. Make sure to pass the addresses of the players as parameters.
- Execute moves in the game using the play() function. You should provide the match ID and the move you wish to make as arguments.
- You must take into account that the board squares are numbered as follows:
  

                                                           1  |  2  |  3

                                                           4  |  5  |  6
 
                                                           7  |  8  |  9
