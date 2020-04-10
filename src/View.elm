module View exposing (view)

import Data exposing (Model, Msg)
import Html exposing (Html)
import Pipeline


{-| The application view function.
-}
view : Model -> Html Msg
view model =
    Html.div
        []
        [ Pipeline.view 
            model.currentPipe
            model.viewport
            model.playTimeMs
            model.pipeline
            model.navigator
        ]
