Shader "Chimp/Patterns/Rainbow"
{
    Properties
    {
        _BaseMap("Texture", 2D) = "white" {}
        _RingRadius("Ring Radius", Float) = 0.1
        _RingThickness("Ring Thickness", Float) = 0.1
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "AlphaTest"
        }

        Blend One Zero
        ZWrite On

        Pass
        {
            HLSLPROGRAM

            #pragma target 3.5

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            struct Attributes
            {
                float3 positionOS : POSITION;
                float2 baseUV : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_Position;
                float2 baseUV : VAR_BASE_UV;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float _RingRadius;
            float _RingThickness;
            CBUFFER_END

            Varyings Vertex(Attributes input)
            {
                Varyings output;

                float3 positionWS = TransformObjectToWorld(input.positionOS);
                output.positionCS = TransformWorldToHClip(positionWS);
                output.baseUV = input.baseUV * _BaseMap_ST.xy + _BaseMap_ST.zw;

                return output;
            }

            #define RAINBOW_COLOR_COUNT 7

            const static float3 rainbowColors[RAINBOW_COLOR_COUNT] =
            {
                float3(0.58, 0.0, 0.82), // violet
                float3(0.33, 0.0, 0.50), // indigo
                float3(0.0, 0.0, 1.0),   // blue
                float3(0.0, 1.0, 0.0),   // green
                float3(1.0, 1.0, 0.0),   // yellow
                float3(1.0, 0.50, 0.0),  // orange
                float3(1.0, 0.0 , 0.0)   // red
            };

            float4 Fragment(Varyings input) : SV_TARGET
            {
                float2 uv = input.baseUV * 2.0 - 1.0;
                float4 sample = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.baseUV);
                float3 color = 0.0;

                float d = distance(uv, float2(0.0, 0.0));
                for (int i = 0; i < RAINBOW_COLOR_COUNT; ++i)
                {
                    float l = step(_RingRadius - _RingThickness, d) - step(_RingRadius, d);
                    color = lerp(color, rainbowColors[i], l);
                    _RingRadius += _RingThickness;
                }

                float3 finalColor = sample.rgb * color;

                // alpha clipping
                float l = length(finalColor);
                if (l <= 0.0)
                {
                    discard;
                }

                return float4(sample.rgb * color, 1.0);
            }

            ENDHLSL
        }
    }
}
