{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}
module Emitter where

import           Data.Aeson
import qualified Data.ByteString.Char8 as S8
import qualified Data.Yaml             as Yaml
import           Network.HTTP.Simple
import           GHC.Generics

data Message = Message { msg :: String } deriving (Generic)

instance FromJSON Message
instance ToJSON Message

message :: Message
message = Message { msg = "Hello from Haskell" }

emit :: IO ()
emit = do
    let request = addRequestHeader "Host" "example.com"
                . addRequestHeader "Content-Type" "application/cloudevents+json"
                . addRequestHeader "ce-specversion" "1.0"
                . addRequestHeader "ce-source" "/foo"
                . addRequestHeader "ce-id" "42"
                . addRequestHeader "ce-time" "2020-04-10:T01:00:05+00:00" 
                . setRequestBodyJSON message    
    response <- httpLBS (request "POST http://localhost:8080")

    putStrLn $ "The status code was: " ++
               show (getResponseStatusCode response)