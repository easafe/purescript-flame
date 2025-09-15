module Main where

import Data.Array ((!!))
import Data.Array as DA
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Uncurried (EffectFn2)
import Effect.Uncurried as EU
import Flame (Update)
import Flame as F
import Flame.Html.Attribute as HA
import Flame.Html.Element as HE
import Flame.Types (Html, NodeData)
import Prelude (Unit, bind, map, mod, pure, show, (+), (/=), (<>), (==), otherwise)
import Web.DOM.ParentNode (QuerySelector(..))

data Message
      = Create Int
      | DisplayCreated (Array Row)
      | AppendOneThousand
      | DisplayAppended (Array Row)
      | UpdateEveryTenth
      | Clear
      | Swap
      | Remove Int
      | Select Int

type Model =
      { rows ∷ Array Row
      , lastID ∷ Int
      }

type Row =
      { id ∷ Int
      , label ∷ String
      , selected ∷ Boolean
      }

type Button =
      { id ∷ String
      , label ∷ String
      , message ∷ Message
      }

foreign import createRandomNRows_ ∷ EffectFn2 Int Int (Array Row)

createRandomNRows ∷ Int → Int → Aff (Array Row)
createRandomNRows n lastID = liftEffect (EU.runEffectFn2 createRandomNRows_ n lastID)

main ∷ Effect Unit
main = F.mount_ (QuerySelector "main")
      { model: model
      , view
      , subscribe: []
      , update
      }

model ∷ Model
model =
      { rows: []
      , lastID: 0
      }

view ∷ Model → Html Message
view model = HE.div [ HA.class' "container" ]
      [ jumbotron
      , HE.table [ HA.class' "table table-hover table-striped test-data" ]
              [ HE.tbody_ (map renderLazyRow model.rows)
              ]
      , footer
      ]

jumbotron ∷ Html Message
jumbotron = HE.div [ HA.class' "jumbotron" ]
      [ HE.div [ HA.class' "row" ]
              [ HE.div [ HA.class' "col-md-6" ]
                      [ HE.h1_ [ HE.text "Flame 1.0.0 (non-keyed)" ]
                      ]
              , HE.div [ HA.class' "col-md-6" ] (map renderActionButton buttons)

              ]
      ]

buttons ∷ Array Button
buttons =
      [ { id: "run", label: "Create 1,000 rows", message: Create 1000 }
      , { id: "runlots", label: "Create 10,000 rows", message: Create 10000 }
      , { id: "add", label: "Append 1,000 rows", message: AppendOneThousand }
      , { id: "update", label: "Update every 10th row", message: UpdateEveryTenth }
      , { id: "clear", label: "Clear", message: Clear }
      , { id: "swaprows", label: "Swap Rows", message: Swap }
      ]

renderActionButton ∷ Button → Html Message
renderActionButton button = HE.div [ HA.class' "col-sm-6 smallpad" ]
      [ HE.button
              [ HA.class' "btn btn-primary btn-block"
              , HA.id button.id
              , HA.createAttribute "ref" "text"
              , HA.onClick button.message
              ]
              [ HE.text button.label ]
      ]

renderLazyRow ∷ Row → Html Message
renderLazyRow row = HE.lazy Nothing renderRow row

renderRow ∷ Row → Html Message
renderRow row = HE.tr [ HA.class' { "danger": row.selected } ]
      [ HE.td colMd1 [ HE.text (show row.id) ]
      , HE.td colMd4 [ HE.a [ HA.onClick (Select row.id) ] [ HE.text row.label ] ]
      , HE.td colMd1 [ HE.a [ HA.onClick (Remove row.id) ] removeIcon ]
      , spacer
      ]

removeIcon ∷ Array (Html Message)
removeIcon =
      [ HE.span' [ HA.class' "glyphicon glyphicon-remove", HA.createAttribute "aria-hidden" "true" ]
      ]

colMd1 ∷ Array (NodeData Message)
colMd1 = [ HA.class' "col-md-1" ]

colMd4 ∷ Array (NodeData Message)
colMd4 = [ HA.class' "col-md-4" ]

spacer ∷ Html Message
spacer = HE.td' [ HA.class' "col-md-6" ]

footer ∷ Html Message
footer = HE.span' [ HA.class' "preloadicon glyphicon glyphicon-remove", HA.createAttribute "aria-hidden" "true" ]

update ∷ Update Model Message
update model =
      case _ of
            Create amount → model /\ [ map (\rows → Just (DisplayCreated rows)) (createRandomNRows amount model.lastID) ]
            DisplayCreated rows → F.noMessages (model { lastID = model.lastID + DA.length rows, rows = rows })

            AppendOneThousand →
                  let
                        amount = 1000
                  in
                        model /\ [ map (\rows → Just (DisplayAppended rows)) (createRandomNRows amount model.lastID) ]
            DisplayAppended newRows → F.noMessages (model { lastID = model.lastID + DA.length newRows, rows = model.rows <> newRows })

            UpdateEveryTenth → F.noMessages model { rows = DA.mapWithIndex updateLabel model.rows }

            Clear → F.noMessages (model { rows = [] })

            Swap →
                  F.noMessages
                        ( case swapRows model.rows 1 998 of
                                Nothing → model
                                Just swappedRows → model { rows = swappedRows }
                        )

            Remove id → F.noMessages (model { rows = DA.filter (\r → r.id /= id) model.rows })

            Select id → F.noMessages (model { rows = map (select id) model.rows })

updateLabel index row =
      if index `mod` 10 == 0 then
            row { label = row.label <> " !!!" }
      else
            row

swapRows arr index otherIndex = do
      rowA ← arr !! index
      rowB ← arr !! otherIndex
      arrA ← DA.updateAt index rowB arr
      arrB ← DA.updateAt otherIndex rowA arrA
      pure arrB

select id row
      | row.id == id = row { selected = true }
      | row.selected = row { selected = false }
      | otherwise = row
