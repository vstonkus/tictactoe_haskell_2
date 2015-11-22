{-# LANGUAGE OverloadedStrings #-}

module Main
where

import Parser
import Arbitrator
import Network.HTTP.Client
import Network.HTTP.Types (statusCode)
import Network.HTTP.Types.Header
import Data.String (fromString)
import Data.ByteString.Lazy.Char8 (unpack)
import Text.Printf
import System.Environment


main :: IO ()
main = do
    x <- getArgs
    print x
    --putStrLn $ printf "Program was started%s" args


sendBoard :: Board -> String -> Integer -> IO ()
sendBoard board gameId playerId = do
    manager <- newManager defaultManagerSettings

    -- Create the request
    initialRequest <- parseUrl $ printf "http://tictactoe.homedir.eu/game/%s/player/%d" gameId playerId
    let request = initialRequest {
    method = "POST",
    requestBody = reqBody,
    requestHeaders = [contentTypeHeader]
    }

    response <- httpLbs request manager

    putStrLn $ "The board was sent. Status code was: " ++ (show $ statusCode $ responseStatus response)
    print $ responseBody response

    where reqBody = RequestBodyBS $ fromString $ encode board
          contentTypeHeader = (hContentType, "application/bencode+list")

getBoard :: String -> Integer -> IO(Board)
getBoard gameId playerId = do
    manager <- newManager defaultManagerSettings

    request <- parseUrl $ printf "http://tictactoe.homedir.eu/game/%s/player/%d" gameId playerId
    let request' = request { method = "GET"
                            ,requestHeaders = [acceptHeader]}
    response <- httpLbs request' manager

    putStrLn $ "The status code was: " ++ (show $ statusCode $ responseStatus response)
    print $ responseBody response

    let board = decode $ unpack $ responseBody response
    return board

    where acceptHeader = (hAccept, "application/bencode+list")

