Shader "Chimp/NormalVisualization"
{
    Properties
    {

    }

    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
            "RenderPipeline" = "UniversalPipeline"
        }

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normal : NORMAL;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.normal = TransformObjectToWorldNormal(input.normal);

                return output;
            }

            float4 frag(Varyings input) : SV_TARGET
            {
                // convert normals from [-1, 1] to [0, 1]
                return float4(input.normal * 0.5 + 0.5, 1.0);
            }

            ENDHLSL
        }
    }
}
