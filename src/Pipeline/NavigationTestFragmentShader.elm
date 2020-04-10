module Pipeline.NavigationTestFragmentShader exposing (program)

import Pipeline.Data exposing (Uniforms)
import WebGL exposing (Shader)

program : Shader {} Uniforms {}
program =
    [glsl|

precision highp float;

uniform vec2 resolution;
uniform float playTimeMs;

uniform vec3 cameraEye;
uniform vec3 cameraForward;
uniform vec3 cameraRight;
uniform vec3 cameraUp;
uniform float cameraFocalLength;

const float MaxDistance = 100.0;
const float SurfaceDistance = 0.001;

struct Ray {
    vec3 origin;
    vec3 direction;
};

Ray makeRay(vec3 origin, vec3 direction)
{
    return Ray(origin, normalize(direction));
}

vec3 pointAt(Ray ray, float distance)
{
    return ray.origin + ray.direction * distance;
}

Ray primaryRay(vec2 uv)
{
    vec3 center = cameraEye + cameraForward * cameraFocalLength;
    vec3 point = center + cameraRight * uv.x + cameraUp * uv.y;

    return makeRay(cameraEye, point - cameraEye);
}

vec2 normalizedUV()
{
    return (gl_FragCoord.xy - 0.5 * resolution) / min(resolution.x, resolution.y);
}

float intersectScene(vec3 pos)
{
    // Just a plane at height zero.
    return pos.y;
}

float rayMarch(Ray ray)
{
    float d0 = 0.0;
    for (int i = 0; i < 100; ++i) {
        vec3 pos = pointAt(ray, d0);
        float d = intersectScene(pos);
        d0 += d;
        if (d < SurfaceDistance || d0 > MaxDistance)
            break;
    }

    return d0;
}

void main()
{
    vec2 uv = normalizedUV();
    Ray ray = primaryRay(uv);

    vec3 color = vec3(0.0);
    float d = rayMarch(ray);
    if (d < MaxDistance) {
        vec3 pos = pointAt(ray, d);
        color = vec3(fract(pos.x), fract(pos.z), 0.0);
    }

    gl_FragColor = vec4(color, 1.0);
}

    |]