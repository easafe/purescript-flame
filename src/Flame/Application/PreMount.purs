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
import Flame.Application.DOM as FAD
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Renderer.String as FRS
import Flame.Types (Html(..), PreApplication)
import Partial.Unsafe (unsafePartial)
import Prelude (bind, discard, pure, ($), (<<<), (<>), (==))
import Prim.RowList (class RowToList)
import Web.DOM.ParentNode (QuerySelector(..))

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
        let sanitizedSelector = onlyLetters selector
        maybeElement <- FAD.querySelector $ selectorSerializedState sanitizedSelector
        case maybeElement of
                Just el -> do
                        contents <- FAD.textContent el
                        case unserializeModel contents of
                                Right model -> do
                                        FAD.removeElement $ selectorSerializedState sanitizedSelector
                                        pure model
                                Left message -> EE.throw $ "Error resuming application mount: serialized state is invalid! " <> message
                Nothing -> EE.throw $ "Error resuming application mount: serialized state not found!"

class SerializeModel m where
        serializeModel :: m -> String

instance encodeJsonSerializeModel :: (GEncodeJson m list, RowToList m list) => SerializeModel (Record m) where
        serializeModel = DAC.stringify <<< DAE.encodeJson
else
instance genericSerializeModel :: (Generic m r, EncodeRep r) => SerializeModel m where
        serializeModel = DAC.stringify <<< DAEGR.genericEncodeJson

preMount :: forall model message. SerializeModel model => QuerySelector -> PreApplication model message -> Effect String
preMount (QuerySelector selector) application = do
        markup <- injectState $ application.view application.init
        rendered <- FRS.render markup
        pure rendered
        where   sanitizedSelector = onlyLetters selector

                state = HE.createElement tagSerializedState [
                        HA.style { display: "none" },
                        HA.id $ idSerializedState sanitizedSelector,
                        HA.createAttribute (attributeSerializedState sanitizedSelector) sanitizedSelector
                ] $ serializeModel application.init

                isBody = case _ of
                        Node tag _ _ -> tag == "body"
                        _ -> false

                inject = case _ of
                        Node tag nodeData children -> Node tag nodeData (state : children)
                        node2 -> node2

                injectState = case _ of
                        node@(Node tag nodeData children) ->
                                if tag == "html" then
                                        pure <<< Node tag nodeData $
                                                case DA.findIndex isBody children of
                                                        Nothing -> state : children
                                                        Just index -> unsafePartial (DM.fromJust $ DA.modifyAt index inject children)
                                 else
                                        pure $ inject node
                        _ -> EE.throw "Error pre mounting application: cannot mount on text node or thunk!"