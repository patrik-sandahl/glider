module Data exposing
    ( Model
    , Msg(..)
    )

import Viewport exposing (Viewport)


{-| Application main model.
-}
type alias Model =
    { viewport : Viewport
    , playTimeMs : Float
    }


{-| Application message type.
-}
type Msg
    = AnimateFrameDelta Float
    | NewViewportResolution Viewport
