module Arbitrator where

import Parser
import Data.List
import Data.List.Utils

--sortByX (_, b1, _) (_, b2, _) = compare b1 b2
--sortByY (_, _, c1) (_, _, c2) = compare c1 c2

winner :: String -> Maybe Char
winner [] = Nothing
winner message = if (length winners == 1) then Just (winners !! 0) else Nothing
    where
        mp = decode message

        --xArrays = groupBy (\x y->(getX x) == (getX y)) (sortBy sortByX mp)
        --yArrays = groupBy (\x y->(getY x) == (getY y)) (sortBy sortByY mp)
        xArray1 = mp >>= (\e -> if (getX e) == 0 then [e] else [])
        xArray2 = mp >>= (\e -> if (getX e) == 1 then [e] else [])
        xArray3 = mp >>= (\e -> if (getX e) == 2 then [e] else [])
        yArray1 = mp >>= (\e -> if (getY e) == 0 then [e] else [])
        yArray2 = mp >>= (\e -> if (getY e) == 1 then [e] else [])
        yArray3 = mp >>= (\e -> if (getY e) == 2 then [e] else [])
        xArrays = [xArray1, xArray2, xArray3]
        yArrays = [yArray1, yArray2, yArray3]

        diagon1Array = mp >>= (\e -> if ((getX e) == (getY e)) then [e] else [])
        diagon2Array = mp >>= (\e -> if (getX e == (3-(getY e))) then [e] else [])

        allArrays = merge xArrays $ merge yArrays [diagon1Array, diagon2Array]

        winners = allArrays >>= (\e -> if (length e == 3 && isWinner e) then [(getV (e !! 0))] else [])


isWinner :: Board -> Bool
isWinner mp = if (length grouped == 1) then True else False
    where
        grouped = groupBy (\a b->(getV a) == (getV b)) mp