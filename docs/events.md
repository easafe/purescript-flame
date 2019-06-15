---
layout: default
title: Handling events
permalink: /events
---

## Handling events

Perhaps the most important field in the application record
```haskell
type Application model message = {
        init :: model,
        view :: model -> Html message,
        update :: model -> message -> model
}
```
is the `update` function. This is where we define our business logic by matching event messages and returning an updated model. For simplicity, we have only considered side effects free updating so far, however Flame offers three different ways to define your `update` function. These are called **update strategies**.

An update strategy is chosen by importing the `mount` (or `mount_`) function from a given module
```haskell
import Flame.Application.NoEffects (mount) -- pure, or side effect free, updating
import Flame.Application.EffectList (mount) -- Elm style updating, using a list of effects
import Flame (mount) -- Aff based updating
```
which each asks for an application record with different `init` and `update` types. Let's take a look at each of them.

### No effects updating

For this strategy, the application record is the same as we have seen so far
```haskell
type Application model message = {
        init :: model,
        view :: model -> Html message,
        update :: model -> message -> model
}
```
This is enough for toy examples or small modules, but probably not sufficient to build an user facing application. If we want to do any sort of effectul computation we need to look into the next update strategies.

See all [no effects examples](https://github.com/easafe/purescript-flame/tree/master/examples/NoEffects).

### Effect list updating

In the effect list strategy, our update function is still "pure", but we also return an array of effects to be performed
```haskell
type Application model message = {
        init :: Tuple model (Array (Aff (Maybe message))),
        view :: model -> Html message,
        update :: model -> message -> Tuple model (Array (Aff (Maybe message)))
}
```
For every entry in the array, the effect is performed and `update` is called again with the resulting `message`. Consider an application to roll dices
```haskell
type Model = Maybe Int

data Message = Roll | Update Int

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
        Roll -> model :> [
                Just <<< Update <$> liftEffect (ER.randomInt 1 6)
        ]
        Update int -> Just int :> []

view :: Model -> Html Message
view model = HE.main "main" [
        HE.text $ show model,
        HE.button [HA.onClick Roll] "Roll"
]
```
Whenever `update` receives the `Roll` message, a `Tuple` (using the infix operator `:>`) with the model and the effect list is returned . Performed the effect in the list in turn raises the `Update` message, which carries the generated random number that will be our new model.

Likewise, we could define a loading screen to appear before AJAX requests
```haskell
type Model = { response :: String, isLoading :: boolean }

data Message = Loading | Response String | DifferentResponse String | Finish String

performAJAX :: String -> Aff String
performAJAX url = ...

useResponse :: Model -> String -> Aff Model
useResponse = ...

useDifferentResponse :: Model -> String -> Aff Model
useDifferentResponse = ...

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
        Loading -> model { isLoading = true } :> [
                Just <<< Response <$> performAJAX "url",
                Just <<< DifferentResponse <$> performAJAX "url2",
                Just <<< Response <$> performAJAX "url3",
                Just <<< DifferentResponse <$> performAJAX "url4",
                pure <<< Just $ Finish "Performed all"
        ]
        Response contents -> useResponse model contents :> []
        Finish contents -> model { isLoading = false, response = model.response <> contents } :> []

view :: Model -> Html Message
view model = HE.main "main" [
        HE.button [HA.disabled model.isLoading, HA.onClick Loading] "Perform requests",
        if model.isLoading then
                HE.div [HA.className "overlay"] "Loading..."
         else
                ...
]
```
In the same way, here every call to `performAJAX` will also cause `update` to be called again with a new `Response` or `DifferentResponse` until we get a `Finish` message.

Notice that the type of `init` is also defined as `Tuple model (Array (Aff (Maybe message)))`. This enables us to run effects at the startup of the application. Suppose we also wanted to perform some AJAX requests before any other user interaction. We could have defined `init` for the previous example as follows
```haskell
init :: Tuple Model (Array (Aff (Maybe Message)))
init = model :> [
                Just <<< Response <$> performAJAX "url",
                Just <<< DifferentResponse <$> performAJAX "url2",
                Just <<< Response <$> performAJAX "url3",
                Just <<< DifferentResponse <$> performAJAX "url4",
                pure <<< Just $ Finish "Performed all"
]
```
which has the same expected behavior of calling `update` for entry in the array.

See all [effect list examples](https://github.com/easafe/purescript-flame/tree/master/examples/EffectList).

### Effectful updating

The effect list strategy is great for testability and isolating effects, but certain program flows became somewhat awkward to write. For most messages, we essentially have to define a different type constructor for each step in the computation. For that reason, Flame provides an alternative way to perform effects in the `update` function.

The effectful updating defines `Application` as
```haskell
type Application model message = {
        init :: Tuple model (Maybe message),
        view :: model -> Html message,
        update :: World model message -> model -> message -> Aff model
}
```
Here instead of returning a list of effects, we perform them directly in the `Aff` monad. ``init` also only receives a single optional start up message.

We can see that the dice example listed in the previous section becomes a little more straight forward
```haskell
type Model = Maybe Int

data Message = Roll

update :: _ -> Model -> Message -> Aff Model
update _ model Roll = Just <$> liftEffect (ER.randomInt 1 6)
```
Before the AJAX example, we will need to examine the funny looking extra parameter of `update`. It is defined as a record with the fields
```haskell
type World model message = {
        update :: model -> message -> Aff model,
        view :: model -> Aff Unit,
        event :: Maybe Event,
        previousModel :: Maybe model,
        previousMessage :: Maybe message
}
```
`World.update` may be thought of a way to recurse the update function -- it is used to raise and process different messages in a single go. `World.view`, on the other hand, allows arbitraty rerendering of the view without raising a different message. `World.event` carries the current raw browser event. The last two fields are for convenience, if we ever need to backtrace model or messages.

Using `World` we can write the AJAX example as
```haskell
type Model = { response :: String, isLoading :: boolean }

data Message = Loading | Finish String

update :: World Model Message -> Model -> Message -> Aff Model
update re model = case _ of
        Loading -> do
                let model' = model { isLoading = true }
                newModel <- traverse (\rs -> re.view $ model' { response = rs}) [
                        performAJAX "url",
                        performAJAX "url2",
                        performAJAX "url3",
                        performAJAX "url4",
                ]
                re.update newModel Finish "Performed all"
        Finish contents -> pure $ model { isLoading = false, response = model.response <> contents }

init :: Tuple Model (Maybe Message)
init = model :> Loading
```
which is again a little more straightforward.

See all [effectful examples](https://github.com/easafe/purescript-flame/tree/master/examples/Effectful).

## [Handling external events](#handling-external-events)

More often than not, a real world application will need to handle events that don't come from the view markup. These might include events targeting `window` or `document`, or simply third party components. To solve this problem, the `mount` function returns a [`Channel`](https://pursuit.purescript.org/packages/purescript-signal/10.1.0/docs/Signal.Channel) which can be fed arbitrary messages

```haskell
Flame.Application.NoEffects.mount -- returns Channel (Array message)
Flame.Application.EffectList.mount -- returns Channel (Array message)
Flame.mount -- returns Channel (Maybe message)
```

The module `Flame.External` defines common events such as (`window`) `load` or (`document`) `onclick` and a helper `send` to bind multiple events to a channel

```haskell
...
import Flame.Application.NoEffects as FAN
import Flame.External as FE
import Signal.Channel as SC
...

main :: Effect Unit
main = do
        channel <- FAN.mount {...}
        --raise these messages when for the events
        FE.send [FE.offline [Message3], FE.onClick [Message, Message2]] channel
        --manualy send a message to the channel
        SC.send channel [Message4]
```

See the [API reference](https://pursuit.purescript.org/packages/purescript-flame) for a complete list of backed in external events. See the [webchat test application](https://github.com/easafe/purescript-flame/tree/master/examples/Effectful/Webchat) for more examples of external events.

## Event handling and components

If you have used React, Vue.js, or are just worried how complex state updating could become, you might be wondering how to struct Flame in "components". That is, to isolate state and business logic to individual units that can be reused.

Such approach however is not quite necessary in a purely functional language like PureScript. We could, for instance, break down a big application into several smaller ones and create type mappings for the model/use channels, but that seems hardly any improvement over just composing functions. As we have seen before, views can be easily composed -- an effective way to organize an application is to split views, together with the business logic related to them, into modules. This way, by virtue of having a single `update` and `model` per application, we avoid the boilerplate of having to sync the model or map its types, and still keep our application manageable.

<a href="/views" class="direction previous">Previous: Defining views</a>
<a href="/rendering" class="direction">Next: Rendering the app</a>