{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Emitter where

import Data.Aeson ( FromJSON, ToJSON )
import qualified Data.ByteString.Char8 as S8
import qualified Data.Yaml             as Yaml
import Network.HTTP.Simple
    ( addRequestHeader,
      getResponseStatusCode,
      httpLBS,
      setRequestBodyJSON )
import GHC.Generics ( Generic )
import System.Random ( getStdGen, Random(random) )
import Data.UUID ( toString )

newtype Message = Message { msg :: String } deriving (Generic)

instance FromJSON Message
instance ToJSON Message

message :: Message
message = Message { msg = "Hello from Haskell" }

emit :: IO ()
emit = do
    g <- getStdGen 
    let (u1, _) = random g
    let request = addRequestHeader "Host" "example.com"
                . addRequestHeader "Content-Type" "application/cloudevents+json"
                . addRequestHeader "ce-specversion" "1.0"
                . addRequestHeader "ce-source" "/foo"
                . addRequestHeader "ce-id" (S8.pack (toString u1))
                . addRequestHeader "ce-time" "2020-04-10:T01:00:05+00:00" 
                . setRequestBodyJSON message    
    response <- httpLBS (request "POST http://localhost:8080")

    putStrLn $ "The status code was: " ++
               show (getResponseStatusCode response)