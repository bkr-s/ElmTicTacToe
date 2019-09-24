module Board exposing (..)

import Array exposing (..)


grid =
    List.range 1 (gridSize * gridSize)


gridSize =
    3


cells =
    List.map (\x -> String.fromInt x) grid


makeMove number mark =
    set number mark (fromList cells)
        |> toList
