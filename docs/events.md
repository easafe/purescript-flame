---
layout: default
title: Handling events
permalink: /events
---

## Handling events

Perhaps the most important field in the application record

```haskell
type Application model message = {
      model :: model
      view :: model -> Html message,
      update :: Update model message,
      subscribe :: Array (Subscription message)
}
```

is the `update` function. So far we have been using the `Update` type alias. Let's expand it:

```haskell
type Application model message = {
      model :: model,
      view :: model -> Html message,
      update :: model -> message -> Tuple model (Array (Aff (Maybe message))),
      subscribe :: Array (Subscription message)
}
```

That means that `update` returns an updated model but also an array of side effects to perform. Each entry in the array may optionally raise another `message`, which is in turn handled by `update` as well.

Consider an application to roll dices

```haskell
type Model = Maybe Int

data Message = Roll | Update Int

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
      Roll -> model /\ [ rollDice ]
      Update int -> Just int /\ []
      where rollDice = do
                  n <- EC.liftEffect $ ER.randomInt 1 6
                  pure <<< Just $ Update n

view :: Model -> Html Message
view model = HE.main "main" [
      HE.text $ show model,
      HE.button [HA.onClick Roll] "Roll"
]
```

`Roll` returns the model as it is. However, generating random numbers is a side effect so we return it on our array. Flame will run this effect and raise `Update`, which then updates the model with the die number.

Likewise, we could perform some network requests with a loading screen

```haskell
type Model = {
      response :: String,
      isLoading :: Boolean
}

data Message =
      Perform |
      Response String |
      DifferentResponse String |
      Finish String

fetch :: String -> Aff String
fetch url = ...

useResponse :: Model -> String -> Aff Model
useResponse = ...

useDifferentResponse :: Model -> String -> Aff Model
useDifferentResponse = ...

update :: Model -> Message -> Tuple Model (Array (Aff (Maybe Message)))
update model = case _ of
      Perform -> model { isLoading = true } /\ requests
      Response contents -> F.noMessages $ useResponse model contents -- noMessages is the same as _ /\ []
      Finish contents -> F.noMessages model { isLoading = false, response = model.response <> contents }
      where requests = [
                  Just <<< Response <$> fetch "url",
                  Just <<< DifferentResponse <$> fetch "url2",
                  Just <<< Response <$> fetch "url3",
                  Just <<< DifferentResponse <$> fetch "url4",
                  pure <<< Just $ Finish "Performed all"
            ]

view :: Model -> Html Message
view model = HE.main "main" [
      HE.button [HA.disabled model.isLoading, HA.onClick Perform] "Perform requests",
      if model.isLoading then
            HE.div [HA.class' "overlay"] "Loading..."
       else
            ...
]
```

Here for `Perform`, we return an array of network calls and a final `Finish` message. The effects are run in order, and once we have a response their events are raised for `update` as well.

You may be wondering: why separate model updating and side effects? The reason is that in this way we are "forced" to keep most of our business logic in pure functions, which are easier to reason and test. Effects become interchangeable, decoupled from what we do with their results.

## [Subscriptions](#subscriptions)

More often than not, a real world application needs to handle events that don't come from the view. These may include events targeting `window`, `document`, third party JavaScript components or in some cases messages from other mount points or application code. We can tackle these scenarios in a few different ways:

* External event handlers

When mounting the application, `subscribe` can be used to specify `message`s as a list of subscriptions. The modules under `Flame.Subscription` define `on` event handlers similar to those used in views

```haskell
F.mount_ (QuerySelector "body") {
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

Sometimes, we need to talk to an application from external events handlers or other points in the code away from the mount point. Consider an app that uses web sockets, or a singe page application that uses multiple mount points for lazy loading, or just some initialization events. For these and other use cases, Flame provides a `mount` (no trailing underscore) function that takes an application id, as well a `send` function to raise messages for application ids

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

whose events can be handled with `onCustomEvent` on your `subscribe` list. Broadcasting events is considered unsafe as it is user code responsibility to make sure all listeners expect the same `message` payload.

See the [API reference](https://pursuit.purescript.org/packages/purescript-flame) for a complete list of built-in external events. See this [test application](https://github.com/easafe/purescript-flame/tree/master/examples/Subscriptions) for a full example of subscriptions.

## Structuring applications

Having a single model of the whole application state may to lead to unwieldy code structure. For that reason, JavaScript frameworks such as React encourage the use of "components", i.e, (reusable) units of code with isolated state and business logic. This in turn necessitates some way to keep the state in sync for all moving parts.

In a purely functional language like PureScript, however, we have most of benefits of components (and libraries like Redux) built in. Views or business logic code can be easily broken down into modules. Abstractions and general functions promote composition and reuse. Events from your view, as opposed to messages passed down between hierarchies of components, are also easier to follow and modify. Because of that, splitting a application into smaller ones brings an overhead of type mappings/communication without much of benefits supposed by more imperative frameworks.

<a href="/views" class="direction previous">Previous: Defining views</a>
<a href="/rendering" class="direction">Next: Rendering the app</a>
