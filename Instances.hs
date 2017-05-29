module Instances where 

import qualified Data.ByteString.Char8 as B8
import qualified Data.UUID as UUID
import Database.Persist
import Database.Persist.Sql
import Data.Maybe
import Data.Either

-- Note we're taking advantage of
-- PostgreSQL understanding UUID values,
-- thus "PersistDbSpecific"
instance PersistField UUID.UUID where
  toPersistValue u = PersistDbSpecific ( B8.pack ( UUID.toString u))
  fromPersistValue (PersistDbSpecific t) =
    case UUID.fromString ( B8.unpack t) of
      Just x -> Right x
      Nothing -> Left "Invalid UUID"
  fromPersistValue _ = Left "Not PersistDBSpecific"


instance PersistFieldSql UUID.UUID where
  sqlType _ = SqlOther "uuid"
