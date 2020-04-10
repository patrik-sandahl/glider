module Navigator.Camera exposing
    ( Camera
    , init
    )

import Math.Vector3 as V3 exposing (Vec3)
import Navigator.Data exposing (OrientationAxes)


{-| Camera type.
-}
type alias Camera =
    { eye : Vec3
    , heading : Float
    , pitch : Float
    , focalLength : Float
    , orientationAxes : OrientationAxes
    }


{-| Initialize the camera at the given position, looking in positive x direction.
-}
init : Vec3 -> Camera
init eye =
    { eye = eye
    , heading = 0.0
    , pitch = 0.0
    , focalLength = 1.0
    , orientationAxes = orientationAxesFrom 0.0 0.0
    }


orientationAxesFrom : Float -> Float -> OrientationAxes
orientationAxesFrom heading pitch =
    { forward = V3.vec3 1.0 0.0 0.0
    , right = V3.vec3 0.0 0.0 1.0
    , up = V3.vec3 0.0 1.0 0.0
    }
