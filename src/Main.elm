module Main exposing (Model)

import Array exposing (Array)
import Board exposing (Board)
import Browser
import Dict
import Html exposing (Attribute, Html, button, div, h1, h4, text)
import Html.Attributes exposing (class, id)
import Html.Events exposing (onClick)
import Player exposing (Player)



-- MODEL


type alias Model =
    { board : Board, currentPlayer : Player, computerPlayer : Maybe Player, status : GameStatus }


init : Model
init =
    { board = Board.initBoard, currentPlayer = Player.X, computerPlayer = Nothing, status = NewGame }


type GameStatus
    = NewGame
    | Playing
    | Winner Player
    | Drawn


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
        [ viewWelcomeMessage model
        , viewGameMenu model
        , viewGameStatus model
        , div []
            [ viewBoard (List.map showPlayer (Dict.values model.board))
            ]
        ]


viewWelcomeMessage : Model -> Html Msg
viewWelcomeMessage model =
    let
        welcomeMessage =
            case model.status of
                Playing ->
                    text ""

                Winner _ ->
                    text ""

                Drawn ->
                    text ""

                NewGame ->
                    text "Welcome To Tic Tac Toe"
    in
    h1 [ class "message", id "welcome-message" ] [ welcomeMessage ]


viewGameMenu : Model -> Html Msg
viewGameMenu model =
    let
        newGameButtons =
            case model.status of
                Playing ->
                    text ""

                _ ->
                    div []
                        [ text "Start new game: "
                        , buttonNewGame "2 Player" HumanVsHuman
                        , buttonNewGame "1 Player (Easy)" HumanVsEasyComputer
                        ]
    in
    div [ class "message", id "game-menu" ] [ newGameButtons ]


buttonNewGame : String -> Msg -> Html Msg
buttonNewGame buttonText msg =
    button [ class "new-game-button", onClick msg ] [ text buttonText ]


viewGameStatus : Model -> Html Msg
viewGameStatus model =
    let
        gameStatusMessage =
            case model.status of
                Playing ->
                    [ text "" ]

                Winner _ ->
                    [ text (showPlayer model.currentPlayer), text " wins!!" ]

                Drawn ->
                    [ text "It's a tie!" ]

                NewGame ->
                    [ text "" ]
    in
    h4 [ class "message", id "game-status-message" ] gameStatusMessage


showPlayer : Player -> String
showPlayer player =
    case player of
        Player.X ->
            "X"

        Player.O ->
            "O"

        Player.Unclaimed ->
            ""


viewBoard : List String -> Html Msg
viewBoard grid =
    Array.fromList grid
        |> formatCells


formatCells : Array String -> Html Msg
formatCells allCells =
    div [ class "board" ]
        [ div [ class "board-row" ]
            [ button [ onClick (TakeTurn 1) ] [ text (currentPlayerValue allCells 0) ]
            , button [ onClick (TakeTurn 2) ] [ text (currentPlayerValue allCells 1) ]
            , button [ onClick (TakeTurn 3) ] [ text (currentPlayerValue allCells 2) ]
            ]
        , div [ class "board-row" ]
            [ button [ onClick (TakeTurn 4) ] [ text (currentPlayerValue allCells 3) ]
            , button [ onClick (TakeTurn 5) ] [ text (currentPlayerValue allCells 4) ]
            , button [ onClick (TakeTurn 6) ] [ text (currentPlayerValue allCells 5) ]
            ]
        , div [ class "board-row" ]
            [ button [ onClick (TakeTurn 7) ] [ text (currentPlayerValue allCells 6) ]
            , button [ onClick (TakeTurn 8) ] [ text (currentPlayerValue allCells 7) ]
            , button [ onClick (TakeTurn 9) ] [ text (currentPlayerValue allCells 8) ]
            ]
        ]


currentPlayerValue : Array String -> Int -> String
currentPlayerValue grid index =
    Array.get index grid |> Maybe.withDefault ""



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
                    if canContinueGame model && Board.isValidMove position model.board then
                        { model | board = Board.markBoard position model.currentPlayer model.board }
                            |> checkGameStatus

                    else
                        model

                addComputerMoveIfRelevant =
                    if isComputerTurn newModel && canContinueGame newModel then
                        getComputerMove newModel
                            |> checkGameStatus

                    else
                        newModel
            in
            addComputerMoveIfRelevant

        ResetGame ->
            init

        NoOp ->
            model


canContinueGame : Model -> Bool
canContinueGame model =
    model.status == Playing || model.status == NewGame


checkGameStatus : Model -> Model
checkGameStatus ({ board, currentPlayer } as model) =
    let
        isWinningPlayer =
            Board.hasPlayerWon currentPlayer board

        isDrawnGame =
            Board.isATie board

        ( newStatus, newCurrentPlayer ) =
            case ( isWinningPlayer, isDrawnGame ) of
                ( True, False ) ->
                    ( Winner currentPlayer, currentPlayer )

                ( False, True ) ->
                    ( Drawn, currentPlayer )

                ( False, False ) ->
                    ( Playing, getOpponent currentPlayer )

                ( _, _ ) ->
                    ( NewGame, currentPlayer )
    in
    { model | status = newStatus, currentPlayer = newCurrentPlayer }


getOpponent : Player -> Player
getOpponent player =
    case player of
        Player.X ->
            Player.O

        Player.O ->
            Player.X

        Player.Unclaimed ->
            Player.Unclaimed


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
