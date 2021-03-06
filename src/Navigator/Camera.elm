module Navigator.Camera exposing
    ( Camera
    , init
    , pan
    , rotate
    , uvToRay
    )

import Math.OrientationAxes as OrientationAxes exposing (OrientationAxes)
import Math.Quaternion as Quaternion
import Math.Ray as Ray exposing (Ray)
import Math.Vector2 as V2 exposing (Vec2)
import Math.Vector3 as V3 exposing (Vec3)


{-| Camera type.
-}
type alias Camera =
    { eye : Vec3
    , focalLength : Float
    , orientationAxes : OrientationAxes
    }


{-| Initialize the camera at the given position, looking in positive x direction.
-}
init : Vec3 -> Camera
init eye =
    { eye = eye
    , focalLength = 1.0
    , orientationAxes = OrientationAxes.worldOrientation
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


{-| Panning the camera using screen space information (in uv coordinates). The relAngle
is telling the angle of the mouse move vector relative to screen up, and the screenDist
is the length of the mouse move. Panning is implemented by calculating a direction relative
to the current forward direction, and move the eye in that direction. Speed of the move
is related to the hight of the camera.
-}
pan : Float -> Float -> Camera -> Camera
pan relAngle screenDist camera =
    let
        quat =
            Quaternion.axisAngle OrientationAxes.worldUpAxis -relAngle

        forward =
            V3.cross OrientationAxes.worldUpAxis camera.orientationAxes.right

        moveDir =
            Quaternion.rotate quat forward
                |> V3.normalize
                |> V3.negate

        eye =
            V3.scale (screenDist * V3.getY camera.eye) moveDir
                |> V3.add camera.eye
    in
    { camera | eye = eye }


rotate : Vec3 -> Vec2 -> Camera -> Camera
rotate intersectPos mouseDir camera =
    let
        rotAngle =
            2.0 * pi * V2.getX mouseDir

        mousePitch =
            pi * V2.getY mouseDir

        currPitchAngle =
            V3.dot camera.orientationAxes.forward OrientationAxes.worldUpAxis
                |> acos

        clampedPitchAngle =
            mousePitch + currPitchAngle |> clamp maxPitchUp maxPitchDown

        pitchAngle =
            clampedPitchAngle - currPitchAngle

        iPosToEye =
            V3.sub camera.eye intersectPos

        rotQ =
            Quaternion.axisAngle OrientationAxes.worldUpAxis rotAngle

        rotAxes =
            Quaternion.rotateAxes rotQ camera.orientationAxes

        pitchQ =
            Quaternion.axisAngle rotAxes.right -pitchAngle
    in
    { camera
        | eye =
            Quaternion.rotate rotQ (V3.normalize iPosToEye)
                |> V3.scale (V3.length iPosToEye)
                |> V3.add intersectPos
        , orientationAxes = Quaternion.rotateAxes pitchQ rotAxes
    }


maxPitchDown : Float
maxPitchDown =
    pi * (3.0 / 4.0)


maxPitchUp : Float
maxPitchUp =
    pi * (1.0 / 4.0)
