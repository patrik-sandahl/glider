module Math.Plane exposing
    ( Plane
    , init
    , intersect
    )

import Math.Ray as Ray exposing (Ray)
import Math.Vector3 as V3 exposing (Vec3)


{-| Plane data structure.
-}
type alias Plane =
    { distance : Float
    , normal : Vec3
    }


{-| Initialize a plane.
-}
init : Float -> Vec3 -> Plane
init distance =
    Plane distance << V3.normalize


intersect : Ray -> Plane -> Maybe Float
intersect ray plane =
    let
        nd =
            V3.dot ray.direction plane.normal

        pn =
            V3.dot ray.origin plane.normal

        t =
            (plane.distance - pn) / nd
    in
    if nd < 0.0 && t >= 0.0 then
        Just t

    else
        Nothing
