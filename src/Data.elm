module Data exposing
    ( Key(..)
    , Model
    , Msg(..)
    )

import Math.Vector2 exposing (Vec2)
import Navigator exposing (Navigator)
import Pipeline exposing (Pipe, Pipeline)
import Viewport exposing (Viewport)


{-| Application main model.
-}
type alias Model =
    { viewport : Viewport
    , mousePos : Vec2
    , mousePlaneIntersection : Maybe Float
    , mouseButtonDown : Bool
    , playTimeMs : Float
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
