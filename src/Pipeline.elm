module Pipeline exposing
    ( Pipe(..)
    , Pipeline
    , init
    , view
    )

import Html exposing (Html)
import Html.Attributes as Attr
import Math.Vector3 as V3
import Pipeline.AspectRatioTestFragmentShader as AspectRatioFragmentShader
import Pipeline.Data exposing (Vertex)
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


{-| Initialize the pipeline.
-}
init : Pipeline
init =
    { quadMesh = makeQuadMesh
    }


{-| View the pipeline.
-}
view : Pipe -> Viewport -> Float -> Pipeline -> Html msg
view pipe viewport playTimeMs pipeline =
    let
        fragmentShader =
            case pipe of
                AspectRatioTest ->
                    AspectRatioFragmentShader.program
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
