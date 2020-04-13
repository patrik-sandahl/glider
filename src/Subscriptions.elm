module Subscriptions exposing (subscribe)

import Browser.Events as Events
import Data exposing (Key(..), Model, Msg(..))
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
        , Events.onKeyDown keyDown
        , Events.onKeyUp keyUp
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
        (mouseButtonToMsg MouseButtonDown)
        (Decode.field "button" Decode.int)


mouseButtonUp : Decode.Decoder Msg
mouseButtonUp =
    Decode.map
        (mouseButtonToMsg MouseButtonUp)
        (Decode.field "button" Decode.int)


mouseButtonToMsg : Msg -> Int -> Msg
mouseButtonToMsg msg v =
    case v of
        0 ->
            msg

        _ ->
            Ignore


keyDown : Decode.Decoder Msg
keyDown =
    Decode.map
        (keyToMsg KeyDown)
        (Decode.field "key" Decode.string)

keyUp : Decode.Decoder Msg
keyUp =
    Decode.map
        (keyToMsg KeyUp)
        (Decode.field "key" Decode.string)

keyToMsg : (Key -> Msg) -> String -> Msg
keyToMsg msg str =
    case str of
        "1" ->
            msg Pipe0

        "2" ->
            msg Pipe1

        _ ->
            Ignore
