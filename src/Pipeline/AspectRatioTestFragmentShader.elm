module Pipeline.AspectRatioTestFragmentShader exposing (program)

import Pipeline.Data exposing (Uniforms)
import WebGL exposing (Shader)


program : Shader {} Uniforms {}
program =
    [glsl|

precision highp float;

uniform vec2 resolution;
uniform float playTimeMs;

vec2 normalizedUV()
{
    return (gl_FragCoord.xy - 0.5 * resolution) / min(resolution.x, resolution.y);
}

void main()
{
    vec2 uv = fract(normalizedUV() * 10.0);

    vec3 color = vec3(uv.x, uv.y, 0.0);
    gl_FragColor = vec4(color, 1.0);
}

    |]
