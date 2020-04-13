module Math.OrientationAxes exposing
    ( OrientationAxes
    , worldForwardAxis
    , worldOrientation
    , worldRightAxis
    , worldUpAxis
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
    { forward = worldForwardAxis
    , right = worldRightAxis
    , up = worldUpAxis
    }


{-| World forward.
-}
worldForwardAxis : Vec3
worldForwardAxis =
    V3.vec3 0.0 0.0 -1.0


{-| World right.
-}
worldRightAxis : Vec3
worldRightAxis =
    V3.vec3 1.0 0.0 0.0


{-| World up.
-}
worldUpAxis : Vec3
worldUpAxis =
    V3.vec3 0.0 1.0 0.0
