{-# LANGUAGE FlexibleInstances #-}
module Model where
import ClassyPrelude.Yesod
import Database.Persist.Quasi
import Data.Aeson


import qualified Data.ByteString.Char8 as B8
import Data.UUID (UUID)
import qualified Data.UUID as UUID
import Database.Persist
import Database.Persist.Sql
import Data.Maybe
import Data.Either
import Data.Text as T
import Task.EventType
-- Note we're taking advantage of
-- PostgreSQL understanding UUID values,
-- thus "PersistDbSpecific"
instance PersistField UUID where
  toPersistValue u = PersistDbSpecific ( B8.pack (UUID.toString u))
  fromPersistValue (PersistDbSpecific t) =
    case UUID.fromString ( B8.unpack t) of
      Just x -> Right x
      Nothing -> Left "Invalid UUID"
  fromPersistValue _ = Left "Not PersistDBSpecific"


instance PersistFieldSql UUID where
  sqlType _ = SqlOther "uuid"


instance ToJSON UUID where
  toJSON u =  String $ UUID.toText u



instance FromJSON UUID where
  parseJSON = withText "string" parse_uuid
    where
      parse_uuid x = case (UUID.fromText x) of
        Just u -> return u
        Nothing -> return UUID.nil --default is empty, NOT error

instance PathPiece UUID where
  toPathPiece u = UUID.toText u
  fromPathPiece mbu = UUID.fromText mbu

-- You can define all of your database entities in the entities file.
-- You can find more information on persistent and how to declare entities
-- at:
-- http://www.yesodweb.com/book/persistent/

share [mkPersist sqlSettings, mkMigrate "migrateAll"] [persistLowerCase|
Task json
  task_id UUID sqltype=uuid default=uuid_generate_v4()
  Primary task_id
  --task_start UTCTime default=CURRENT_TIME

TaskEvent json
  event_id UUID sqltype=uuid default=uuid_generate_v4()
  Primary event_id
  task_id UUID sqltype=uuid default=uuid_generate_v4()
  Foreign Task task_id
  task_name Text
  event_type EventType
  state Int
  short_description Text
  description Text
  justification Text

TaskComment json
  event_id UUID sqltype=uuid default=uuid_generate_v4()
  event_type EventType
  task_id UUID sqltype=uuid default=uuid_generate_v4()
  comment Text   

|]

{-

-}
