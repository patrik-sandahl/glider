module Navigator exposing
    ( Navigator
    , beginPanning
    , camera
    , endNavigation
    , init
    , isNavigating
    , navigateTo
    )

import Math.Vector2 as V2 exposing (Vec2)
import Math.Vector3 as V3
import Navigator.Camera as Camera exposing (Camera)


{-| Navigation mode.
-}
type NavigationMode
    = Panning Vec2


{-| Navigator type .
-}
type alias Navigator =
    { camera : Camera
    , navigationMode : Maybe NavigationMode
    }


{-| Initialize the navigator.
-}
init : Navigator
init =
    { camera = Camera.init <| V3.vec3 0.0 5.0 0.0
    , navigationMode = Nothing
    }


{-| Get the navigator's camera.
-}
camera : Navigator -> Camera
camera navigator =
    navigator.camera


isNavigating : Navigator -> Bool
isNavigating navigator =
    case navigator.navigationMode of
        Just _ ->
            True

        Nothing ->
            False


beginPanning : Vec2 -> Navigator -> Navigator
beginPanning uv navigator =
    { navigator | navigationMode = Panning uv |> Just }


navigateTo : Vec2 -> Navigator -> Navigator
navigateTo uvTo navigator =
    case navigator.navigationMode of
        Just mode ->
            case mode of
                Panning uvFrom ->
                    panTo uvFrom uvTo navigator

        Nothing ->
            navigator


endNavigation : Navigator -> Navigator
endNavigation navigator =
    { navigator | navigationMode = Nothing }


panTo : Vec2 -> Vec2 -> Navigator -> Navigator
panTo uvFrom uvTo navigator =
    let
        mouseDir =
            uvMouseDir uvFrom uvTo

        relAngle =
            uvMouseDirRelAngle mouseDir
    in
    { navigator
        | navigationMode = Panning uvTo |> Just
        , camera = Camera.pan relAngle (V2.length mouseDir) navigator.camera
    }


uvMouseDir : Vec2 -> Vec2 -> Vec2
uvMouseDir from to =
    V2.sub to from


uvMouseDirRelAngle : Vec2 -> Float
uvMouseDirRelAngle dir =
    atan2 (V2.getX dir) (V2.getY dir)
