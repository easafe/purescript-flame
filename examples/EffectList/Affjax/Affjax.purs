module Examples.EffectList.Affjax.Main where

import Prelude

import Affjax as A
import Affjax.ResponseFormat as AR
import Data.Either (Either(..))
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple)
import Effect (Effect)
import Effect.Aff (Aff, Milliseconds(..), ListUpdate)
import Effect.Aff as AF
import Flame (QuerySelector(..), Html, (:>))
import Flame.Application.EffectList as FE
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

update :: ListUpdate Model Message
update model =
        case _ of
                UpdateUrl url -> FE.noMessages $ model { url = url, result = NotFetched }
                Fetch -> model { result = Fetching } :> [ do
                                response <- A.get AR.string model.url
                                AF.delay $ Milliseconds 1000.0
                                pure <<< Just <<< Fetched $ case response.body of
                                        Left error ->  Error $ A.printResponseFormatError error
                                        Right ok -> Ok ok
                        ]
                Fetched result -> FE.noMessages $ model { result = result }

view :: Model -> Html Message
view { url, result } = HE.main "main" [
        HE.input [HA.onInput UpdateUrl, HA.value url, HA.type' "text"],
        HE.button [HA.onClick Fetch, HA.disabled $ result == Fetching] "Fetch",
        case result of
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
main = FE.mount_ (QuerySelector "main") {
        init: FE.noMessages init,
        update,
        view
}
