Shader "Chimp/Patterns/Checker"
{
    Properties
    {
        _Size("Size", Float) = 5
        _MainColor("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _SecondaryColor("Secondary Color", Color) = (0.0, 0.0, 0.0, 1.0)
        [Toggle(_SPHERICAL)] _Spherical("Spherical Projection", Float) = 0
    }

    SubShader
    {
        Pass
        {
            HLSLPROGRAM

            #pragma target 3.5

            #pragma vertex Vertex
            #pragma fragment Fragment
            #pragma shader_feature _SPHERICAL

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

            CBUFFER_START(UnityPerMaterial)
            float _Size;
            float4 _MainColor;
            float4 _SecondaryColor;
            CBUFFER_END

            struct Attributes
            {
                float3 positionOS : POSITION;
                float2 baseUV : TEXCOORD0;
#if _SPHERICAL
                float3 normal : NORMAL;
#endif
            };

            struct Varyings
            {
                float4 positionCS : SV_Position;
                float2 baseUV : VAR_BASE_UV;
#if _SPHERICAL
                float3 normalDir : TEXCOORD1;
#endif
            };

            Varyings Vertex(Attributes input)
            {
                Varyings output;

                float3 positionWS = TransformObjectToWorld(input.positionOS);
                output.positionCS = TransformWorldToHClip(positionWS);
                output.baseUV = input.baseUV;
#if _SPHERICAL
                output.normalDir = TransformWorldToObjectNormal(input.normal);
#endif
                return output;
            }

            float4 Fragment(Varyings input) : SV_TARGET
            {
#if _SPHERICAL
                float2 customUV = getRadiualUV(input.normalDir);
                float2 uv = customUV * 2.0 - 1.0;
#else
                float2 uv = input.baseUV * 2.0 - 1.0;
#endif
                float2 screen = floor(uv * _Size);
                float checker = mod(screen.x + screen.y, 2.0);

                return (checker <= 0.0) ? _MainColor : _SecondaryColor;
            }

            ENDHLSL
        }
    }
}
