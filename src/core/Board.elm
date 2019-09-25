module Board exposing (availableMoves, currentBoard, hasPlayerWon, initBoard, isATie, isFull, isValidMove, marksBoardIfValidMove)

import Array exposing (..)
import List
import String


type alias Board =
    { grid : List String }


initBoard : Board
initBoard =
    { grid = initGrid }



-- GRID INITIALISERS


initGrid : List String
initGrid =
    List.range 1 (gridSize * gridSize)
        |> List.map (\x -> String.fromInt x)


gridSize : Int
gridSize =
    3



-- WINNING COMBINATIONS
-- @private


winningLines : List (List Int)
winningLines =
    [ [ 0, 1, 2 ]
    , [ 3, 4, 5 ]
    , [ 6, 7, 8 ]
    , [ 0, 3, 6 ]
    , [ 1, 4, 7 ]
    , [ 2, 5, 8 ]
    , [ 2, 4, 6 ]
    , [ 0, 4, 8 ]
    ]



-- CURRENT GRID


currentBoard : { grid : List String } -> List String
currentBoard board =
    List.map (\x -> x) board.grid



-- ACTIONS ON BOARD


marksBoardIfValidMove : Int -> String -> List String -> List String
marksBoardIfValidMove position mark board =
    if isValidMove position board then
        currentBoard <| updateBoard position mark board

    else
        board


isValidMove : Int -> List String -> Bool
isValidMove move board =
    List.member (String.fromInt move) (availableMoves board)



--@private


markBoard : Int -> String -> List String -> List String
markBoard position mark board =
    set (position - 1) mark (Array.fromList board)
        |> Array.toList



-- @private


updateBoard : Int -> String -> List String -> { grid : List String }
updateBoard position mark board =
    { grid = markBoard position mark board }


availableMoves : List String -> List String
availableMoves board =
    List.filter (\x -> x /= "X" && x /= "O") board


isFull : List String -> Bool
isFull board =
    List.all (\x -> x == "X" || x == "O") board


hasPlayerWon : String -> List String -> Bool
hasPlayerWon mark board =
    checkAllLines mark board



-- @private


checkAllLines : String -> List String -> Bool
checkAllLines mark board =
    winningLines
        |> List.map (\lines -> checkSingleLine mark lines board)
        |> List.filter ((==) True)
        |> List.isEmpty
        |> not



-- @private


checkSingleLine : String -> List Int -> List String -> Bool
checkSingleLine mark lines board =
    lines
        |> List.map (\index -> get index (Array.fromList board) |> Maybe.withDefault "")
        |> List.filter (\x -> x == mark)
        |> List.length
        |> (==) 3


isATie : List String -> Bool
isATie board =
    isFull board && not (hasPlayerWon "X" board) && not (hasPlayerWon "O" board)
