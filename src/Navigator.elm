module Navigator exposing
    ( Navigator
    , camera
    , init
    )

import Math.Vector3 as V3
import Navigator.Camera as Camera exposing (Camera)


{-| Navigator type .
-}
type alias Navigator =
    { camera : Camera
    }


{-| Initialize the navigator.
-}
init : Navigator
init =
    { camera = Camera.init <| V3.vec3 0.0 5.0 0.0
    }


{-| Get the navigator's camera.
-}
camera : Navigator -> Camera
camera navigator =
    navigator.camera
