module Data exposing
    ( Model
    , Msg(..)
    )

{-| Application main model.
-}


type alias Model =
    { playTimeMs : Float
    }


{-| Application message type.
-}
type Msg
    = AnimateFrameDelta Float
