module View exposing (view)

import Data exposing (Model, Msg)
import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Navigator
import Pipeline


{-| The application view function.
-}
view : Model -> Html Msg
view model =
    Html.div
        [ cursorStyle model
        ]
        [ viewHud model
        , Pipeline.view
            model.currentPipe
            model.viewport
            model.playTimeMs
            model.pipeline
            model.navigator
        ]

viewHud : Model -> Html Msg
viewHud model =
  Html.div
        [ Attr.style "display" "inline-block"
        , Attr.style "position" "fixed"
        , Attr.style "left" "10px"
        , Attr.style "top" "10px"
        , Attr.style "font-family" "sans-serif"
        , Attr.style "font-size" "16px"
        , Attr.style "color" "white"
        , Attr.style "z-index" "1"
        , Attr.style "visibility" <|
            if model.showHud then
                "visible"

            else
                "hidden"
        ]
        [ let fps = String.fromInt (calcFps model.latestFrameTimes |> round) ++ " FPS"
          in fps |> Html.text
        ]


cursorStyle : Model -> Attribute Msg
cursorStyle model =
    if Navigator.isNavigating model.navigator then
        Attr.style "cursor" "grabbing"

    else
        case model.mousePlaneIntersection of
            Just _ ->
                Attr.style "cursor" "move"

            Nothing ->
                Attr.style "cursor" "default"

calcFps : List Float -> Float
calcFps latestFrameTimes =
    if not (List.isEmpty latestFrameTimes) then
        let
            avg =
                List.sum latestFrameTimes / toFloat (List.length latestFrameTimes)
        in
        if avg /= 0.0 then
            1000.0 / avg

        else
            0.0

    else
        0.0
