Shader "Chimp/VFX/Magma"
{
    Properties
    {
        _RockTex ("Rock Texture", 2D) = "white" {}
        _MagmaTex ("Magma Texture", 2D) = "white" {}
        _DistTex ("Distortion Texture", 2D) = "white" {}
        [Space(10)]
        _DistValue ("Distortion Value", Range(2, 10)) = 3
        _DistSpeed ("Distortion Speed", Range(-0.4, 0.4)) = 0.1
        [Space(10)]
        _WaveSpeed ("Wave Speed", Range(0, 5)) = 1
        _WaveFrequency ("Wave Frequency", Range(0, 5)) = 1
        _WaveAmplitude ("Wave Amplitude", Range(0, 1)) = 0.2
    }

    SubShader
    {
        // Magma Pass
        Pass
        {
            Tags
            {
                "LightMode" = "SRPDefaultUnlit"
            }

            HLSLPROGRAM

            #pragma vertex vert
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"

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

            TEXTURE2D(_MagmaTex);
            SAMPLER(sampler_MagmaTex);
            float4 _MagmaTex_ST;

            TEXTURE2D(_DistTex);
            SAMPLER(sampler_DistTex);
            float4 _DistTex_ST;

            float _DistValue;
            float _DistSpeed;

            float _WaveSpeed;
            float _WaveFrequency;
            float _WaveAmplitude;

            Varyings vert (Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.positionCS.y += sin((input.positionOS.z * (_Time.y * _WaveSpeed)) * _WaveFrequency) * _WaveAmplitude;
                output.positionCS.y += cos((input.positionOS.x * (_Time.y * _WaveSpeed)) * _WaveFrequency) * _WaveAmplitude;

                output.uv = TRANSFORM_TEX(input.uv, _MagmaTex);

                return output;
            }

            float4 frag (Varyings input) : SV_Target
            {
                // distortion texture is grayscale
                // we need only r channel
                float distortion = SAMPLE_TEXTURE2D(_DistTex, sampler_DistTex, input.uv + (_Time * _DistSpeed));
                input.uv += distortion / _DistValue;

                float4 col = SAMPLE_TEXTURE2D(_MagmaTex, sampler_MagmaTex, input.uv);
                return col;
            }

            ENDHLSL
        }

        // Rock Pass
        Pass
        {
            Tags
            {
                "LightMode" = "UniversalForward"
                "Queue" = "Transparent"
            }

            Blend SrcAlpha OneMinusSrcAlpha

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

            TEXTURE2D(_RockTex);
            SAMPLER(sampler_RockTex);
            float4 _RockTex_ST;

            float _WaveSpeed;
            float _WaveFrequency;
            float _WaveAmplitude;

            Varyings vert (Attributes input)
            {
                Varyings output;
                output.positionCS = TransformObjectToHClip(input.positionOS);
                output.positionCS.y += sin((input.positionOS.z * (_Time.y * _WaveSpeed)) * _WaveFrequency) * _WaveAmplitude;
                output.positionCS.y += cos((input.positionOS.x * (_Time.y * _WaveSpeed)) * _WaveFrequency) * _WaveAmplitude;

                output.uv = TRANSFORM_TEX(input.uv, _RockTex);

                return output;
            }

            float4 frag (Varyings input) : SV_Target
            {
                float4 col = SAMPLE_TEXTURE2D(_RockTex, sampler_RockTex, input.uv);
                return col;
            }

            ENDHLSL
        }

    }
}
