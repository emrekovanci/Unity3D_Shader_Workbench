Shader "Chimp/ZTest"
{
    Properties
    {
        [MainTexture] _BaseMap("Texture", 2D) = "white" { }
        [MainColor] _BaseColor("Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Pass
        {
            Tags { "LightMode" = "UniversalForward" }
            ZTest Less
            // Cull Front

            HLSLPROGRAM

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            #pragma vertex vert
            #pragma fragment frag

            struct Attributes
            {
                float3 positionOS : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);
            float4 _BaseMap_ST;

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.uv = TRANSFORM_TEX(input.uv, _BaseMap);

                return output;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.uv);
                return col;
            }

            ENDHLSL
        }

        Pass
        {
            ZTest Greater

            HLSLPROGRAM

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

            #pragma vertex vert
            #pragma fragment frag

            float4 _BaseColor;

            struct Attributes
            {
                float3 positionOS : POSITION;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
            };

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);

                return output;
            }

            float4 frag(Varyings input) : SV_TARGET
            {
                return _BaseColor;
            }

            ENDHLSL
        }
    }
}
