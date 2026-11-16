module Flame.Serialization (class Serializable, serialize, unserialize, unsafeUnserialize) where

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
import Data.Generic.Rep (class Generic)
import Partial as P
import Partial.Unsafe as PU
import Prelude (bind, show, (<<<), ($))
import Prim.RowList (class RowToList)

-- | Models that can be serialized to a string (for server side rendering and custom events) and read back from it
-- |
-- | Records and types with a `Generic` instance are supported out of the box
class Serializable m where
      serialize ∷ m → String
      unserialize ∷ String → Either String m

instance (GEncodeJson m list, GDecodeJson m list, RowToList m list) ⇒ Serializable (Record m) where
      serialize = DAC.stringify <<< DAE.encodeJson
      unserialize model = jsonStringError do
            json ← DAD.parseJson model
            DAD.decodeJson json
else instance (Generic m r, EncodeRep r, DecodeRep r) ⇒ Serializable m where
      serialize = DAC.stringify <<< DAEG.genericEncodeJson
      unserialize model = jsonStringError do
            json ← DAD.parseJson model
            DADEG.genericDecodeJson json

-- | Renders decoding errors as plain strings
jsonStringError ∷ ∀ a. Either JsonDecodeError a → Either String a
jsonStringError = DB.lmap DAD.printJsonDecodeError

-- | Unserializes the given string, crashing if it is not valid
unsafeUnserialize ∷ ∀ m. Serializable m ⇒ String → m
unsafeUnserialize str = PU.unsafePartial case unserialize str of
      Right m → m
      Left err → P.crashWith $ show err