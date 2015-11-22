module Parser
where

import Data.List
import Text.Printf

--------------(  V ,  X ,  Y )
type Action = (Char, Int, Int)
type Board = [Action]

msg  = "ld1:v1:x1:xi0e1:yi2eed1:v1:o1:xi1e1:yi0eed1:v1:x1:xi0e1:yi0eee"

decode :: String -> Board
decode ('l' : msg) = 
    let
    (external, _) = decodeBoard msg []
    in external
decode _ = error "No message"

decodeBoard :: String -> Board -> (Board, String)
decodeBoard ('e':left) acc = (acc, left)
decodeBoard ('d':dict) acc =
    let
    (d,left) = readAction dict
    in decodeBoard left (d:acc)
decodeBoard str ext = error ("Invalid message. Unparsed content: " ++ str) 

readAction :: String -> (Action, String)
readAction str =
    let
        (key1, val1, left) = readItem str
        (key2, val2, left2) = readItem left
        (key3, val3, left3) = readItem left2
        ('e' : left4) = left3
        items = [(key1, val1),(key2, val2),(key3, val3)]
        v1 = match (=='v') items
        v2 = read [(match (=='x') items)] :: Int
        v3 = read [(match (=='y') items)] :: Int
    in ((v1,v2,v3), left4)


readItem :: String -> (Char, Char, String)
readItem str =
    let
        (key, left) = readSymbol str
        (value, left') = readSymbol left
    in (key, value, left')

readSymbol :: String -> (Char, String)
readSymbol ('1' : ':' : letter : rest) = (letter, rest)
readSymbol ('i' : num : 'e' : rest) = (num, rest)
readSymbol str = error ("Invalid message. Unparsed content: " ++ str)

--could use standart lookup function
match :: (Char -> Bool) -> [(Char, Char)] -> Char
match mch [] = error ("Match not found.")
match mch ((b,v) : rest) = 
    if 
        mch b
    then 
        v 
    else (match mch rest)




getV :: Action -> Char
getV (v0,_,_) = v0

getX :: Action -> Int
getX (_,v1,_) = v1

getY :: Action -> Int 
getY (_,_,v2) = v2





encode :: Board -> String
encode squares = printf "l%se" actions
    where actions = intercalate "" sqStrings
          sqStrings = map squareToString squares


squareToString :: Action -> String
squareToString (v, x, y) = printf format v x y
    where format = "d1:v1:%c1:xi%de1:yi%dee"