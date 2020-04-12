module Navigator.Camera exposing
    ( Camera
    , init
    ,  uvToRay
       --, pan

    )

import Math.OrientationAxes as OrientationAxes exposing (OrientationAxes)
import Math.Quaternion as Quat
import Math.Ray as Ray exposing (Ray)
import Math.Vector2 as V2 exposing (Vec2)
import Math.Vector3 as V3 exposing (Vec3)


{-| Camera type.
-}
type alias Camera =
    { eye : Vec3
    , yaw : Float
    , pitch : Float
    , focalLength : Float
    , orientationAxes : OrientationAxes
    }


{-| Initialize the camera at the given position, looking in positive x direction.
-}
init : Vec3 -> Camera
init eye =
    { eye = eye
    , yaw = 0.0
    , pitch = 0.0
    , focalLength = 1.0
    , orientationAxes = orientationAxesFrom 0.0 0.0
    }


{-| Generate a ray for the given UV coordinate.
-}
uvToRay : Vec2 -> Camera -> Ray
uvToRay uv camera =
    let
        center =
            V3.scale camera.focalLength camera.orientationAxes.forward
                |> V3.add camera.eye

        xOffset =
            V3.scale (V2.getX uv) camera.orientationAxes.right

        yOffset =
            V3.scale (V2.getY uv) camera.orientationAxes.up

        point =
            V3.add xOffset yOffset |> V3.add center

        direction =
            V3.sub point camera.eye
    in
    Ray.init camera.eye direction


orientationAxesFrom : Float -> Float -> OrientationAxes
orientationAxesFrom yaw pitch =
    Quat.yawPitchRollAxes yaw pitch 0.0
        OrientationAxes.defaultCameraOrientation
