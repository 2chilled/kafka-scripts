{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Main where

import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import qualified Data.Attoparsec.Text as P
import Data.Monoid ((<>))

main :: IO ()
main = TIO.getContents >>= main'

main' :: T.Text -> IO ()
main' text = do
  let parseResult = P.parseOnly lagsParser text
  (parseFailMsg `either` parseSuccessMsg) parseResult
  where parseFailMsg = putStrLn . show
        parseSuccessMsg lags = TIO.putStrLn text *> (putStrLn $ "Total lag: " <> (show . sum $ lags))

{-|Parses lags out of a text like this:
GROUP                          TOPIC                          PARTITION  CURRENT-OFFSET  LOG-END-OFFSET  LAG             OWNER
myGroup      topic                           8          57004           57004           0               consumer-1_/127.0.0.1
myGroup      topic                           9          55462           55462           0               consumer-1_/127.0.0.1
myGroup      topic                           10         170706          170706          0               consumer-1_/127.0.0.1
myGroup      topic                           11         96874           96874           0               consumer-1_/127.0.0.1
myGroup      topic                           12         155318          155318          0               consumer-1_/127.0.0.1
myGroup      topic                           13         81836           81836           0               consumer-1_/127.0.0.1
myGroup      topic                           14         39377           39377           0               consumer-1_/127.0.0.1
myGroup      topic                           0          117273          117273          6               consumer-1_/127.0.0.1
myGroup      topic                           1          66487           66487           7               consumer-1_/127.0.0.1
myGroup      topic                           2          99097           99097           8               consumer-1_/127.0.0.1
myGroup      topic                           3          133941          133941          7000            consumer-1_/127.0.0.1
myGroup      topic                           4          52608           52608           0               consumer-1_/127.0.0.1
myGroup      topic                           5          158511          158511          0               consumer-1_/127.0.0.1
myGroup      topic                           6          68726           68726           0               consumer-1_/127.0.0.1
myGroup      topic                           7          68909           68909           0               consumer-1_/127.0.0.1
-}
lagsParser :: P.Parser [Lag]
lagsParser = skipFirstLine *> P.many' lagParser
  where skipFirstLine = P.skipWhile (not . P.isEndOfLine)

lagParser :: P.Parser Lag
lagParser = skipToLag *> P.decimal <* P.skipWhile (not . P.isEndOfLine)
  where skipToLag = P.count 5 (skipString >> skipWhite)
        skipString = P.skipWhile (not . P.isHorizontalSpace)
        skipWhite = P.skipSpace

type Lag = Int


