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

void main()
{
    vec2 uv = normalizedUV();
    gl_FragColor = vec4(uv.x + 0.5, uv.y + 0.5, 0.0, 1.0);
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
    for( int i=0; i<8; i++ )
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
