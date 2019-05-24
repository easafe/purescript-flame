module Examples.Effectful.Affjax.Main where

import Prelude

import Affjax as A
import Affjax.ResponseFormat as AR
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Flame (Html, World, (:>))
import Flame as F
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE

type Model = {
        url :: String,
        result :: Result
}

data Message = UpdateUrl String | Fetch | Fetched Result

data Result = NotFetched | Fetching | Ok String | Error String

derive instance eqResult :: Eq Result

init :: Model
init = {
        url: "https://httpbin.org/get",
        result: NotFetched
}

update :: World Model Message -> Model -> Message -> Aff Model
update _ model (UpdateUrl url) = pure $ model { url = url, result = NotFetched }
update _ model (Fetched result) = pure $ model { result = result }
update re model Fetch = do
        re.view $ model { result = Fetching }
        response <- A.get AR.string model.url
        pure $ case response.body of
                Left error -> model { result = Error $ A.printResponseFormatError error }
                Right ok -> model { result =  Ok ok }

view :: Model -> Html Message
view model = HE.main "main" [
        HE.input [HA.onInput UpdateUrl, HA.value model.url, HA.type' "text"],
        HE.button [HA.onClick Fetch, HA.disabled $ model.result == Fetching] "Fetch",
        case model.result of
                NotFetched ->
                        HE.div_ "Not Fetched..."
                Fetching ->
                        HE.div_ "Fetching..."
                Ok ok ->
                        HE.pre_ <<< HE.code_ $ "Ok: " <> ok
                Error error ->
                        HE.div_ $ "Error: " <> error
]

main :: Effect Unit
main = F.mount "main" {
        init: init :> Nothing,
        update,
        view,
        signals : []
}
