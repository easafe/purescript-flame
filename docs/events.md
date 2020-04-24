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
is the `update` function. This is where we define our business logic by matching event messages and returning an updated model. For simplicity, we have only considered side effects free updating so far, however Flame offers three different ways to define your `update` function. These are called update strategies.

An update strategy is chosen by importing the `mount` (or `mount_`) function from a given module
```haskell
import Flame.Application.NoEffects (mount) -- pure, or side effect free, updating
import Flame (mount) -- Elm style updating, using a list of effects
import Flame.Application.Effectful (mount) -- Aff based updating
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
This is the default strategy to run a flame application. For every entry in the array, the effect is performed and `update` is called again with the resulting `message`. Consider an application to roll dices
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
Whenever `update` receives the `Roll` message, a `Tuple` (using the infix operator `:>`) of the model and effect list is returned. Performing the effect in the list raises the `Update` message, which carries the generated random number that will be the new model.

Likewise, we could define a loading screen to appear before AJAX requests
```haskell
type Model = { response :: String, isLoading :: Boolean }

data Message = Loading | Response String | DifferentResponse String | Finish String

performAJAX :: String -> Aff String
performAJAX url = ...

useResponse :: Model -> String -> Aff Model
useResponse = ...

useDifferentResponse :: Model -> String -> Aff Model
useDifferentResponse = ...

update :: ListUpdate Model Message -- type synonymum to reduce clutter
update model = case _ of
        Loading -> model { isLoading = true } :> [
                Just <<< Response <$> performAJAX "url",
                Just <<< DifferentResponse <$> performAJAX "url2",
                Just <<< Response <$> performAJAX "url3",
                Just <<< DifferentResponse <$> performAJAX "url4",
                pure <<< Just $ Finish "Performed all"
        ]
        Response contents -> F.noMessages $ useResponse model contents -- noMessages is the same as _ :> []
        Finish contents -> F.noMessages $ model { isLoading = false, response = model.response <> contents }

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

Notice that the type of `init` is also defined as `Tuple model (Array (Aff (Maybe message)))`. This enables us to run effects at the startup of the application. Suppose in the previous example we also wanted to perform some AJAX requests before any other user interaction. We could have defined `init` as follows
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
which has the same expected behavior of calling `update` with the resulting message of every entry in the array.

