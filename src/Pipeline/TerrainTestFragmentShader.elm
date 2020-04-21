module Pipeline.TerrainTestFragmentShader exposing (program)

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
const float HeightScale = 1.0;
const float StepLength = 0.01;
const float SurfaceEpsilon = 0.01;

const int Octaves = 2;

const vec3 LightDir = normalize(vec3(1.0, 1.0, 0.0));

const mat3 m3  = mat3( 0.00,  0.80,  0.60,
                      -0.80,  0.36, -0.48,
                      -0.60, -0.48,  0.64 );
const mat3 m3i = mat3( 0.00, -0.80, -0.60,
                       0.80,  0.36, -0.48,
                       0.60, -0.48,  0.64 );

struct Ray {
    vec3 origin;
    vec3 direction;
};

vec4 fbmd(vec3 x);
vec4 fbmd(vec3 x, float terrainScale, float heightScale);
vec4 noised(vec3 x);

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

vec4 upPlane(float distance)
{
    return vec4(distance, vec3(0.0, 1.0, 0.0));
}

float rayPlaneIntersection(Ray ray, vec4 plane)
{
    float nd = dot(ray.direction, plane.yzw);
    float pn = dot(ray.origin, plane.yzw);

    if (nd < 0.0) {
        float t = (plane.x - pn) / nd;
        return t >= 0.0 ? t : -1.0;
    } else {
        return -1.0;
    }
}

vec3 derivToNormal(vec3 deriv)
{
    vec3 tangent = vec3(1.0, deriv.x, 0.0);
    vec3 bitangent = vec3(0.0, deriv.z, 1.0);
    return normalize(cross(bitangent, tangent));
    //return normalize(vec3(-deriv.x, 1.0, -deriv.z));
}

// Function that directly ray marches the fbm function (very slow). The vec4 is
// vec4(distance, normal) if intersects, otherwise vec4(MaxDistance, vec3(0)).
vec4 rayMarchTerrain(Ray ray)
{
    float d0 = rayPlaneIntersection(ray, upPlane(HeightScale + SurfaceEpsilon));

    if (d0 < 0.0) {
        return vec4(MaxDistance, vec3(0.0));
    }

    // Step along the ray.    
    for (float d = 0.0; d < MaxDistance; d += StepLength) {
        if (d + d0 >= MaxDistance) break;

        vec3 pos = pointAt(ray, d + d0);
        vec4 terrain = fbmd(vec3(pos.x, 1.0, pos.z), 0.3, HeightScale);        
        if (pos.y < terrain.x) {
            return vec4(d0, derivToNormal(terrain.yzw));
        }        
    }

    // No terrain intersection.
    return vec4(MaxDistance, vec3(0.0));
}

void main()
{
    vec2 uv = normalizedUV();
    Ray ray = primaryRay(uv);

    vec4 terrain = rayMarchTerrain(ray);

    vec3 color = vec3(0.0, 0.0, 0.5);
    if (terrain.x < MaxDistance) {
        float diffuse = dot(terrain.yzw, LightDir);
        color = vec3(diffuse);
    }

    gl_FragColor = vec4(color, 1.0);
}

// From IQ.
vec4 fbmd(vec3 x)
{
    float f = 2.0;
    float s = 0.5;
    float a = 0.0;
    float b = 0.5;
    vec3  d = vec3(0.0);
    mat3  m = mat3(1.0,0.0,0.0,
                   0.0,1.0,0.0,
                   0.0,0.0,1.0);
    for( int i = 0; i < Octaves; ++i )
    {
        vec4 n = noised(x);
        a += b*n.x;          // accumulate values		
        d += b*m*n.yzw;      // accumulate derivatives
        b *= s;
        x = f*m3*x;
        m = f*m3i*m;
    }
	return vec4( a, d );
}

vec4 fbmd(vec3 x, float terrainScale, float heightScale)
{
    return fbmd(x * terrainScale) * heightScale;
}

// From IQ.
float hash1(float n)
{
    return fract(n * 17.0 * fract(n * 0.3183099));
}
// From IQ.
vec4 noised(vec3 x)
{
    vec3 p = floor(x);
    vec3 w = fract(x);
    
    vec3 u = w*w*w*(w*(w*6.0-15.0)+10.0);
    vec3 du = 30.0*w*w*(w*(w-2.0)+1.0);
    float n = p.x + 317.0*p.y + 157.0*p.z;
    
    float a = hash1(n+0.0);
    float b = hash1(n+1.0);
    float c = hash1(n+317.0);
    float d = hash1(n+318.0);
    float e = hash1(n+157.0);
	float f = hash1(n+158.0);
    float g = hash1(n+474.0);
    float h = hash1(n+475.0);
    float k0 =   a;
    float k1 =   b - a;
    float k2 =   c - a;
    float k3 =   e - a;
    float k4 =   a - b - c + d;
    float k5 =   a - c - e + g;
    float k6 =   a - b - e + f;
    float k7 = - a + b + c - d + e - f - g + h;
    return vec4( -1.0+2.0*(k0 + k1*u.x + k2*u.y + k3*u.z + k4*u.x*u.y + k5*u.y*u.z + k6*u.z*u.x + k7*u.x*u.y*u.z), 
                      2.0* du * vec3( k1 + k4*u.y + k6*u.z + k7*u.y*u.z,
                                      k2 + k5*u.z + k4*u.x + k7*u.z*u.x,
                                      k3 + k6*u.x + k5*u.y + k7*u.x*u.y ) );
}

    |]
