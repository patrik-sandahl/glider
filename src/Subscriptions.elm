module Subscriptions exposing (subscribe)

import Browser.Events as Events
import Data exposing (Model, Msg(..))


{-| Application subscriptions.
-}
subscribe : Model -> Sub Msg
subscribe model =
    Events.onAnimationFrameDelta AnimateFrameDelta
