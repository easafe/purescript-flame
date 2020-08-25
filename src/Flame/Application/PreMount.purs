module Flame.Application.PreMount where

import Control.Monad.Except as CME
import Data.Argonaut.Core as DAC
import Data.Argonaut.Decode.Error as DADEE
import Data.Argonaut.Decode.Generic.Rep (class DecodeRep)
import Data.Argonaut.Decode.Generic.Rep as DADEGR
import Data.Argonaut.Encode.Generic.Rep (class EncodeRep)
import Data.Argonaut.Encode.Generic.Rep as DAEGR
import Data.Argonaut.Parser as DAP
import Data.Array ((:))
import Data.Array as DA
import Data.Bifunctor (lmap)
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
import Prelude (bind, discard, otherwise, pure, show, ($), (<<<), (<>), (==))
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

serializedState :: forall model m. Generic model m => DecodeRep m => String -> Effect model
serializedState selector = do
        let sanitizedSelector = onlyLetters selector
        maybeElement <- FAD.querySelector $ selectorSerializedState sanitizedSelector
        case maybeElement of
                Just el -> do
                        contents <- FAD.textContent el
                        case CME.runExcept <<< CME.except $ decoding contents of
                                Right model -> do
                                        FAD.removeElement $ selectorSerializedState sanitizedSelector
                                        pure model
                                Left message -> EE.throw $ "Error resuming application mount: serialized state is invalid! " <> message
                Nothing -> EE.throw $ "Error resuming application mount: serialized state not found!"
        where   decoding contents = do
                        json <- DAP.jsonParser contents
                        lmap DADEE.printJsonDecodeError (DADEGR.genericDecodeJson json)

preMount :: forall model m message. Generic model m => EncodeRep m => QuerySelector -> PreApplication model message -> Effect String
preMount (QuerySelector selector) application = do
        markup <- injectState $ application.view application.init
        rendered <- FRS.render markup
        pure rendered
        where   sanitizedSelector = onlyLetters selector

                state = HE.createElement tagSerializedState [
                        HA.style { display: "none" },
                        HA.id $ idSerializedState sanitizedSelector,
                        HA.createAttribute (attributeSerializedState sanitizedSelector) sanitizedSelector
                ] <<< DAC.stringify $ DAEGR.genericEncodeJson application.init

                isBody (Node tag _ _) = tag == "body"
                isBody _ = false

                inject (Node tag nodeData children) = Node tag nodeData (state : children)
                inject node2 = node2

                injectState (Text _) = EE.throw "Error pre mounting application: cannot mount on text node!"
                injectState node@(Node tag nodeData children)
                        | tag == "html" =
                                pure <<< Node tag nodeData $
                                        case DA.findIndex isBody children of
                                                Nothing -> state : children
                                                Just index -> unsafePartial (DM.fromJust $ DA.modifyAt index inject children)
                        | otherwise = pure $ inject node
