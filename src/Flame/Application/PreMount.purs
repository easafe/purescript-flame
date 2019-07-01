module Flame.Application.PreMount where

import Flame.Types
import Prelude

import Control.Monad.Except as CME
import Control.Monad.Trans.Class (lift)
import Data.Argonaut.Core as DAC
import Data.Argonaut.Decode.Generic.Rep (class DecodeRep)
import Data.Argonaut.Decode.Generic.Rep as DADEGR
import Data.Argonaut.Encode.Generic.Rep (class EncodeRep)
import Data.Argonaut.Encode.Generic.Rep as DAEGR
import Data.Argonaut.Parser as DAP
import Data.Array ((:))
import Data.Array as DA
import Data.Either (Either(..))
import Data.Generic.Rep (class Generic)
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Effect (Effect)
import Effect.Exception as EE
import Flame.Application.DOM as FAD
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Flame.Renderer.String as FRS
import Partial.Unsafe (unsafePartial)

tagSerializedState :: String
tagSerializedState = "template-state"

idSerializedState :: String -> String
idSerializedState = ("pre-mount-" <> _)

attributeSerializedState :: String -> String
attributeSerializedState = ("__pre-mount-" <> _)

selectorSerializedState :: String -> String
selectorSerializedState selector = tagSerializedState <> "#" <> idSerializedState selector <> "[" <> attributeSerializedState selector <> "=" <> selector <> "]"

serializedState :: forall model m. Generic model m => DecodeRep m => String -> Effect model
serializedState selector = do
        maybeElement <- FAD.querySelector $ selectorSerializedState selector
        case maybeElement of
                Just el -> do
                        contents <- FAD.textContent el
                        case CME.runExcept <<< CME.except $ decoding contents of
                                Right model -> do
                                        FAD.removeElement $ selectorSerializedState selector
                                        pure model
                                Left message -> EE.throw $ "Error resuming application mount: serialized state is invalid! " <> message
                Nothing -> EE.throw $ "Error resuming application mount: serialized state not found!"
        where   decoding contents = do
                        json <- DAP.jsonParser contents
                        DADEGR.genericDecodeJson json

preMount :: forall model m message. Generic model m => EncodeRep m => String -> PreApplication model message -> Effect String
preMount selector application = do
        markup <- injectState $ application.view application.init
        rendered <- FRS.render markup
        pure rendered
        where   state = HE.createElement tagSerializedState [ HA.style { display: "none"}, HA.id $ idSerializedState selector, HA.createAttribute (attributeSerializedState selector) selector] <<< DAC.stringify $ DAEGR.genericEncodeJson application.init

                isBody (Node tag _ _) = tag == "body"
                isBody _ = false

                inject (Node tag nodeData children) = Node tag nodeData (state : children)
                inject node = node

                injectState (Text _) = EE.throw "Error pre mounting application: cannot mount on text node!"
                injectState node@(Node tag nodeData children)
                        | tag == "html" =
                                pure <<< Node tag nodeData $
                                        case DA.findIndex isBody children of
                                                Nothing -> state : children
                                                Just index -> unsafePartial (DM.fromJust $ DA.modifyAt index inject children)
                        | otherwise = pure $ inject node