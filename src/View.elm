module View exposing (view)

import Data exposing (Model, Msg)
import Html exposing (Attribute, Html)
import Html.Attributes as Attr
import Pipeline


{-| The application view function.
-}
view : Model -> Html Msg
view model =
    Html.div
        [ cursorStyle model
        ]
        [ Pipeline.view
            model.currentPipe
            model.viewport
            model.playTimeMs
            model.pipeline
            model.navigator
        ]


cursorStyle : Model -> Attribute Msg
cursorStyle model =
    case model.mousePlaneIntersection of
        Just _ ->
            if model.mouseButtonDown then
                Attr.style "cursor" "grabbing"

            else
                Attr.style "cursor" "move"

        Nothing ->
            Attr.style "cursor" "default"
