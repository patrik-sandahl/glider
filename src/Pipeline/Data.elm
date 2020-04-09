module Pipeline.Data exposing
    ( Uniforms
    , Vertex
    )

import Math.Vector2 exposing (Vec2)
import Math.Vector3 exposing (Vec3)


{-| Vertex type - just having a position.
-}
type alias Vertex =
    { position : Vec3
    }


{-| Shader uniforms.
-}
type alias Uniforms =
    { resolution : Vec2
    , playTimeMs : Float
    }
