module Math.Ray exposing
    ( Ray
    , init
    )

import Math.Vector3 as V3 exposing (Vec3)


{-| Ray data type.
-}
type alias Ray =
    { origin : Vec3
    , direction : Vec3
    }


{-| Initialize a ray, the direction will always be normalized.
-}
init : Vec3 -> Vec3 -> Ray
init origin =
    Ray origin << V3.normalize
