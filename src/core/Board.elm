module Board exposing (..)

import Array exposing (..)
import List
import String


board =
    { grid = initGrid }


initGrid : List String
initGrid =
    List.range 1 (gridSize * gridSize)
        |> List.map (\x -> String.fromInt x)


gridSize : Int
gridSize =
    3


cells : { grid : List String } -> List String
cells boardRecord =
    List.map (\x -> x) boardRecord.grid


makeMove : Int -> String -> List String -> List String
makeMove position mark currentBoard =
    if isValidMove position currentBoard then
        cells <| updateBoard position mark currentBoard

    else
        currentBoard


updateBoard : Int -> String -> List String -> { grid : List String }
updateBoard position mark currentBoard =
    { grid = setMark position mark currentBoard }


setMark : Int -> String -> List String -> List String
setMark position mark currentBoard =
    set (position - 1) mark (fromList currentBoard)
        |> toList


availableMoves : List String -> List String
availableMoves currentBoard =
    List.filter (\x -> x /= "X" && x /= "O") currentBoard


isValidMove : Int -> List String -> Bool
isValidMove move currentBoard =
    List.member (String.fromInt move) (availableMoves currentBoard)


isFull : List String -> Bool
isFull currentBoard =
    List.all (\x -> x == "X" || x == "O") currentBoard
