module Subscriptions exposing (subscribe)

import Browser.Events as Events
import Data exposing (Model, Msg(..))
import Viewport


{-| Application subscriptions.
-}
subscribe : Model -> Sub Msg
subscribe model =
    Sub.batch
        [ Events.onAnimationFrameDelta AnimateFrameDelta
        , Events.onResize grabSize
        ]


grabSize : Int -> Int -> Msg
grabSize width height =
    Viewport.init (toFloat width) (toFloat height)
        |> NewViewportResolution
