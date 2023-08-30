Shader "Chimp/Cull"
{
    Properties
    {
        [MainTexture] _BaseMap ("Texture", 2D) = "white" {}
        [Enum(UnityEngine.Rendering.CullMode)] _CullMode("Cull Mode", Float) = 0
    }

    SubShader
    {
        Pass
        {
            // Back, Front, Off
            Cull [_CullMode]

            HLSLPROGRAM

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            #pragma vertex vert
            #pragma fragment frag

            struct Attributes
            {
                float3 positionOS : POSITION;
                float2 baseUV : TEXCOORD0;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float2 baseUV : TEXCOORD0;
            };

            TEXTURE2D(_BaseMap);
            SAMPLER(sampler_BaseMap);

            CBUFFER_START(UnityPerMaterial)
            float4 _BaseMap_ST;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.baseUV = TRANSFORM_TEX(input.baseUV, _BaseMap);

                return output;
            }

            float4 frag(Varyings input) : SV_TARGET
            {
                float4 col = SAMPLE_TEXTURE2D(_BaseMap, sampler_BaseMap, input.baseUV);
                return col;
            }

            ENDHLSL
        }
    }
}
