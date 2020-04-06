---
layout: default
title: Defining views
permalink: /views
---

## Defining views

In the application record
```haskell
type Application model message = {
        init :: model,
        view :: model -> Html message,
        update :: model -> message -> model
}
```
the `view` field maps the current state to markup. Whenever the model is updated, flame will patch the DOM by calling `view` with the new state.

A custom DSL, defined by the type `Html`, is used to write markup. You will need to qualify imports, e.g., prefix HE for HTML elements and HA for HTML attributes, properties and events

```haskell
import Flame.HTML.Element as HE
import Flame.HTML.Attribute as HA
```

### Attributes, properties and events

The module `Flame.HTML.Attribute` exports

* Properties, which are functions from string values such as `id` or `type'`, or helpers such as `class'` or `style`

* Presential properties, such as `disabled` or `checked`, expecting boolean parameters

* Regular name value HTML attributes

* Events, such as `onClick` or `onInput`, expecting a `message` type constructor

See the [API reference](https://pursuit.purescript.org/packages/purescript-flame) for a complete list of attributes. In the case you need to define your own attributes/properties/events, Flame provides the combinators

```haskell
HA.createAttibute
HA.createProperty
HA.createEvent
HA.createRawEvent
```

### Elements

The module `Flame.HTML.Element` exports HTML elements, such as `div`, `body`, etc, following the convention

* Functions named `element` expects attributes and children elements

```haskell
HE.div [HA.id "my-div"] [HE.text "text content"] --renders <div id="my-div">text content</div>
```

* Functions named `element_` (trailing underscore) expects children elements but no attributes

```haskell
HE.div_ [HE.text "text content"] --renders <div>text content</div>
```

* Functions named `element'` (trailing quote) expects attributes but no children elements

```haskell
HE.div' [HA.id "my-div"] --renders <div id="my-div"></div>
```

(a few elements that usually have no children like br or input have `element` behave as `element'`)

Attributes and children elements are passed as arrays

```haskell
HE.div [HA.id "my-div", HA.disabled False, HA.title "div tite"] [
        HE.span' [HA.id "special-span"],
        HE.br,
        HE.span_ [HE.text "I am regular"],
]
{- renders
<div id="my-div" title="div title">
        <span id="special-span"></span>
        <br>
        <span>I am regular</span>
</div>
-}
```

But for some common cases, the markup DSL also defines convenience type classes so we can write

* `HE.element "my-element" _` instead of `HE.element [HA.id "my-element"] _` to declare an element with only id as attributes

* `HE.element _ "text content"` instead of `HE.element _ [HE.text "text content"]` to declare elements with only text as children

* `HE.element (HA.attribute _) _` instead of `HE.element [HA.attribute _] _` to declare elements with a single attribute

* `HE.element _ $ HE.element _ _` instead of `HE.element _ [HE.Element _ _]` to declare elements with a single child element

See the [API reference](https://pursuit.purescript.org/packages/purescript-flame) for a complete list of elements. In the case you need to define your own elements, Flame provides a few combinators as well

```haskell
HE.createElement
HE.createElement_
HE.createElement'
HE.createEmptyElement
```

### View logic

A `view` is just a regular PureScript function, meaning we can compose it or pass it around as any other value. For example, we can use the model in attributes
```haskell
newtype Model = Model { done :: Int, enabled :: Boolean }

type Message = Do

view :: Model -> Html Message
view model = HE.div [HA.class' { usefulClass: model.enabled }] $ HE.input [HA.type' "button", HA.value "Do thing number " <> show $ model.done, HA.onClick Do]
```
or to selective alter the markup
```haskell
type Name = String

type Model = Just Name

type Message = Update Name | Greet

view :: Model -> Html Message
view = case _ of
        Nothing -> HE.div' [
                HE.input [HA.type' "text", HA.onInput Update],
                HE.input [HA.type' "button", HA.value "Greet!", HA.onClick Greet]
        ]
        Just name -> "Greetings, " <> name <> "!"
```
but perhaps more interesting is the ability to create "partial views" without any special syntax support. We will talk more about how to structure applications in the next section, [Handling events](events), but creating reusable views is remarkably simple.
```haskell
header :: forall model message. model -> Html message
header = ...

footer :: forall model message. model -> Html message
footer = ...

view :: Model -> Html Message
view model = HE.content' [
        header,
        ...
        footer
]
```

See the [counters test application](https://github.com/easafe/purescript-flame/tree/master/examples/NoEffects/Counters) for more examples of how to compose views.

<a href="/concepts" class="direction previous">Previous: Main concepts</a>
<a href="/events" class="direction">Next: Handling events</a>
