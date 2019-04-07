module Examples.Counter where

import Prelude

import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html)
import Flame as F
import Flame.Html.Element as HE
import Flame.Html.Event as HV

type Model = Int

data Message = Increment | Decrement

init :: Model
init = 0

update :: Model -> Message -> Aff Model
update model = pure <<< case _ of
        Increment -> model + 1
        Decrement -> model - 1

view :: Model -> Html Message
view model = HE.main "main" [
        HE.button [HV.onClick Decrement] "-",
        HE.text $ show model,
        HE.button [HV.onClick Increment] "+"
]

main :: Effect Unit
main = F.mount "main" {
                init,
                update,
                view,
                inputs: []
        }
