module Update exposing
    ( init
    , update
    )

import Browser.Dom as Dom
import Data exposing (Model, Msg(..))
import Navigator
import Pipeline exposing (Pipe(..))
import Task
import Viewport


{-| Application init function.
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( { viewport = Viewport.init 0 0
      , playTimeMs = 0.0
      , pipeline = Pipeline.init
      , currentPipe = NavigationTest
      , navigator = Navigator.init
      }
    , fetchViewportResolution
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

        NewViewportResolution viewport ->
            ( { model | viewport = viewport }
            , Cmd.none
            )


fetchViewportResolution : Cmd Msg
fetchViewportResolution =
    Task.perform
        (\viewport ->
            Viewport.init viewport.viewport.width viewport.viewport.height |> NewViewportResolution
        )
        Dom.getViewport
