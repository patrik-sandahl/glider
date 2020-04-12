module Math.OrientationAxes exposing
    ( OrientationAxes
    , worldOrientation
    )

import Math.Vector3 as V3 exposing (Vec3)


{-| Orientation axes.
-}
type alias OrientationAxes =
    { forward : Vec3
    , right : Vec3
    , up : Vec3
    }


{-| Orientation axes for the world.
-}
worldOrientation : OrientationAxes
worldOrientation =
    { forward = V3.vec3 0.0 0.0 -1.0
    , right = V3.vec3 1.0 0.0 0.0
    , up = V3.vec3 0.0 1.0 0.0
    }
