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
      subscribe :: Array (Subscription message)
}
```

is the `update` function. This is where we define our business logic by matching event `message`s and returning an updated model. For simplicity, we have only considered side effects free updating so far, however Flame offers three different ways to define your `update` function.

Each module under `Flame.Application` export a `mount` (or `mount_`) function which asks for an application record with different `init` and `update` types

```haskell
import Flame.Application.NoEffects (mount) -- side effects free updating
import Flame (mount) -- Elm style updating, using a list of effects
import Flame.Application.Effectful (mount) -- Aff based updating
```

Let's discuss each of them in detail.

### No effects updating

The application record is the same as we have seen so far

```haskell
type Application model message = {
      init :: model,
      view :: model -> Html message,
      update :: model -> message -> model,
      subscribe :: Array (Subscription message)
}
```

This is enough for toy examples or small modules, but probably not sufficient to build an user facing application. If we want to do any sort of effectul computation we need to look into the next `update` types.

### Effect list updating

This is the default way to run a Flame application. The record here has `init` and `update` return an array of effects to be performed

```haskell
type Application model message = {
      init :: Tuple model (Array (Aff (Maybe message))),
      view :: model -> Html message,
      update :: model -> message -> Tuple model (Array (Aff (Maybe message))),
      subscribe :: Array (Subscription message)
}
```

For every entry in the array, the effect is run and `update` is called again with the resulting `message`. Consider an application to roll dices

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
type Model = {
      response :: String,
      isLoading :: Boolean
}

data Message =
      Loading |
      Response String |
      DifferentResponse String |
      Finish String

performAJAX :: String -> Aff String
performAJAX url = ...

useResponse :: Model -> String -> Aff Model
useResponse = ...

useDifferentResponse :: Model -> String -> Aff Model
useDifferentResponse = ...

update :: ListUpdate Model Message -- type synonym to reduce clutter
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

In the same way, here every call to `performAJAX` also causes `update` to be called again with a new `Response` or `DifferentResponse` until we get a `Finish` message.

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

### Effectful updating

Returning an array of effects is great for testability and isolating input/output, but certain program flows became somewhat awkward to write. For most messages, we essentially have to create a different data constructor for each step in the computation. For that reason, Flame provides an alternative way to perform effects in the `update` function.

The effectful updating defines `Application` as

```haskell
type Application model message = {
      init :: Tuple model (Maybe message),
      view :: model -> Html message,
      update :: Environment model message -> Aff (model -> model),
      subscribe :: Array (Subscription message)
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

`model` and `message` are now grouped in a record. `display` is a function to arbitrarily re-render the view.

Let's rewrite the dice application using the effectful updates

```haskell
type Model = Maybe Int

data Message = Roll

update :: Environment Model Message -> Aff (Model -> Model)
update _ = map (const <<< Just) $ liftEffect $ ER.randomInt 1 6
```

Since we are always generating a new model, and don't need an intermediate message to update it, we can ignore the environment and perform the update in a single go.

Let's see how we can use `display` to rewrite the AJAX example from above as well

```haskell
type Model = {
      response :: String,
      isLoading :: boolean
}

data Message = Loading

update :: AffUpdate Model Message -- type synonym to reduce clutter
update { display } = do
            display _ { isLoading = true }
            traverse (\rs -> display  _ { response = rs }) [
                  performAJAX "url",
                  performAJAX "url2",
                  performAJAX "url3",
                  performAJAX "url4",
            ]
            pure $ _ { isLoading = false }

init :: Tuple Model (Maybe Message)
init = model :> Just Loading
```

`display` renders the view with the modified model without leaving the `update` function, which is again a little more straightforward.

But juggling model update functions can quickly turn messy, specially if we are using records. For that reason, helper functions are provided to modify only given fields

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

## [Subscriptions](#subscriptions)

More often than not, a real world application needs to handle events that don't come from the view. These may include events targeting `window`, `document`, third party JavaScript components or in some cases messages from other mount points or application code. We can tackle these scenarios in a few different ways:

* External event handlers

When mounting the application, `subscribe` can be used to specify `message`s as a list of subscriptions. The modules under `Flame.Subscription` define `on` event handlers similar to those used in views

```haskell
FAN.mount_ (QuerySelector "body") {
      ...
      subscribe: [
            FSW.onLoad Message, -- `window` event from `Flame.Subscription.Window`
            FSD.onClick Message2, -- `document` event from `Flame.Subscription.Document`,
            FS.onCustomEvent (EventType "custom") Message3 -- `CustomEvent` with `Flame.Subscription.onCustomEvent`
      ]
}
```

The only restriction is that `CustomEvent` messages payloads must be JSON serializable

```haskell
onCustomEvent :: forall arg message. UnserializeState arg => EventType -> (arg -> message) -> Subscription message
```

since they might come from external JavaScript that is not guaranteed to match PureScript data types.

Once a subscription has been defined, the raised `message` will be handled by the `update` function as usual.

* Arbitrary message passing

Sometimes, we need to talk to an application from external events handlers or other points in code far away from the mount point. Consider an app that uses web sockets, or a singe page application that uses multiple mount points for lazy loading. For these and other use cases, Flame provides a `mount` function that takes an application id, as well a `send` function to raise messages for application ids

```haskell
mount :: forall id model message. Show id => QuerySelector -> AppId id message -> Application model message -> Effect Unit

send :: forall id message. Show id => AppId id message -> message -> Effect Unit
```

Anything that has a `Show` instance can be an id, but the application will crash while mounting if the id isn't unique. That being said, passing `message` to an application is straightforward

```haskell
import Flame as F
import Flame(AppId(..))
import Flame.Subscription as FS

data Applications = FirstApp | SecondApp
instance appShow :: Show Applications where
      ...

data FirstAppMessage = MyFirstMessage

main :: Effect Unit
main = do
      -- application id
      let id = AppId FirstApp :: AppId Applications FirstAppMessage
      -- mount instead of mount_
      F.mount (QuerySelector "body") id {
            ...
      }
      -- raise a message for FirstApp
      FS.send id MyFirstMessage
```

Then if there is another mount point someplace else in the code, it can still talk to `FirstApp`. There is no need to persist application ids, as long as the correct type is used

```haskell
import Flame as F
import Flame.Subscription as FS
import Flame(AppId(..))

data SecondAppMessage = MySecondMessage

main :: Effect Unit
main = do
      -- diffent application id
      let secondId = AppId SecondApp :: AppId Applications SecondAppMessage

      F.mount (QuerySelector "body") secondId {
            ...
      }
      -- raise a message for FirstApp again
      FS.send (AppId FirstApp) MyFirstMessage -- with type AppId Applications FirstAppMessage
      -- raise a message for SecondApp
      FS.send secondId MySecondMessage
```

* Broadcasting

Flame also provides a way to "broadcast" `CustomEvent`s for all listeners. `Flame.Subscription.Unsafe.CustomEvent` provides the following function

```haskell
broadcast :: forall arg. SerializeState arg => EventType -> arg -> Effect Unit
```

whose events can be handled with `onCustomEven` on your `subscribe` list. Broadcasting events is considered unsafe, as it is user code responsibility to make sure all listeners expect the same `message` payload.

See the [API reference](https://pursuit.purescript.org/packages/purescript-flame) for a complete list of built-in external events. See this [test application](https://github.com/easafe/purescript-flame/tree/master/examples/Subscriptions) for a full example of subscriptions.

## Structuring applications

Having a single model of the whole application state may to lead to unwieldy code structure. For that reason, JavaScript frameworks such as React encourage the use of "components", i.e, (reusable) units of code with isolated state and business logic. This in turn necessitates some way to keep the state in sync for all moving parts.

In a purely functional language like PureScript, however, we have most of benefits of components (and libraries like Redux) built in. Views or business logic code can be easily broken down into modules. Abstractions and general functions promote composition and reuse. Events from your view, as opposed to messages passed down between hierarchies of components, are also easier to follow and modify. Because of that, splitting a application into smaller ones brings an overhead of type mappings/communication without much of benefits supposed by more imperative frameworks.

<a href="/views" class="direction previous">Previous: Defining views</a>
<a href="/rendering" class="direction">Next: Rendering the app</a>
