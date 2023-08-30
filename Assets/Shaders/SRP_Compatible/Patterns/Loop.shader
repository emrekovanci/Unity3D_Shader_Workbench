Shader "Chimp/Patterns/Loop"
{
    Properties
    {
        _BaseMap("Texture", 2D) = "white" { }
        _Frequency("Frequency", Float) = 8
        _Speed("Speed", Float) = 1
        _RingThickness("RingThickness", Range(0.0, 1.0)) = 0.1
    }

    SubShader
    {
        Pass
        {
            HLSLPROGRAM

            #pragma target 3.5

            #pragma vertex Vertex
            #pragma fragment Fragment

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            float _Frequency;
            float _Speed;
            float _RingThickness;
            CBUFFER_END

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

            Varyings Vertex(Attributes input)
            {
                Varyings output;

                float3 positionWS = TransformObjectToWorld(input.positionOS);
                output.positionCS = TransformWorldToHClip(positionWS);
                output.baseUV = input.baseUV * _BaseMap_ST.xy + _BaseMap_ST.zw;

                return output;
            }

            float4 Fragment(Varyings input) : SV_TARGET
            {
                float2 uv = input.baseUV * 2.0 - 1.0;
                float4 sample = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.baseUV);

                float d = length(uv);
                float3 color = palette(d);

                d = sin(d * _Frequency + _Time.y * _Speed) / _Frequency;
                d = abs(d);
                d = smoothstep(_RingThickness / _Frequency, (_RingThickness / _Frequency) + 0.01, d);
                color *= d;

                return float4(sample.rgb * color, 1.0);
            }

            ENDHLSL
        }
    }
}
