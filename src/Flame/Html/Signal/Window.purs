-- | Defines events for the native `window` object
module Flame.Html.Signal.Window (onError, onError', onLoad, onLoad', onOffline, onOffline', onOnline, onOnline', onResize, onResize', onUnload, onUnload') where

import Flame.Html.Signal.Types (ToEventSource, ToEventSource_, ToRawEventSource, ToRawEventSource_)
import Flame.Html.Signal.Source (createEventSource, createRawEventSource)

foreign import onError_ :: forall message. ToEventSource_ message
foreign import onError__ :: forall message. ToRawEventSource_ message
foreign import onResize_ :: forall message. ToEventSource_ message
foreign import onResize__ :: forall message. ToRawEventSource_ message
foreign import onOffline_ :: forall message. ToEventSource_ message
foreign import onOffline__ :: forall message. ToRawEventSource_ message
foreign import onOnline_ :: forall message. ToEventSource_ message
foreign import onOnline__ :: forall message. ToRawEventSource_ message
foreign import onLoad_ :: forall message. ToEventSource_ message
foreign import onLoad__ :: forall message. ToRawEventSource_ message
foreign import onUnload_ :: forall message. ToEventSource_ message
foreign import onUnload__ :: forall message. ToRawEventSource_ message

onError :: forall message. ToEventSource message
onError = createEventSource onError_

onError' :: forall message. ToRawEventSource message
onError' = createRawEventSource onError__

onResize :: forall message. ToEventSource message
onResize = createEventSource onResize_

onResize' :: forall message. ToRawEventSource message
onResize' = createRawEventSource onResize__

onOffline :: forall message. ToEventSource message
onOffline = createEventSource onOffline_

onOffline' :: forall message. ToRawEventSource message
onOffline' = createRawEventSource onOffline__

onOnline :: forall message. ToEventSource message
onOnline = createEventSource onOnline_

onOnline' :: forall message. ToRawEventSource message
onOnline' = createRawEventSource onOnline__

onLoad :: forall message. ToEventSource message
onLoad = createEventSource onLoad_

onLoad' :: forall message. ToRawEventSource message
onLoad' = createRawEventSource onLoad__

onUnload :: forall message. ToEventSource message
onUnload = createEventSource onUnload_

onUnload' :: forall message. ToRawEventSource message
onUnload' = createRawEventSource onUnload__

