
{-# LANGUAGE DeriveAnyClass #-}
{-# LANGUAGE DeriveGeneric #-}
module Task.EventType where
import ClassyPrelude.Yesod

import Data.Aeson
import Database.Persist.TH

data EventType = Create | Update deriving (Generic,Show, Read, Eq, ToJSON, FromJSON )

derivePersistField "EventType"

