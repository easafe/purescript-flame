module Flame.Signal.Window where

import Flame.Signal.Signal

foreign import onError_ :: forall message. ToEventSignal_ message
foreign import onError__ :: forall message. ToRawEventSignal_ message
foreign import onResize_ :: forall message. ToEventSignal_ message
foreign import onResize__ :: forall message. ToRawEventSignal_ message
foreign import onOffline_ :: forall message. ToEventSignal_ message
foreign import onOffline__ :: forall message. ToRawEventSignal_ message
foreign import onOnline_ :: forall message. ToEventSignal_ message
foreign import onOnline__ :: forall message. ToRawEventSignal_ message
foreign import onLoad_ :: forall message. ToEventSignal_ message
foreign import onLoad__ :: forall message. ToRawEventSignal_ message
foreign import onUnload_ :: forall message. ToEventSignal_ message
foreign import onUnload__ :: forall message. ToRawEventSignal_ message

onError :: forall message. ToEventSignal message
onError = createEventSignal onError_

onError' :: forall message. ToRawEventSignal message
onError' = createRawEventSignal onError__

onResize :: forall message. ToEventSignal message
onResize = createEventSignal onResize_

onResize' :: forall message. ToRawEventSignal message
onResize' = createRawEventSignal onResize__

onOffline :: forall message. ToEventSignal message
onOffline = createEventSignal onOffline_

onOffline' :: forall message. ToRawEventSignal message
onOffline' = createRawEventSignal onOffline__

onOnline :: forall message. ToEventSignal message
onOnline = createEventSignal onOnline_

onOnline' :: forall message. ToRawEventSignal message
onOnline' = createRawEventSignal onOnline__

onLoad :: forall message. ToEventSignal message
onLoad = createEventSignal onLoad_

onLoad' :: forall message. ToRawEventSignal message
onLoad' = createRawEventSignal onLoad__

onUnload :: forall message. ToEventSignal message
onUnload = createEventSignal onUnload_

onUnload' :: forall message. ToRawEventSignal message
onUnload' = createRawEventSignal onUnload__

