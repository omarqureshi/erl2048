module Main ( main ) where

import qualified Data.Text as Text
import qualified Data.Aeson as Aeson
import qualified Network.WebSockets as WS
import qualified Graphics.QML as QML
import qualified Control.Concurrent as Concurrent

import qualified Types as T
import qualified Visualizer as V

main :: IO ()
main = WS.runClient "127.0.0.1" 8081 "/websocket" app

app :: WS.ClientApp ()
app conn = do
  game <- V.init
  
  WS.sendTextData conn (Aeson.encode $ T.Action "start" Nothing)
  loop game conn
  WS.sendClose conn ( Text.pack "Bye!" )
  print "Exited"

loop :: QML.ObjRef V.QMLGame -> WS.Connection -> IO ()
loop game conn = do
  res <- WS.receiveData conn
  let newGame = Aeson.decode res :: Maybe T.Game
  let act = decision (newGame)
  V.update game newGame

  case act of
    Nothing -> return ()
    Just act -> do
      WS.sendTextData conn (Aeson.encode act)
      Concurrent.threadDelay 2000000
      loop game conn

decision :: Maybe T.Game -> Maybe T.Action
decision Nothing = Nothing
decision (Just (T.Game _ _ _ _ _ _ _)) =
  (Just (T.Action "move" (Just "left")))