See all [effect list examples](https://github.com/easafe/purescript-flame/tree/master/examples/EffectList).

### Effectful updating

The effect list strategy is great for testability and isolating effects, but certain program flows became somewhat awkward to write. For most messages, we essentially have to define a different type constructor for each step in the computation. For that reason, Flame provides an alternative way to perform effects in the `update` function.

The effectful updating defines `Application` as
```haskell
type Application model message = {
        init :: Tuple model (Maybe message),
        view :: model -> Html message,
        update :: Environment model message -> Aff (model -> model)
}
```
Here instead of returning a list of effects, we perform them directly in the `Aff` monad. Because the `update` function is now fully asynchronous, its type is a little different. Instead of the model, we return a function to modify it -- this ensures slower computations don't overwrite unrelated updates that might happen in the meanwhile. `Environment` is defined as follows

```haskell
type Environment model message = {
        model :: model,
        message :: message,
        display :: (model -> model) -> Aff Unit
}
```

`model` and `message` are grouped in a record. `display` is a function to arbitrarily re-render the view.

Let's rewrite the dice application using the effectful strategy:
```haskell
type Model = Maybe Int

data Message = Roll

update :: Environment Model Message -> Aff (Model -> Model)
update _ = map (const <<< Just) $ liftEffect $ ER.randomInt 1 6
```

Since we are always generating a new model, and don't need an intermediate message to update it, we can ignore the enviroment and perform the update in a single go.

Let's see how we can use `display` to rewrite the AJAX example from above as well

```haskell
type Model = { response :: String, isLoading :: boolean }

data Message = Loading

update :: AffUpdate Model Message -- type synonymum to reduce clutter
update { display } = do
                display _ { isLoading = true }
                traverse (\rs -> display  _ { response = rs}) [
                        performAJAX "url",
                        performAJAX "url2",
                        performAJAX "url3",
                        performAJAX "url4",
                ]
                pure $ _ { isLoading = false }

init :: Tuple Model (Maybe Message)
init = model :> Just Loading
```
`display` will render the view with the modified model as seen fit, which is again a little more straightforward.

But juggling record update functions can quickly turn messy, specially if we are using records as a model. For that reason, helper functions are provided to modify only given fields:

```haskell
diff' :: forall changed model. Diff changed model => changed -> (model -> model)
diff :: forall changed model. Diff changed model => changed -> Aff (model -> model)
```

the `Diff` type class guarantees that `changed` only includes fields present in `model` so instead of `pure _ { field = value }` we can write `diff { field: value }`. Let's see an example:

```haskell
newtype MyModel = MyModel {
        url :: String,
        result :: Result,
        ...
}
derive instance myModelNewtype :: Newtype MyModel _

update :: AffUpdate MyModel Message
update { display, model: MyModel model, message } =
        case message of
                UpdateUrl url -> FAE.diff { url, result: NotFetched }
                Fetch -> do
                        display $ FAE.diff' { result: Fetching }
                        response <- A.get AR.string model.url
                        FAE.diff <<< { result: _ } $ case response.body of
                                Left error -> Error $ A.printResponseFormatError error
                                Right ok -> Ok ok
                ... -> ...
```

Here, no matter how many fields `MyModel` has, we update only what's required in each case expression. Notice that `diff` always takes a record as first parameter. The model, however, can be either a record or newtype (given a `Newtype` instance)/plain functor that holds a record to be updated.

See all [effectful examples](https://github.com/easafe/purescript-flame/tree/master/examples/Effectful).

## [Handling external events](#handling-external-events)

More often than not, a real world application will need to handle events that don't come from the view. These might include events targeting `window` or `document`, or third party components. To solve this problem, the `mount` function returns a [`Channel`](https://pursuit.purescript.org/packages/purescript-signal/10.1.0/docs/Signal.Channel) which can be fed arbitrary messages

`Flame.Application.NoEffects.mount` returns a `Channel (Array message)`

`Flame.Application.EffectList.mount` returns a `Channel (Array message)`

`Flame.mount` returns a `Channel (Maybe message)`

The module `Flame.External` defines common events such as (`window`) `load` or (`document`) `onclick` and a helper `send` to bind multiple events to a channel

```haskell
import Flame.Application.NoEffects as FAN
import Flame.External as FE
import Signal.Channel as SC
...

main :: Effect Unit
main = do
        channel <- FAN.mount {...}
        --raise these messages when these events are fired
        FE.send [FE.offline [Message3], FE.onClick [Message, Message2]] channel
        --manualy raise a message
        SC.send channel [Message4]
```

See the [API reference](https://pursuit.purescript.org/packages/purescript-flame) for a complete list of built-in external events. See the [webchat test application](https://github.com/easafe/purescript-flame/tree/master/examples/Effectful/Webchat) for more examples of external events.

## Event handling and components

If you have used React, Vue.js, or are just worried how complex state updating could become, you might be wondering how to struct Flame in "components". That is, to isolate state and business logic to individual units that can be reused.

Such approach however is not quite necessary in a purely functional language like PureScript. We could, for instance, break down a big application into several smaller ones and create type mappings for the model/use channels, but that seems hardly any improvement over just composing functions. As we have seen before, views can be easily composed -- an effective way to organize an application is to split views, together with the business logic related to them, into modules. This way, by virtue of having a single `update` and `model` per application, we avoid the boilerplate of having to sync the model or map its types, and still keep our application manageable.

<a href="/views" class="direction previous">Previous: Defining views</a>
<a href="/rendering" class="direction">Next: Rendering the app</a>
