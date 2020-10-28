module Flame.Application.PreMount where

import Data.Argonaut.Core as DAC
import Data.Argonaut.Decode (JsonDecodeError)
import Data.Argonaut.Decode as DAD
import Data.Argonaut.Decode.Class (class GDecodeJson)
import Data.Argonaut.Decode.Generic.Rep (class DecodeRep)
import Data.Argonaut.Decode.Generic.Rep as DADEGR
import Data.Argonaut.Encode as DAE
import Data.Argonaut.Encode.Class (class GEncodeJson)
import Data.Argonaut.Encode.Generic.Rep (class EncodeRep)
import Data.Argonaut.Encode.Generic.Rep as DAEGR
import Data.Array ((:))
import Data.Array as DA
import Data.Bifunctor as DB
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.String.Regex as DSR
import Data.String.Regex.Flags (global)
import Data.String.Regex.Unsafe as DSRU
import Effect (Effect)
import Effect.Exception as EE
import Effect.Exception.Unsafe (unsafeThrow)
import Flame.Application.Internal.Dom as FAD
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Renderer.String as FRS
import Flame.Types (Html(..), PreApplication)
import Partial.Unsafe (unsafePartial)
import Prelude (bind, discard, otherwise, pure, ($), (<<<), (<>), (==))
import Prim.RowList (class RowToList)
import Web.DOM.ParentNode (QuerySelector(..))

foreign import injectState :: forall message. Html message -> Html message -> Html message

tagSerializedState :: String
tagSerializedState = "template-state"

idSerializedState :: String -> String
idSerializedState = ("pre-mount-" <> _)

attributeSerializedState :: String -> String
attributeSerializedState = ("__pre-mount-" <> _)

onlyLetters :: String -> String
onlyLetters = DSR.replace (DSRU.unsafeRegex "[^aA-zZ]" global) ""

selectorSerializedState :: String -> String
selectorSerializedState selector = tagSerializedState <> "#" <> idSerializedState selector <> "[" <> attributeSerializedState selector <> "=" <> selector <> "]"

class UnserializeModel m where
      unserializeModel :: String -> Either String m

instance recordUnserializeModel :: (GDecodeJson m list, RowToList m list) => UnserializeModel (Record m) where
      unserializeModel model = jsonStringError do
            json <- DAD.parseJson model
            DAD.decodeJson json
else
instance genericUnserializeModel :: (Generic m r, DecodeRep r) => UnserializeModel m where
      unserializeModel model = jsonStringError do
            json <- DAD.parseJson model
            DADEGR.genericDecodeJson json

jsonStringError :: forall a. Either JsonDecodeError a -> Either String a
jsonStringError = DB.lmap DAD.printJsonDecodeError

serializedState :: forall model. UnserializeModel model => String -> Effect model
serializedState selector = do
      maybeElement <- FAD.querySelector stateSelector
      case maybeElement of
            Just el -> do
                  contents <- FAD.textContent el
                  case unserializeModel contents of
                        Right model -> do
                              FAD.removeElement stateSelector
                              pure model
                        Left message -> EE.throw $ "Error resuming application mount: serialized state is invalid! " <> message
            Nothing -> EE.throw $ "Error resuming application mount: serialized state ("<> stateSelector <>") not found!"
      where stateSelector = selectorSerializedState $ onlyLetters selector

class SerializeModel m where
      serializeModel :: m -> String

instance encodeJsonSerializeModel :: (GEncodeJson m list, RowToList m list) => SerializeModel (Record m) where
      serializeModel = DAC.stringify <<< DAE.encodeJson
else
instance genericSerializeModel :: (Generic m r, EncodeRep r) => SerializeModel m where
      serializeModel = DAC.stringify <<< DAEGR.genericEncodeJson

preMount :: forall model message. SerializeModel model => QuerySelector -> PreApplication model message -> Effect String
preMount (QuerySelector selector) application = do
      let html = injectState state $ application.view application.init
      FRS.render html
      where sanitizedSelector = onlyLetters selector
            state = HE.createElement tagSerializedState [
                  HA.style { display: "none" },
                  HA.id $ idSerializedState sanitizedSelector,
                  HA.createAttribute (attributeSerializedState sanitizedSelector) sanitizedSelector
            ] $ serializeModel application.init