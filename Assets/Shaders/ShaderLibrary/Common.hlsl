#ifndef CHIMP_COMMON_INCLUDED
#define CHIMP_COMMON_INCLUDED

// Note: "Common.hlsl" must be included before "Inputs.hlsl"
// TEXTURE2D
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"

#include "Inputs.hlsl"

// https://iquilezles.org/articles/palettes/
float3 palette(float t)
{
    float3 a = 0.5;
    float3 b = 0.5;
    float3 c = 1.0;
    float3 d = float3(0.263, 0.416, 0.557);

    return a + b * cos(6.28318 * (c * t + d));
}

float mod(float x, float y)
{
    return (x - y * floor(x / y));
}

// https://gamedev.stackexchange.com/questions/197931/how-can-i-correctly-map-a-texture-onto-a-sphere
float2 getRadiualUV(float3 normal)
{
    float3 direction = normalize(normal);
    float longitude = 0.5 - atan2(direction.z, direction.x) / (2.0f * PI);
    float latitude = 0.5 + asin(direction.y) / PI;
    return float2(longitude, latitude);
}

float4 computeScreenPos(float4 positionCS)
{
    float4 o = positionCS * 0.5f;
    o.xy = float2(o.x, o.y * _ProjectionParams.x) + o.w;
    o.zw = positionCS.zw;
    return o;
}

// normalizes an input value, between the minimum and maximum values in the given input range inMinMax
// and scales this normalized value between the minimum and maximum values in the output range outMinMax
float remap(float value, float2 inMinMax, float2 outMinMax)
{
    return ((value - inMinMax.x) / (inMinMax.y - inMinMax.x)) * (outMinMax.y - outMinMax.x) + outMinMax.x;
}

// Note: "Input.hlsls" must be included before "SpaceTransforms.hlsl"
// TransformObjectToWorld, TransformWorldToHClip
#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/SpaceTransforms.hlsl"

#endif
