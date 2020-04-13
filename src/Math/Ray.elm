module Math.Ray exposing
    ( Ray
    , init
    , pointAt
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


{-| Calculate the point at the given distance along the ray.
-}
pointAt : Float -> Ray -> Vec3
pointAt distance ray =
    V3.scale distance ray.direction
        |> V3.add ray.origin
