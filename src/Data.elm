module Data exposing
    ( Key(..)
    , Model
    , Msg(..)
    )

import Math.Vector2 exposing (Vec2)
import Math.Vector3 exposing (Vec3)
import Navigator exposing (Navigator)
import Pipeline exposing (Pipe, Pipeline)
import Viewport exposing (Viewport)


{-| Application main model.
-}
type alias Model =
    { viewport : Viewport
    , mousePos : Vec2
    , mousePlaneIntersection : Maybe Vec3
    , mouseButtonDown : Bool
    , navKeyDown : Maybe Key
    , showHud : Bool
    , playTimeMs : Float
    , latestFrameTimes : List Float
    , pipeline : Pipeline
    , currentPipe : Pipe
    , navigator : Navigator
    }


{-| Application message type.
-}
type Msg
    = AnimateFrameDelta Float
    | NewViewportResolution Viewport
    | NewMousePos Vec2
    | MouseButtonDown
    | MouseButtonUp
    | KeyDown Key
    | KeyUp Key
    | Ignore


{-| Symbolic keys.
-}
type Key
    = Pipe0
    | Pipe1
    | Pipe2
    | NavRotate
    | Hud
