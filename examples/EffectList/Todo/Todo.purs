module Examples.EffectList.Todo.Main where

import Prelude

import Data.Argonaut.Core as DAC
import Data.Argonaut.Encode as DAE
import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Maybe as DM
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Flame (Html)
import Flame.Application.EffectList ((:>))
import Flame.Application.EffectList as FAE
import Flame.HTML.Attribute (Key)
import Flame.HTML.Attribute as HA
import Flame.HTML.Element as HE
import Web.HTML as WH
import Web.HTML.Window as WHW
import Web.Storage.Storage as WSS

type Index = Int

type Model = {
        input :: String,
        todos :: Array String,
        editing :: Index
}

todoLocalStorageKey :: String
todoLocalStorageKey = "todos"

notEditing :: Index
notEditing = -1

init :: Model
init = {
        input: "",
        todos: [],
        editing: notEditing
}

data Message = Add (Tuple Key String) | Edit Index | Update (Tuple Key String) | Remove Index

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model message =
        let newModel =
                case message of
                        Edit index -> model { editing = index }
                        Remove index -> model { todos = DM.fromMaybe model.todos $ DA.deleteAt index model.todos }
                        message' -> saveOnEnter model message'
         in newModel :> [ liftEffect $ serialize newModel ]

        where   saveOnEnter updatedModel (Add (Tuple "Enter" todo)) = updatedModel {
                        todos = DA.snoc updatedModel.todos todo,
                        input = ""
                }
                saveOnEnter updatedModel (Add (Tuple _ todo)) = updatedModel { input = todo }
                saveOnEnter updatedModel (Update (Tuple "Enter" todo)) = updatedModel {
                        todos = DM.fromMaybe updatedModel.todos $ DA.updateAt updatedModel.editing todo updatedModel.todos,
                        editing = notEditing
                }
                saveOnEnter updatedModel _ = updatedModel

                serialize updatedModel = do
                        window <- WH.window
	                localStorage <- WHW.localStorage window
	                WSS.setItem todoLocalStorageKey (DAC.stringify $ DAE.encodeJson updatedModel.todos) localStorage
                        pure Nothing

view :: Model -> Html Message
view model = HE.main "main" [
        HE.h1_ "todos",
        HE.input [HA.type' "text", HA.placeholder "What needs to be done?", HA.value model.input, HA.onKeyup Add],
        HE.div_ $ DA.mapWithIndex todoItem model.todos,
        HE.text "Double click to edit a todo"
]
        where todoItem index todo = HE.div_ [
                if index == model.editing then
                        HE.input [HA.onKeyup Update, HA.value todo]
                 else
                        HE.span [HA.onDblclick (Edit index)] todo,
                HE.button [HA.onClick $ Remove index] "remove"
        ]

main :: Effect Unit
main = FAE.mount "main" {
        init: init :> [],
        update,
        view,
        signals:[]
}
