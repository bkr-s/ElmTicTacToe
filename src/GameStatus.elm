module GameStatus exposing (..)

import Board exposing (Board)
import Player exposing (Player)


type GameStatus
    = NewGame
    | Playing
    | Winner Player
    | Drawn


canContinueGame : GameStatus -> Bool
canContinueGame status =
    status == Playing || status == NewGame


checkGameStatus : Board -> Player -> ( GameStatus, Player )
checkGameStatus board currentPlayer =
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
                    ( Playing, Player.getOpponent currentPlayer )

                ( _, _ ) ->
                    ( NewGame, currentPlayer )
    in
    ( newStatus, newCurrentPlayer )
