module Navigator.Data exposing (OrientationAxes)

import Math.Vector3 exposing (Vec3)


{-| Camera orientation.
-}
type alias OrientationAxes =
    { forward : Vec3
    , right : Vec3
    , up : Vec3
    }
