Shader "Chimp/VFX/Rim"
{
    Properties
    {
        _Color ("Rim Color", Color) = (1, 1, 1, 1)
        _Rim ("Rim Effect", Range(0, 1)) = 1
    }

    SubShader
    {
        Pass
        {
            Tags
            {
                "Queue" = "Transparent"
            }

            ZWrite Off
            Blend One One // Additive

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
            };

            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float3 normalWS : NORMAL;
                float3 uv : TEXCOORD0;
            };

            CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            float _Rim;
            CBUFFER_END

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.normalWS = TransformObjectToWorldNormal(input.normalOS);
                output.uv = normalize(_WorldSpaceCameraPos - TransformObjectToWorld(input.positionOS));

                return output;
            }

            float rimEffect(float3 uv, float3 normal)
            {
                float rim = (1 - abs(dot(uv, normal))) * _Rim;
                return rim;
            }

            float4 frag(Varyings input) : SV_Target
            {
                float rimColor = rimEffect(input.uv, input.normalWS);
                return _Color * rimColor * rimColor;
            }

            ENDHLSL
        }
    }
}
