{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad.IO.Class
import Data.Maybe
import Data.Text.Lazy     (Text)
import Data.Text.Lazy
import System.Environment (lookupEnv)
import Web.Scotty         (ActionM, ScottyM, scotty)
import Web.Scotty.Trans
import Network.Wai.Middleware.RequestLogger
import Network.HTTP.Types.Status
import Emitter (emit)

main :: IO ()
main = do
  putStrLn "Cloud Events Echo Service started"
  pStr <- fromMaybe "8080" <$> lookupEnv "PORT"
  let p = read pStr :: Int
  scotty p route

route :: ScottyM()
route = do 
    middleware logStdoutDev
    post "/" $ do
        hs <- headers
        liftIO (putStrLn $ show hs)
        --  code <- param "data" :: ActionM String
        --  liftIO $ putStrLn code
        liftIO $ emit
        status status204
