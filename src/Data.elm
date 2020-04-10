module Data exposing
    ( Model
    , Msg(..)
    )

import Navigator exposing (Navigator)
import Pipeline exposing (Pipe, Pipeline)
import Viewport exposing (Viewport)


{-| Application main model.
-}
type alias Model =
    { viewport : Viewport
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
