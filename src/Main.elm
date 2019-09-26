module Main exposing (Model)

import Array exposing (Array, get)
import Board exposing (Board)
import Dict
import Html exposing (Html, div, h1, h2, li, text, ul)
import Html.Attributes exposing (class)
import Player exposing (Player)



-- MODEL


type alias Model =
    { board : Board, currentPlayer : Player, otherPlayer : Player }


initModel : Model
initModel =
    { board = Board.initBoard, currentPlayer = Player.X, otherPlayer = Player.O }



-- VIEW


view : Model -> Html msg
view model =
    div []
        [ h1 [] [ text "Welcome To Tic Tac Toe" ]
        , h2 [] [ text "Current board:" ]
        , div [ class "displayGrid" ]
            [ displayGrid (List.map viewBoard (Dict.values model.board))
            ]
        ]


viewBoard : Player -> String
viewBoard player =
    case player of
        Player.X ->
            "X"

        Player.O ->
            "O"

        Player.Unclaimed ->
            "blank"


displayGrid : List String -> Html msg
displayGrid grid =
    Array.fromList grid
        |> formatBoxes


formatBoxes : Array String -> Html msg
formatBoxes allBoxes =
    div []
        [ div [ class "rowOne" ] [ text (Array.get 0 allBoxes |> Maybe.withDefault ""), text (Array.get 1 allBoxes |> Maybe.withDefault ""), text (Array.get 2 allBoxes |> Maybe.withDefault "") ]
        , div [ class "rowTwo" ] [ text (Array.get 3 allBoxes |> Maybe.withDefault ""), text (Array.get 4 allBoxes |> Maybe.withDefault ""), text (Array.get 5 allBoxes |> Maybe.withDefault "") ]
        , div [ class "rowThree" ] [ text (Array.get 6 allBoxes |> Maybe.withDefault ""), text (Array.get 7 allBoxes |> Maybe.withDefault ""), text (Array.get 8 allBoxes |> Maybe.withDefault "") ]
        ]



-- UPDATE
-- MAIN


main : Html msg
main =
    view
        initModel
