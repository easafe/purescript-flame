module Flame.Serialization (class SerializeState, serialize, class UnserializeState, unserialize, unsafeUnserialize) where

import Data.Argonaut.Core as DAC
import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Decode as DAD
import Data.Argonaut.Decode.Class (class GDecodeJson)
import Data.Argonaut.Decode.Generic (class DecodeRep)
import Data.Argonaut.Decode.Generic as DADEG
import Data.Argonaut.Encode as DAE
import Data.Argonaut.Encode.Class (class GEncodeJson)
import Data.Argonaut.Encode.Generic (class EncodeRep)
import Data.Argonaut.Encode.Generic as DAEG
import Data.Bifunctor as DB
import Data.Either (Either(..))
import Data.Either as DE
import Data.Generic.Rep (class Generic)
import Partial as Partial
import Partial.Unsafe as PU
import Prelude (bind, show, (<<<), ($))
import Prim.RowList (class RowToList)

class UnserializeState m where
      unserialize :: String -> Either String m

instance recordUnserializeState :: (GDecodeJson m list, RowToList m list) => UnserializeState (Record m) where
      unserialize model = jsonStringError do
            json <- DAD.parseJson model
            DAD.decodeJson json
else
instance genericUnserializeState :: (Generic m r, DecodeRep r) => UnserializeState m where
      unserialize model = jsonStringError do
            json <- DAD.parseJson model
            DADEG.genericDecodeJson json

class SerializeState m where
      serialize :: m -> String

instance encodeJsonSerializeState :: (GEncodeJson m list, RowToList m list) => SerializeState (Record m) where
      serialize = DAC.stringify <<< DAE.encodeJson
else
instance genericSerializeState :: (Generic m r, EncodeRep r) => SerializeState m where
      serialize = DAC.stringify <<< DAEG.genericEncodeJson

jsonStringError :: forall a. Either JsonDecodeError a -> Either String a
jsonStringError = DB.lmap DAD.printJsonDecodeError

unsafeUnserialize :: forall m. UnserializeState m => String -> m
unsafeUnserialize str = PU.unsafePartial case unserialize str of 
      Right m -> m 
      Left err -> Partial.crashWith $ show err