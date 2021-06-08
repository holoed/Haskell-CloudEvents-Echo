{-# LANGUAGE OverloadedStrings #-}
module Main where

import Control.Monad.IO.Class ( MonadIO(liftIO) )
import Data.Maybe ( fromMaybe )
import Data.Text.Lazy ()
import System.Environment (lookupEnv)
import Web.Scotty         (ActionM, ScottyM, scotty)
import Web.Scotty.Trans
    ( jsonData, headers, status, post, middleware )
import Network.Wai.Middleware.RequestLogger ( logStdoutDev )
import Network.HTTP.Types.Status ( status204 )
import Data.Aeson (Object)
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
        liftIO (print hs)
        value <- jsonData :: ActionM Object
        --  code <- param "data" :: ActionM String
        liftIO $ print value
        status status204
