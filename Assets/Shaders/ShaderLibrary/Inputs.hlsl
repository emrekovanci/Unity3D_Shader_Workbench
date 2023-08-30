#ifndef CHIMP_INPUTS_INCLUDED
#define CHIMP_INPUTS_INCLUDED

// references: Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityInput.hlsl

// Time since level load (t/20, t, t*2, t*3)
float4 _Time;
// Sine of time (t/8, t/4, t/2, t)
float4 _SinTime;
// Cosine of time (t/8, t/4, t/2, t)
float4 _CosTime;

float3 _WorldSpaceCameraPos;
float4 _ProjectionParams;

// SRP Batcher Compatibility
CBUFFER_START(UnityPerDraw)
	float4x4 unity_ObjectToWorld;
	float4x4 unity_WorldToObject;
	float4 unity_LODFade;
	real4 unity_WorldTransformParams;
CBUFFER_END

float4x4 unity_MatrixV;
float4x4 unity_MatrixInvV;
float4x4 unity_MatrixVP;
float4x4 glstate_matrix_projection;
float4x4 unity_MatrixPreviousM;
float4x4 unity_MatrixPreviousMI;

#define UNITY_MATRIX_M          unity_ObjectToWorld
#define UNITY_MATRIX_I_M        unity_WorldToObject
#define UNITY_MATRIX_V          unity_MatrixV
#define UNITY_MATRIX_I_V        unity_MatrixInvV
#define UNITY_MATRIX_VP         unity_MatrixVP
#define UNITY_MATRIX_P          glstate_matrix_projection
#define UNITY_PREV_MATRIX_M     unity_MatrixPreviousM
#define UNITY_PREV_MATRIX_I_M   unity_MatrixPreviousMI

#endif
