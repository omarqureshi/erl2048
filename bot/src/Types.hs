module Types (Game(..), Action(..)) where

import Control.Applicative ((<$>), (<*>), empty)

import qualified Data.Text as Text
import qualified Data.Aeson as Aeson

data Action = Action {
  action :: String,
  value :: Maybe String
}deriving (Show)
data Cell = Cell { cost :: Integer, mergedFrom :: Maybe [Cell], previousPosition :: Maybe PreviousPosition} deriving (Show)
data PreviousPosition = PreviousPosition { x :: Integer, y :: Integer} deriving (Show)
{-
data Score = Score { name :: String, score :: Integer } deriving (Show)
data User = User {
  id       :: Maybe Integer,
  username :: Maybe String
} deriving (Show)
-}
data Game = Game {
--  player      :: User,
--  currScore   :: Integer,
--  scores      :: [Score],
--  won         :: Bool,
--  over        :: Bool,
--  keepPlaying :: Bool,
  grid        :: [[Maybe Cell]]
} deriving (Show)

instance Aeson.ToJSON Action where
  toJSON (Action actionV valueV) = Aeson.object [
	action Aeson..= actionV,
	value Aeson..= valueV ] where
	action = Text.pack("action")
	value = Text.pack("value")
instance Aeson.FromJSON Game where
	parseJSON (Aeson.Object v) = Game <$> 
--                                     v Aeson..: Text.pack("user") <*>
--                                     v Aeson..: Text.pack("score") <*>
--                                     v Aeson..: Text.pack("scores") <*>
--                                     v Aeson..: Text.pack("won") <*>
--                                     v Aeson..: Text.pack("over") <*>
--                                     v Aeson..: Text.pack("keepPlaying") <*>
                                     v Aeson..: Text.pack("grid")
	parseJSON _ = empty
instance Aeson.FromJSON Cell where
	parseJSON (Aeson.Object v) = Cell <$>
                                     v Aeson..: Text.pack("value") <*>
                                     v Aeson..: Text.pack("mergedFrom") <*>
                                     v Aeson..: Text.pack("previousPosition")
	parseJSON _ = empty
{-
instance Aeson.FromJSON User where
	parseJSON (Aeson.Object v) = User <$>
                                     v Aeson..: Text.pack("id") <*>
                                     v Aeson..: Text.pack("name")
	parseJSON _ = empty
instance Aeson.FromJSON Score where
	parseJSON (Aeson.Object v) = Score <$>
                                     v Aeson..: Text.pack("name") <*>
                                     v Aeson..: Text.pack("score")
	parseJSON _ = empty
-}
instance Aeson.FromJSON PreviousPosition where
	parseJSON (Aeson.Object v) = PreviousPosition <$>
                                     v Aeson..: Text.pack("x") <*>
                                     v Aeson..: Text.pack("y")
	parseJSON _ = empty
