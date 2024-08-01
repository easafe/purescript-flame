-- | Run a Flame application as a react native wrapper
module Flame.Application.Native
      ( NativeUpdate
      , Application
      , noMessages
      , mount
      ) where

import Data.Either (Either(..))
import Data.Foldable as DF
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Aff as EA
import Effect.Console as EC
import Effect.Exception as EE
import Effect.Ref as ER
import Flame.Internal.Equality as FIE
import Flame.Renderer.Internal.Native (NativeApp)
import Flame.Renderer.Internal.Native as FAN
import Flame.Subscription.Internal.Listener as FSIL
import Flame.Types (App, AppId(..), ApplicationId, (:>))
import Prelude (class Show, Unit, bind, discard, map, pure, show, unit, when, ($), (<>))
import Unsafe.Coerce as UC

type NativeUpdate model message = model → message → Tuple model (Array (Aff (Maybe message)))

-- | `Application` contains
-- | * `init` – the initial model and a list of messages to invoke `update` with
-- | * `view` – a function to update your markup
-- | * `update` – a function to update your model
-- | * `subscribe` – list of external events
type Application model message = App model message
      ( init ∷ Tuple model (Array (Aff (Maybe message)))
      , update ∷ NativeUpdate model message
      )

noMessages ∷ ∀ model message. model → Tuple model (Array (Aff (Maybe message)))
noMessages model = model :> []

-- | Mount a Flame application that can be fed arbitrary external messages
mount ∷ ∀ model message.  String → Application model message → Effect Unit
mount name application = run name application

run ∷ ∀ model message. String → Application model message → Effect Unit
run name { update, view, init: Tuple initialModel initialAffs, subscribe } = do
      modelState ← ER.new initialModel
      nativeAppState ← ER.new (UC.unsafeCoerce 21 ∷ NativeApp)

      let
            runUpdate message = do
                  currentModel ← ER.read modelState
                  let Tuple model affs = update currentModel message
                  render model
                  runMessages affs

            render model = do
                  nApp ← ER.read nativeAppState
                  FAN.resume nApp view model
                  ER.write model modelState

            runMessages affs =
                  DF.for_ affs $ EA.runAff_
                        ( case _ of
                                Left error → EC.log $ EE.message error
                                Right (Just message) → runUpdate message
                                _ → pure unit
                        )

      nativeApp ← FAN.start runUpdate name (view initialModel) initialModel
      ER.write nativeApp nativeAppState

      runMessages initialAffs

--subscriptions are used for external events
--   case appId of
--         Nothing → pure unit
--         Just id → FSIL.createMessageListener id runUpdate
--   DF.traverse_ (FSIL.createSubscription runUpdate) subscribe