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
        update :: model -> message -> model,
        inputs :: Array (Signal message)
}
```
is the `update` function. This is where we define our business logic by matching event messages and returning an updated model. For simplicity, we have only considered side effects free updating so far, however Flame offers three different ways to define your `update` function. These are called **update strategies**.

An update strategy is chosen by importing the `mount` function from a given module
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
        update :: model -> message -> model,
        inputs :: Array (Signal message)
}
```
This is enough for toy examples or small modules, but probably not sufficient to build an user facing application. If we need to do any sort of effectul computation we need to look into the next update strategies.

See all [no effects examples](https://github.com/easafe/purescript-flame/tree/master/examples/NoEffects).

### Effect list updating

In the effect list strategy, our update function is still "pure", but we also return an array of effects to be performed
```haskell
type Application model message = {
        init :: Tuple model (Array (Aff message)),
        view :: model -> Html message,
        update :: model -> message -> Tuple model (Array (Aff message)),
        inputs :: Array (Signal message)
}
```
Every effect in the array is performed in order and `update` is called again with the resulting `message`. Consider an application to roll dices
```haskell
type Model = Maybe Int

data Message = Roll | Update Int

update :: Model -> Message -> Tuple Model (Array (Aff Message))
update model = case _ of
        Roll -> model :> [
                Update <$> liftEffect (ER.randomInt 1 6)
        ]
        Update int -> Just int :> []

view :: Model -> Html Message
view model = HE.main "main" [
        HE.text (show model),
        HE.button [HA.onClick Roll] "Roll"
]
```
Whenever we get the `Roll` message we return a `Tuple` (using the infix operator `:>`) with the model and the effectful computation. This will in turn raise the `Update` message, which will carry the generated random number that will be our new model.

Likewise, we could define a loading screen to appear before AJAX requests
```haskell
type Model = { response :: String, isLoading :: boolean }

data Message = Loading | Response String | Finish

performAJAX :: String -> Aff String
performAJAX url = ...

useResponse :: Model -> String -> Model
useResponse = ...

update :: Model -> Message -> Tuple Model (Array (Aff Message))
update model = case _ of
        Loading -> model { isLoading = true } :> [
                Response <$> performAJAX "url",
                Response <$> performAJAX "url2",
                Response <$> performAJAX "url3",
                Response <$> performAJAX "url4",
                pure Finish
        ]
        Response contents -> useResponse model contents :> []
        Finish -> model { isLoading = false } :> []

view :: Model -> Html Message
view model = HE.main "main" [
        HE.button [HA.disabled model.isLoading, HA.onClick Loading] "Perform requests",
        if model.isLoading then
                HE.div [HA.className "overlay"] "Loading..."
         else
                ...
]
```
Same way, here every call to `performAJAX` will also cause `update` to be called again with a new `Response` until we get a `Finish` message.

Notice that the type of `init` is also defined as `Tuple model (Array (Aff message))`. This enables us to run effects at the startup of the application. Suppose we also wanted to perform some AJAX requests before any other user interaction. We could have defined `init` for the previous example as follows
```haskell
init :: Tuple Model (Array (Aff Message))
init = model :> [
                Response <$> performAJAX "url",
                Response <$> performAJAX "url4",
                pure Finish
]
```
which has the same expected behavior of calling `update` for entry in the array.

See all [effect list examples](https://github.com/easafe/purescript-flame/tree/master/examples/EffectList).

### Effectful updating

The effect list strategy is great for testability and isolating effects, but some kind of program flows became somewhat awkward to write. For most messages, we essentially have to define a different type constructor for each step in the computation. Flame provides an alternative way to perform effects in the `update` function.

The effectful updating defines `Application` as
```haskell
type Application model message = {
        init :: Tuple model (Maybe message),
        view :: model -> Html message,
        update :: World model message -> model -> message -> Aff model,
        inputs ::  Array (Signal message)
}
```
Here instead of returning a list of effects, we perform them directly as `update` is in the `Aff` monad. The funny looking extra parameter of `update` is a record with the fields
```haskell
type World model message = {
        update :: model -> message -> Aff model,
        view :: model -> Aff Unit,
        event :: Maybe Event,
        previousModel :: model,
        previousMessage :: Maybe message
}
```
It enables us

<a href="/views" class="direction previous">Previous: Defining views</a>
<a href="/rendering" class="direction">Next: Rendering the app</a>