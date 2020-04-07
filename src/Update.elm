module Update exposing
    ( init
    , update
    )

import Data exposing (Model, Msg(..))


{-| Application init function.
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( { playTimeMs = 0 }
    , Cmd.none
    )


{-| Application update function.
-}
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AnimateFrameDelta deltaTime ->
            ( { model | playTimeMs = model.playTimeMs + deltaTime }
            , Cmd.none 
            )
