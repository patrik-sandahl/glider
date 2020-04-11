module Subscriptions exposing (subscribe)

import Browser.Events as Events
import Data exposing (Model, Msg(..))
import Json.Decode as Decode
import Math.Vector2 as V2
import Viewport


{-| Application subscriptions.
-}
subscribe : Model -> Sub Msg
subscribe model =
    Sub.batch
        [ Events.onAnimationFrameDelta AnimateFrameDelta
        , Events.onResize newViewportResolution
        , Events.onMouseMove (Decode.map2 newMousePos decodeMouseXPos decodeMouseYPos)
        , Events.onMouseDown mouseButtonDown
        , Events.onMouseUp mouseButtonUp
        , Events.onVisibilityChange
            (\v ->
                if v == Events.Hidden then
                    MouseButtonUp

                else
                    Ignore
            )
        ]


newViewportResolution : Int -> Int -> Msg
newViewportResolution width height =
    Viewport.init (toFloat width) (toFloat height)
        |> NewViewportResolution


newMousePos : Float -> Float -> Msg
newMousePos xPos yPos =
    V2.vec2 xPos yPos
        |> NewMousePos


decodeMouseXPos : Decode.Decoder Float
decodeMouseXPos =
    Decode.field "pageX" Decode.float


decodeMouseYPos : Decode.Decoder Float
decodeMouseYPos =
    Decode.field "pageY" Decode.float


mouseButtonDown : Decode.Decoder Msg
mouseButtonDown =
    Decode.map
        (\v ->
            case v of
                0 ->
                    MouseButtonDown

                _ ->
                    Ignore
        )
        (Decode.field "button" Decode.int)


mouseButtonUp : Decode.Decoder Msg
mouseButtonUp =
    Decode.map
        (\v ->
            case v of
                0 ->
                    MouseButtonUp

                _ ->
                    Ignore
        )
        (Decode.field "button" Decode.int)
