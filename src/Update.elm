module Update exposing
    ( init
    , update
    )

import Browser.Dom as Dom
import Data exposing (Model, Msg(..))
import Math.Plane as Plane
import Math.Vector2 as V2 exposing (Vec2)
import Math.Vector3 as V3
import Navigator
import Navigator.Camera as Camera
import Pipeline exposing (Pipe(..))
import Task
import Viewport


{-| Application init function.
-}
init : () -> ( Model, Cmd Msg )
init _ =
    ( { viewport = Viewport.init 0 0
      , mousePos = V2.vec2 0.0 0.0
      , mousePlaneIntersection = Nothing
      , mouseButtonDown = False
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

        NewMousePos mousePos ->
            let
                normalizedMousePos =
                    Viewport.normalizedUV mousePos model.viewport

                mouseRay =
                    Debug.log "> " <| Camera.uvToRay normalizedMousePos model.navigator.camera

                zeroPlane =
                    V3.vec3 0.0 1.0 0.0 |> Plane.init 0.0

                mousePlaneIntersection =
                    Debug.log ">> " <| Plane.intersect mouseRay zeroPlane
            in
            ( { model
                | mousePos = normalizedMousePos
                , mousePlaneIntersection = mousePlaneIntersection
              }
            , Cmd.none
            )

        MouseButtonDown ->
            ( { model | mouseButtonDown = True }
            , Cmd.none
            )

        MouseButtonUp ->
            ( { model | mouseButtonDown = False }
            , Cmd.none
            )

        Ignore ->
            ( model
            , Cmd.none
            )


fetchViewportResolution : Cmd Msg
fetchViewportResolution =
    Task.perform
        (\viewport ->
            Viewport.init viewport.viewport.width viewport.viewport.height |> NewViewportResolution
        )
        Dom.getViewport
