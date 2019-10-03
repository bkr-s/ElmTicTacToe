# Strategy for Heuristic Unbeatable Player

Based on rules noted on [Wikipedia](https://en.wikipedia.org/wiki/Tic-tac-toe#Strategy)  
Note: only valid when the game hasn't ended and it's the computer's turn to select a move   
In the below examples the Computer's mark is X 

-------
Helpers :  
    - either switch to coordinates based moves OR  
    - create helper functions to say what are corners, what are forks and what are sides
--------
##In order of priority, assuming that no higher priority move needs to be made 

### Win
1. Get the values of the current board for each winning combination  
    e.g.    possible combinations = `[ [ 0, 1, 2], [ 3, 4, 5] ]`  
            current board status = `[ [ X, O, _], [ _, X, X] ]` 
2. Iterate through the current board status, and check whether there are two of the given mark present (the computer's mark)
    e.g.   `|> List.filter (\value -> value == X) |> List.length |> (==) 2`
3. For any case where there are two of the same mark in a possible winning line, if the third position is vacant, select that move to win

### Block
1. Get the values of the current board for each winning combination  
    e.g.    possible combinations = `[ [ 0, 1, 2], [ 3, 4, 5] ]`  
            current board status = `[ [ X, O, _], [ _, X, X] ]` 
2. Get the opponent's mark 
2. Iterate through the current board status, and check whether there are two of the given mark present (the opponent's mark)
    e.g.   `|> List.filter (\value -> value == X) |> List.length |> (==) 2`
3. For any case where there are two of the same mark in a possible winning line, if the third position is vacant, select that move to block the opponent

### Fork
1. Get the values of the current board for each winning combination  
    e.g.    possible combinations = `[ [ 0, 1, 2], [ 3, 4, 5] ]`  
            current board status = `[ [ X, O, _], [ _, X, X] ]` 
2. Use helper function to check whether mark is present in a potential fork and whether the remaining positions are vacant 
3. If mark is present select move to secure fork (to secure the base of the fork, or to create one prong of the fork). On next move, select the third point then pursue a win from there


### Block Opponent's Fork
1. Get the values of the current board for each winning combination  
    e.g.    possible combinations = `[ [ 0, 1, 2], [ 3, 4, 5] ]`  
            current board status = `[ [ X, O, _], [ _, X, X] ]` 
2. Use helper function to check whether opponent mark is present in a potential fork 
3. If mark is present select move to block fork (ideally the base of the fork, or the end of one prong).


### Center 
1. Get the values of the current board
2. If the opponent has played a corner move as the first move of the game, play a centre move
3. If there are no better moves and the centre is vacant, select that move


### Opposite corner
1. Get the values of the current board
2. Check whether the opponent is in a corner position  
3. If true, check whether the corner diagonally opposite is vacant (using helper method to identify appropriate corner)
4. If yes, play the opposite corner 


### Empty corner
1. Get the values of the current board for each winning combination 
2. Check the possible wins against the current board, and see whether mark is present in a corner 
3. If yes, play an adjacent corner (attempts have shown more likely to win or draw with this move, than if one were to play opposite oneself)


### Empty side
1. Get the values of the current board for each winning combination 
2. Check the possible wins against the current board, and see whether mark is present along a combination containing an empty side 
3. Check whether both remaining positions of that combination are vacant 
4. If yes, select that move
5. If no, but there are no better moves, select a side using helper function