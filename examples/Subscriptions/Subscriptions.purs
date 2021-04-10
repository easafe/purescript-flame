module Examples.EffectList.Subscriptions.Main where


import Prelude

import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random as ER
import Effect.Timer as ET
import Flame (AppId(..), Html, QuerySelector(..), Subscription, (:>))
import Flame as F
import Flame.Html.Element as HE
import Flame.Subscription as FS
import Flame.Subscription.Document as FSD

type Model = {
      roll :: Maybe Int,
      from :: String
}

init :: Model
init = {
      roll : Nothing,
      from : ""
}

data Message =
      IntervalRoll |
      ClickRoll |
      Update String Int

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
      IntervalRoll -> model :> next "interval"
      ClickRoll -> model :> next "click"
      Update from int -> {
            roll : Just int,
            from
      } :> []
      where next from = [ Just <<< Update from <$> liftEffect (ER.randomInt 1 6) ]

view :: Model -> Html Message
view { roll, from } = HE.text $ case roll of
      Nothing -> "No rolls!"
      Just r -> "Roll from " <> from <> ": " <> show r

subscribe :: Array (Subscription Message)
subscribe = [
      FSD.onClick ClickRoll -- `document` click event
]

main :: Effect Unit
main = do
      let id = AppId "dice-rolling"
      F.mount (QuerySelector "body") id {
            init: init :> [],
            subscribe,
            update,
            view
      }
      -- roll dice every 5 seconds
      void $ ET.setInterval 5000 (FS.send id IntervalRoll)
