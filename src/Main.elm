module Main exposing (Model)

import Array exposing (Array)
import Board exposing (Board)
import Browser
import Dict
import GameStatus exposing (GameStatus(..), checkGameStatus)
import Html exposing (Attribute, Html, button, div, h1, h4, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Player exposing (Player)



-- MODEL


type alias Model =
    { board : Board, currentPlayer : Player, computerPlayer : Maybe Player, status : GameStatus }


init : Model
init =
    { board = Board.initialBoard, currentPlayer = Player.X, computerPlayer = Nothing, status = NewGame }


type Msg
    = HumanVsHuman
    | HumanVsEasyComputer
    | TakeTurn Int
    | ResetGame
    | NoOp



-- VIEW


view : Model -> Html Msg
view model =
    div [ id "container" ]
        [ div [ id "game-information" ]
            [ viewWelcomeMessage model.status
            , viewGameMenu model.status
            , viewGameStatus model.status model.currentPlayer
            ]
        , div []
            [ viewBoard (List.map Player.showPlayer (Dict.values model.board))
            ]
        ]


viewWelcomeMessage : GameStatus -> Html Msg
viewWelcomeMessage status =
    let
        welcomeMessage =
            case status of
                Playing ->
                    text " "

                Winner _ ->
                    text " "

                Drawn ->
                    text " "

                NewGame ->
                    text "Tic Tac Toe"
    in
    h1 [ class "message", id "welcome-message" ] [ welcomeMessage ]


viewGameMenu : GameStatus -> Html Msg
viewGameMenu status =
    let
        newGameButtons =
            case status of
                Playing ->
                    div []
                        [ text " " ]

                _ ->
                    div []
                        [ buttonNewGame "two-pl-button" "2 Player" HumanVsHuman
                        , buttonNewGame "easy-ai-button" "1 Player (Easy)" HumanVsEasyComputer
                        ]
    in
    div [ class "message", id "game-menu" ] [ newGameButtons ]


buttonNewGame : String -> String -> Msg -> Html Msg
buttonNewGame buttonId buttonText msg =
    button [ id buttonId, onClick msg ] [ text buttonText ]


viewGameStatus : GameStatus -> Player -> Html Msg
viewGameStatus status currentPlayer =
    let
        gameStatusMessage =
            case status of
                Playing ->
                    [ text "" ]

                Winner _ ->
                    [ text (Player.showPlayer currentPlayer), text " wins!!" ]

                Drawn ->
                    [ text "It's a tie!" ]

                NewGame ->
                    [ text "" ]
    in
    h4 [ class "message", id "game-status-message" ] gameStatusMessage


viewBoard : List String -> Html Msg
viewBoard grid =
    Array.fromList grid
        |> formatCells


formatCells : Array String -> Html Msg
formatCells allCells =
    div [ class "board" ]
        [ div [ class "board-row" ]
            [ button [ class "board-cell", onClick (TakeTurn 1) ] [ text (Player.value allCells 0) ]
            , button [ class "board-cell", onClick (TakeTurn 2) ] [ text (Player.value allCells 1) ]
            , button [ class "board-cell", onClick (TakeTurn 3) ] [ text (Player.value allCells 2) ]
            ]
        , div [ class "board-row" ]
            [ button [ class "board-cell", onClick (TakeTurn 4) ] [ text (Player.value allCells 3) ]
            , button [ class "board-cell", onClick (TakeTurn 5) ] [ text (Player.value allCells 4) ]
            , button [ class "board-cell", onClick (TakeTurn 6) ] [ text (Player.value allCells 5) ]
            ]
        , div [ class "board-row" ]
            [ button [ class "board-cell", onClick (TakeTurn 7) ] [ text (Player.value allCells 6) ]
            , button [ class "board-cell", onClick (TakeTurn 8) ] [ text (Player.value allCells 7) ]
            , button [ class "board-cell", onClick (TakeTurn 9) ] [ text (Player.value allCells 8) ]
            ]
        ]



-- UPDATE


update : Msg -> Model -> Model
update msg model =
    case msg of
        HumanVsHuman ->
            { init | status = Playing }

        HumanVsEasyComputer ->
            { init | computerPlayer = Just Player.O, status = Playing }

        TakeTurn position ->
            let
                newModel =
                    if GameStatus.canContinueGame model.status && Board.isValidMove position model.board then
                        { model | board = Board.markBoard position model.currentPlayer model.board }
                            |> updateStatus

                    else
                        model

                addComputerMoveIfRelevant =
                    if isComputerTurn newModel && GameStatus.canContinueGame newModel.status then
                        getComputerMove newModel
                            |> updateStatus

                    else
                        newModel
            in
            addComputerMoveIfRelevant

        ResetGame ->
            init

        NoOp ->
            model


updateStatus : Model -> Model
updateStatus ({ board, currentPlayer } as model) =
    let
        ( newStatus, newCurrentPlayer ) =
            checkGameStatus model.board model.currentPlayer
    in
    { model | status = newStatus, currentPlayer = newCurrentPlayer }


isComputerTurn : Model -> Bool
isComputerTurn ({ board, currentPlayer, computerPlayer } as model) =
    if isComputerPlayer currentPlayer model && (model.status == Playing) then
        True

    else
        False


isComputerPlayer : Player -> Model -> Bool
isComputerPlayer currentPlayer model =
    case model.computerPlayer of
        Just computerPlayer ->
            currentPlayer == computerPlayer

        _ ->
            False


getComputerMove : Model -> Model
getComputerMove model =
    case computerSelectsRandomMove (Board.availableMoves model.board) of
        Just move ->
            { model | board = Board.markBoard move model.currentPlayer model.board }

        Nothing ->
            model


computerSelectsRandomMove : List Int -> Maybe Int
computerSelectsRandomMove availablePositions =
    List.head availablePositions



-- MAIN


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }
