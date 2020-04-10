module Pipeline exposing
    ( Pipe(..)
    , Pipeline
    , init
    , view
    )

import Html exposing (Html)
import Html.Attributes as Attr
import Math.Vector3 as V3
import Navigator exposing (Navigator)
import Pipeline.AspectRatioTestFragmentShader as AspectRatioFragmentShader
import Pipeline.Data exposing (Vertex)
import Pipeline.NavigationTestFragmentShader as NavigationTestFragmentShader
import Pipeline.QuadVertexShader as QuadVertexShader
import Viewport exposing (Viewport)
import WebGL exposing (Mesh)


{-| The pipeline type.
-}
type alias Pipeline =
    { quadMesh : Mesh Vertex
    }


{-| Pipe enumeration.
-}
type Pipe
    = AspectRatioTest
    | NavigationTest


{-| Initialize the pipeline.
-}
init : Pipeline
init =
    { quadMesh = makeQuadMesh
    }


{-| View the pipeline.
-}
view : Pipe -> Viewport -> Float -> Pipeline -> Navigator -> Html msg
view pipe viewport playTimeMs pipeline navigator =
    let
        fragmentShader =
            case pipe of
                AspectRatioTest ->
                    AspectRatioFragmentShader.program

                NavigationTest ->
                    NavigationTestFragmentShader.program
    in
    WebGL.toHtmlWith
        [ WebGL.antialias
        ]
        [ viewport.width |> Attr.width << floor
        , viewport.height |> Attr.height << floor
        , Attr.style "display" "block"
        ]
        [ WebGL.entity
            QuadVertexShader.program
            fragmentShader
            pipeline.quadMesh
            { resolution = Viewport.resolution viewport
            , playTimeMs = playTimeMs
            , cameraEye = navigator.camera.eye
            , cameraForward = navigator.camera.orientationAxes.forward
            , cameraRight = navigator.camera.orientationAxes.right
            , cameraUp = navigator.camera.orientationAxes.up
            , cameraFocalLength = navigator.camera.focalLength
            }
        ]


makeQuadMesh : Mesh Vertex
makeQuadMesh =
    WebGL.triangleStrip
        [ V3.vec3 -1.0 1.0 0.0 |> Vertex
        , V3.vec3 -1.0 -1.0 0.0 |> Vertex
        , V3.vec3 1.0 1.0 0.0 |> Vertex
        , V3.vec3 1.0 -1.0 0.0 |> Vertex
        ]
