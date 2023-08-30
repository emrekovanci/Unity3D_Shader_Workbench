Shader "Chimp/Patterns/Pattern"
{
    Properties
    {
        _Color ("Color", Color) = (1, 1, 1, 1)
        _Size ("Size", Range(0, 1)) = 0.25
        _Offset ("Offset", Range(0, 1)) = 0
        _Zoom ("Zoom", Range(1, 5)) = 2
        _Pivot ("Pivot", Range(0, 1)) = 0.5
    }

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
        }

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Assets/Shaders/ShaderLibrary/Common.hlsl"

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

            CBUFFER_START(UnityPerMaterial)
            float4 _Color;
            float _Size;
            float _Offset;
            float _Zoom;
            float _Pivot;
            CBUFFER_END

            float2 rotate(float2 uv)
            {
                float pivot = _Pivot;

                float cosAngle = _CosTime.w;
                float sinAngle = _SinTime.w;

                float2x2 rotationMatrix = float2x2
                (
                    cosAngle, -sinAngle,
                    sinAngle, cosAngle
                );

                float2 uvPiv = uv - pivot;
                float2 uvRotation = mul(rotationMatrix, uvPiv);
                return uvRotation;
            }

            Varyings vert(Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.uv = rotate(input.uv);

                return output;
            }

            float squareShape(float2 uv)
            {
                float normalizedSize = _Size * 0.5;

                float left = step(normalizedSize, uv.x);
                float bottom = step(normalizedSize, uv.y);
                float up = step(normalizedSize, 1 - uv.y);
                float right = step(normalizedSize, 1 - uv.x);

                return left * bottom * up * right;
            }

            float4 frag(Varyings input) : SV_Target
            {
                input.uv = input.uv * _Zoom - _Offset;

                float square = squareShape(frac(input.uv));
                square = 1.0 - square;

                return _Color * square;
            }

            ENDHLSL
        }
    }
}
