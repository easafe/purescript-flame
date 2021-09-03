module Test.Functor.Basic where

import Prelude

import Data.Array ((!!))
import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Effect (Effect)
import Flame (QuerySelector(..), Html)
import Flame.Application.NoEffects as FAN
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE

type Model = Array NestedModel

data Message = Add | Remove Int | CounterMessage Int NestedMessage

init :: Model
init = []

update :: Model -> Message -> Model
update model = case _ of
      Add -> DA.snoc model nestedInit
      Remove index -> DM.fromMaybe model $ DA.deleteAt index model
      CounterMessage index message ->
            case model !! index of
                  Nothing -> model
                  Just model' -> DM.fromMaybe model $ DA.updateAt index (nestedUpdate model' message) model

view :: Model -> Html Message
view model = HE.main "main" [
      HE.button [HA.id "add-button", HA.onClick Add] "Add",
      HE.div_ $ DA.mapWithIndex viewCounter model
]
      where   viewCounter index model' = HE.div [HA.style { display: "flex" }] [
                  CounterMessage index <$> nestedView index model',
                  HE.button [HA.onClick $ Remove index] "Remove"
            ]


-- | The model represents the state of the app
type NestedModel = Int

-- | This datatype is used to signal events to `update`
data NestedMessage = Increment | Decrement

nestedInit :: NestedModel
nestedInit = 0

nestedUpdate :: NestedModel -> NestedMessage -> NestedModel
nestedUpdate model = case _ of
      Increment -> model + 1
      Decrement -> model - 1

-- | `view` updates the app markup whenever the model is updated
nestedView :: Int -> NestedModel -> Html NestedMessage
nestedView index model = HE.main ("main-" <> show index) [
      HE.button [HA.id ("decrement-button-" <> show index), HA.onClick Decrement] "-",
      HE.span ("text-output-" <> show index) $ show model,
      HE.button [HA.id ("increment-button-" <> show index), HA.onClick Increment] "+"
]

mount :: Effect Unit
mount = FAN.mount_ (QuerySelector "#mount-point") {
      init,
      subscribe: [],
      update,
      view
}
