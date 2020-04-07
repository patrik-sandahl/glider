module View exposing (view)

import Data exposing (Model, Msg)
import Html exposing (Html)


{-| The application view function.
-}
view : Model -> Html Msg
view model =
    Html.div
        []
        [ String.fromFloat model.playTimeMs |> Html.text
        ]
