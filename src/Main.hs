{-# LANGUAGE OverloadedStrings #-}

module Main
where

import Parser
import Arbitrator
import Network.HTTP.Client
import Network.HTTP.Types (statusCode)
import Network.HTTP.Types.Header (hAccept, hContentType, Header)
import Data.String (fromString)
import Data.ByteString.Lazy.Char8 (unpack)
import Text.Printf (printf)
import System.Environment (getArgs)


main :: IO ()
main = do
    ids <- getArgs
    sequence_ $ map (\id -> play id) ids

play :: String -> IO()
play gameId = do
    sendBoard [(actions!!0)] gameId 1
    print $ "Board was sent."

    --Other client action
    board <- getBoard gameId 2
    sendBoard (otherClientActions!!0:board) gameId 2

    board <- getBoard gameId 1
    print $ "Waiting for action."
    sendBoard (actions!!1:board) gameId 1
    print $ "Board was sent."

    --Other client action
    board <- getBoard gameId 2
    sendBoard (otherClientActions!!1:board) gameId 2

    board <- getBoard gameId 1
    print $ "Waiting for action."
    sendBoard (actions!!2:board) gameId 1
    print $ "Board was sent."

    where actions = [('X',0,1),('X',1,1),('X',2,1)]
          otherClientActions = [('o',2,0),('o',2,2)]

sendBoard :: Board -> String -> Integer -> IO ()
sendBoard board gameId playerId = do
    manager <- newManager defaultManagerSettings

    initialRequest <- parseUrl $ printf "http://tictactoe.homedir.eu/game/%s/player/%d" gameId playerId
    let request = initialRequest {
    method = "POST",
    requestBody = reqBody,
    requestHeaders = [contentTypeHeader]
    }

    response <- httpLbs request manager

    where reqBody = RequestBodyBS $ fromString $ encode board
          contentTypeHeader = (hContentType, "application/bencode+list")

getBoard :: String -> Integer -> IO(Board)
getBoard gameId playerId = do
    manager <- newManager defaultManagerSettings

    request <- parseUrl $ printf "http://tictactoe.homedir.eu/game/%s/player/%d" gameId playerId
    let request' = request { method = "GET"
                            ,requestHeaders = [acceptHeader]}
    response <- httpLbs request' manager

    let board = decode $ unpack $ responseBody response
    return board

    where acceptHeader = (hAccept, "application/bencode+list")

