module Main exposing (Model)

import Board exposing (Board)
import Dict
import Html exposing (Html, div, h1, h2, li, text, ul)
import Player exposing (Player)



-- MODEL


type alias Model =
    { board : Board, currentPlayer : Player, otherPlayer : Player }


initModel : Model
initModel =
    { board = Board.initBoard, currentPlayer = Player.X, otherPlayer = Player.O }



-- UPDATE
-- VIEW


view : Model -> Html msg
view model =
    div [] [ h1 [] [ text "Welcome To Tic Tac Toe" ], h2 [] [ text "Current board:" ], ul [] (List.map viewBoard (Dict.values model.board)), h2 [] [ text "Players: " ], ul [] (List.map viewPlayer [ model.currentPlayer, model.otherPlayer ]) ]


viewBoard : Player -> Html msg
viewBoard player =
    case player of
        Player.X ->
            li [] [ text "X" ]

        Player.O ->
            li [] [ text "O" ]

        Player.Unclaimed ->
            li [] [ text "blank" ]


viewPlayer : Player -> Html msg
viewPlayer player =
    case player of
        Player.X ->
            li [] [ text "X" ]

        Player.O ->
            li [] [ text "O" ]

        Player.Unclaimed ->
            li [] [ text "blank" ]



--


main : Html msg
main =
    view initModel
