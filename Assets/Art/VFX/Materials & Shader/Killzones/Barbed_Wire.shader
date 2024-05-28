// Made with Amplify Shader Editor v1.9.2.2
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fajitas/Killzones/Barbed_Wire"
{
	Properties
	{
		[HideInInspector] _EmissionColor("Emission Color", Color) = (1,1,1,1)
		[HideInInspector] _AlphaCutoff("Alpha Cutoff ", Range(0, 1)) = 0.5
		_M_X_Scale("M_X_Scale", Float) = 1
		_M_Y_Scale("M_Y_Scale", Float) = 1
		_M_X_Pan("M_X_Pan", Float) = 0.2
		_M_Y_Pan("M_Y_Pan", Float) = 0
		_M_Min("M_Min", Float) = 0
		_M_Max("M_Max", Float) = 1
		_D_X_Scale("D_X_Scale", Float) = 1
		_D_Y_Scale("D_Y_Scale", Float) = 1
		_D_Y_Pan("D_Y_Pan", Float) = 0
		_D_X_Pan("D_X_Pan", Float) = 0
		_Dist_Tex("Dist_Tex", 2D) = "white" {}
		_HDR("HDR", Range( 0 , 2)) = 1
		_Distortion_Intensity("Distortion_Intensity", Float) = 0.05
		_Noise_Tex("Noise_Tex", 2D) = "white" {}
		_MainTex("_MainTex", 2D) = "white" {}
		_T_Min("T_Min", Float) = 0
		_T_Max("T_Max", Float) = 0
		_Shinings("Shinings", 2D) = "white" {}
		_Shining_Speed("Shining_Speed", Float) = 0
		_Shining_Intensity("Shining_Intensity", Range( 0 , 1)) = 1
		_Fade_Range("Fade_Range", Float) = 0
		_Fade_Intensity("Fade_Intensity", Float) = 0
		_Aura_Min("Aura_Min", Float) = 0
		_Aura_Max("Aura_Max", Float) = 0
		_Aura_Intensity("Aura_Intensity", Range( 0 , 1)) = 0
		_Wires_Color("Wires_Color", Color) = (0.6694998,0.7939436,0.8018868,1)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

		[HideInInspector][NoScaleOffset] unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset] unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
	}

	SubShader
	{
		LOD 0

		

		Tags { "RenderPipeline"="UniversalPipeline" "RenderType"="Transparent" "Queue"="Transparent" "UniversalMaterialType"="Lit" "ShaderGraphShader"="true" }

		Cull Off
		HLSLINCLUDE
		#pragma target 2.0
		#pragma prefer_hlslcc gles
		// ensure rendering platforms toggle list is visible

		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Common.hlsl"
		#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Filtering.hlsl"
		ENDHLSL

		
		Pass
		{
			Name "Sprite Lit"
			Tags { "LightMode"="Universal2D" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_0
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_1
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_2
			#pragma multi_compile _ USE_SHAPE_LIGHT_TYPE_3

			#define _SURFACE_TYPE_TRANSPARENT 1

			#define SHADERPASS SHADERPASS_SPRITELIT
			#define SHADERPASS_SPRITELIT

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/LightingUtility.hlsl"

			#if USE_SHAPE_LIGHT_TYPE_0
			SHAPE_LIGHT(0)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_1
			SHAPE_LIGHT(1)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_2
			SHAPE_LIGHT(2)
			#endif

			#if USE_SHAPE_LIGHT_TYPE_3
			SHAPE_LIGHT(3)
			#endif

			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/CombinedShapeLightShared.hlsl"

			

			sampler2D _MainTex;
			sampler2D _Noise_Tex;
			sampler2D _Dist_Tex;
			sampler2D _Shinings;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _Wires_Color;
			float _Aura_Intensity;
			float _Aura_Max;
			float _Aura_Min;
			float _Shining_Intensity;
			float _Fade_Intensity;
			float _Fade_Range;
			float _Shining_Speed;
			float _M_Y_Pan;
			float _M_X_Pan;
			float _M_Y_Scale;
			float _Distortion_Intensity;
			float _D_Y_Scale;
			float _D_X_Scale;
			float _D_Y_Pan;
			float _D_X_Pan;
			float _M_Max;
			float _M_Min;
			float _T_Max;
			float _T_Min;
			float _M_X_Scale;
			float _HDR;
			CBUFFER_END


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float4 screenPosition : TEXCOORD2;
				float3 positionWS : TEXCOORD3;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D(_AlphaTex); SAMPLER(sampler_AlphaTex);
				float _EnableAlphaTexture;
			#endif

			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);

				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.positionCS = vertexInput.positionCS;
				o.screenPosition = vertexInput.positionNDC;
				o.positionWS = vertexInput.positionWS;
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );
				float3 positionWS = IN.positionWS.xyz;

				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode106 = tex2D( _MainTex, uv_MainTex );
				float3 hsvTorgb108 = RGBToHSV( tex2DNode106.rgb );
				float2 appendResult9 = (float2(_D_X_Pan , _D_Y_Pan));
				float2 texCoord71 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV70 = texCoord71;
				float2 appendResult8 = (float2(_D_X_Scale , _D_Y_Scale));
				float2 panner15 = ( 1.0 * _Time.y * appendResult9 + (UV70*appendResult8 + 0.0));
				float4 tex2DNode17 = tex2D( _Dist_Tex, panner15 );
				float2 appendResult20 = (float2(( tex2DNode17.r * _Distortion_Intensity ) , ( tex2DNode17.b * _Distortion_Intensity )));
				float2 appendResult72 = (float2(_M_X_Scale , _M_Y_Scale));
				float2 UV_Tex76 = (UV70*appendResult72 + 0.0);
				float2 appendResult42 = (float2(_M_X_Pan , _M_Y_Pan));
				float2 M_Panning41 = ( appendResult42 * _TimeParameters.x );
				float smoothstepResult26 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( appendResult20 + (UV_Tex76*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 Distortion21 = appendResult20;
				float2 temp_cast_1 = (0.5).xx;
				float cos47 = cos( radians( 135.0 ) );
				float sin47 = sin( radians( 135.0 ) );
				float2 rotator47 = mul( UV_Tex76 - temp_cast_1 , float2x2( cos47 , -sin47 , sin47 , cos47 )) + temp_cast_1;
				float smoothstepResult29 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator47*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_2 = (0.5).xx;
				float cos57 = cos( radians( -45.0 ) );
				float sin57 = sin( radians( -45.0 ) );
				float2 rotator57 = mul( UV_Tex76 - temp_cast_2 , float2x2( cos57 , -sin57 , sin57 , cos57 )) + temp_cast_2;
				float smoothstepResult38 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator57*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_3 = (0.5).xx;
				float cos48 = cos( radians( 45.0 ) );
				float sin48 = sin( radians( 45.0 ) );
				float2 rotator48 = mul( UV_Tex76 - temp_cast_3 , float2x2( cos48 , -sin48 , sin48 , cos48 )) + temp_cast_3;
				float smoothstepResult34 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator48*float2( 1,1 ) + M_Panning41) ) ).r);
				float smoothstepResult88 = smoothstep( 0.0 , 0.75 , ( ( sin( ( smoothstepResult26 * 3.0 ) ) + sin( ( smoothstepResult29 * 3.0 ) ) + sin( ( smoothstepResult38 * 3.0 ) ) + sin( ( smoothstepResult34 * 3.0 ) ) ) / 4.0 ));
				float temp_output_89_0 = saturate( smoothstepResult88 );
				float smoothstepResult112 = smoothstep( _T_Min , _T_Max , temp_output_89_0);
				float3 hsvTorgb107 = HSVToRGB( float3(hsvTorgb108.x,hsvTorgb108.y,( smoothstepResult112 * hsvTorgb108.z )) );
				float4 appendResult111 = (float4(( saturate( hsvTorgb107 ) * smoothstepResult112 ) , tex2DNode106.a));
				float mulTime130 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult117 = smoothstep( (0.5 + (sin( ( mulTime130 + 4.0 ) ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*4.0 + 0.0) ).g);
				float mulTime126 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult124 = smoothstep( (0.5 + (sin( mulTime126 ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*3.0 + float2( -0.75,0.11 )) ).g);
				float2 break178 = UV70;
				float smoothstepResult179 = smoothstep( _Fade_Range , _Fade_Intensity , ( ( 1.0 - 0.05 ) - break178.x ));
				float smoothstepResult181 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.x - 0.05 ));
				float smoothstepResult183 = smoothstep( _Fade_Range , _Fade_Intensity , ( 1.05 - break178.y ));
				float smoothstepResult185 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.y - 0.725 ));
				float temp_output_188_0 = ( smoothstepResult179 * smoothstepResult181 * smoothstepResult183 * smoothstepResult185 );
				float Movement196 = temp_output_89_0;
				float smoothstepResult204 = smoothstep( 0.2 , (0.0 + (_Shining_Intensity - 0.0) * (3.0 - 0.0) / (1.0 - 0.0)) , Movement196);
				float2 appendResult217 = (float2(0.0 , -0.05));
				float2 panner215 = ( 1.0 * _Time.y * appendResult217 + (UV70*1.0 + 0.0));
				float smoothstepResult212 = smoothstep( _Aura_Min , _Aura_Max , tex2D( _Shinings, panner215 ).r);
				float4 temp_output_194_0 = ( appendResult111 + ( saturate( ( ( smoothstepResult117 + smoothstepResult124 ) * temp_output_188_0 ) ) * smoothstepResult204 * smoothstepResult212 ) );
				float General_Fade218 = temp_output_188_0;
				float temp_output_225_0 = saturate( ( General_Fade218 * ( ( saturate( ( ( General_Fade218 / ( 1.0 - smoothstepResult212 ) ) / 10.0 ) ) * _Aura_Intensity ) - (temp_output_194_0).a ) ) );
				float4 appendResult104 = (float4(( float4( (( temp_output_194_0 + temp_output_225_0 )).rgb , 0.0 ) * _Wires_Color * _HDR ).rgb , saturate( (( temp_output_194_0 + temp_output_225_0 )).a )));
				
				float4 Color = appendResult104;
				float4 Mask = float4(1,1,1,1);
				float3 Normal = float3( 0, 0, 1 );

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D(_AlphaTex, sampler_AlphaTex, IN.texCoord0.xy);
					Color.a = lerp ( Color.a, alpha.r, _EnableAlphaTexture);
				#endif

				Color *= IN.color;

				SurfaceData2D surfaceData;
				InitializeSurfaceData(Color.rgb, Color.a, Mask, surfaceData);
				InputData2D inputData;
				InitializeInputData(IN.texCoord0.xy, half2(IN.screenPosition.xy / IN.screenPosition.w), inputData);
				SETUP_DEBUG_DATA_2D(inputData, positionWS);
				return CombinedShapeLightShared(surfaceData, inputData);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Sprite Normal"
			Tags { "LightMode"="NormalsRendering" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

			#define _SURFACE_TYPE_TRANSPARENT 1
			#define SHADERPASS SHADERPASS_SPRITENORMAL

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/NormalsRenderingShared.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			sampler2D _MainTex;
			sampler2D _Noise_Tex;
			sampler2D _Dist_Tex;
			sampler2D _Shinings;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _Wires_Color;
			float _Aura_Intensity;
			float _Aura_Max;
			float _Aura_Min;
			float _Shining_Intensity;
			float _Fade_Intensity;
			float _Fade_Range;
			float _Shining_Speed;
			float _M_Y_Pan;
			float _M_X_Pan;
			float _M_Y_Scale;
			float _Distortion_Intensity;
			float _D_Y_Scale;
			float _D_X_Scale;
			float _D_Y_Pan;
			float _D_X_Pan;
			float _M_Max;
			float _M_Min;
			float _T_Max;
			float _T_Min;
			float _M_X_Scale;
			float _HDR;
			CBUFFER_END


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 normalWS : TEXCOORD2;
				float4 tangentWS : TEXCOORD3;
				float3 bitangentWS : TEXCOORD4;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			VertexOutput vert ( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);

				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.positionCS = vertexInput.positionCS;

				float3 normalWS = TransformObjectToWorldNormal( v.normal );
				o.normalWS = -GetViewForwardDir();
				float4 tangentWS = float4( TransformObjectToWorldDir( v.tangent.xyz ), v.tangent.w );
				o.tangentWS = normalize( tangentWS );
				half crossSign = (tangentWS.w > 0.0 ? 1.0 : -1.0) * GetOddNegativeScale();
				o.bitangentWS = crossSign * cross( normalWS, tangentWS.xyz ) * tangentWS.w;
				return o;
			}

			half4 frag ( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode106 = tex2D( _MainTex, uv_MainTex );
				float3 hsvTorgb108 = RGBToHSV( tex2DNode106.rgb );
				float2 appendResult9 = (float2(_D_X_Pan , _D_Y_Pan));
				float2 texCoord71 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV70 = texCoord71;
				float2 appendResult8 = (float2(_D_X_Scale , _D_Y_Scale));
				float2 panner15 = ( 1.0 * _Time.y * appendResult9 + (UV70*appendResult8 + 0.0));
				float4 tex2DNode17 = tex2D( _Dist_Tex, panner15 );
				float2 appendResult20 = (float2(( tex2DNode17.r * _Distortion_Intensity ) , ( tex2DNode17.b * _Distortion_Intensity )));
				float2 appendResult72 = (float2(_M_X_Scale , _M_Y_Scale));
				float2 UV_Tex76 = (UV70*appendResult72 + 0.0);
				float2 appendResult42 = (float2(_M_X_Pan , _M_Y_Pan));
				float2 M_Panning41 = ( appendResult42 * _TimeParameters.x );
				float smoothstepResult26 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( appendResult20 + (UV_Tex76*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 Distortion21 = appendResult20;
				float2 temp_cast_1 = (0.5).xx;
				float cos47 = cos( radians( 135.0 ) );
				float sin47 = sin( radians( 135.0 ) );
				float2 rotator47 = mul( UV_Tex76 - temp_cast_1 , float2x2( cos47 , -sin47 , sin47 , cos47 )) + temp_cast_1;
				float smoothstepResult29 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator47*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_2 = (0.5).xx;
				float cos57 = cos( radians( -45.0 ) );
				float sin57 = sin( radians( -45.0 ) );
				float2 rotator57 = mul( UV_Tex76 - temp_cast_2 , float2x2( cos57 , -sin57 , sin57 , cos57 )) + temp_cast_2;
				float smoothstepResult38 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator57*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_3 = (0.5).xx;
				float cos48 = cos( radians( 45.0 ) );
				float sin48 = sin( radians( 45.0 ) );
				float2 rotator48 = mul( UV_Tex76 - temp_cast_3 , float2x2( cos48 , -sin48 , sin48 , cos48 )) + temp_cast_3;
				float smoothstepResult34 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator48*float2( 1,1 ) + M_Panning41) ) ).r);
				float smoothstepResult88 = smoothstep( 0.0 , 0.75 , ( ( sin( ( smoothstepResult26 * 3.0 ) ) + sin( ( smoothstepResult29 * 3.0 ) ) + sin( ( smoothstepResult38 * 3.0 ) ) + sin( ( smoothstepResult34 * 3.0 ) ) ) / 4.0 ));
				float temp_output_89_0 = saturate( smoothstepResult88 );
				float smoothstepResult112 = smoothstep( _T_Min , _T_Max , temp_output_89_0);
				float3 hsvTorgb107 = HSVToRGB( float3(hsvTorgb108.x,hsvTorgb108.y,( smoothstepResult112 * hsvTorgb108.z )) );
				float4 appendResult111 = (float4(( saturate( hsvTorgb107 ) * smoothstepResult112 ) , tex2DNode106.a));
				float mulTime130 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult117 = smoothstep( (0.5 + (sin( ( mulTime130 + 4.0 ) ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*4.0 + 0.0) ).g);
				float mulTime126 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult124 = smoothstep( (0.5 + (sin( mulTime126 ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*3.0 + float2( -0.75,0.11 )) ).g);
				float2 break178 = UV70;
				float smoothstepResult179 = smoothstep( _Fade_Range , _Fade_Intensity , ( ( 1.0 - 0.05 ) - break178.x ));
				float smoothstepResult181 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.x - 0.05 ));
				float smoothstepResult183 = smoothstep( _Fade_Range , _Fade_Intensity , ( 1.05 - break178.y ));
				float smoothstepResult185 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.y - 0.725 ));
				float temp_output_188_0 = ( smoothstepResult179 * smoothstepResult181 * smoothstepResult183 * smoothstepResult185 );
				float Movement196 = temp_output_89_0;
				float smoothstepResult204 = smoothstep( 0.2 , (0.0 + (_Shining_Intensity - 0.0) * (3.0 - 0.0) / (1.0 - 0.0)) , Movement196);
				float2 appendResult217 = (float2(0.0 , -0.05));
				float2 panner215 = ( 1.0 * _Time.y * appendResult217 + (UV70*1.0 + 0.0));
				float smoothstepResult212 = smoothstep( _Aura_Min , _Aura_Max , tex2D( _Shinings, panner215 ).r);
				float4 temp_output_194_0 = ( appendResult111 + ( saturate( ( ( smoothstepResult117 + smoothstepResult124 ) * temp_output_188_0 ) ) * smoothstepResult204 * smoothstepResult212 ) );
				float General_Fade218 = temp_output_188_0;
				float temp_output_225_0 = saturate( ( General_Fade218 * ( ( saturate( ( ( General_Fade218 / ( 1.0 - smoothstepResult212 ) ) / 10.0 ) ) * _Aura_Intensity ) - (temp_output_194_0).a ) ) );
				float4 appendResult104 = (float4(( float4( (( temp_output_194_0 + temp_output_225_0 )).rgb , 0.0 ) * _Wires_Color * _HDR ).rgb , saturate( (( temp_output_194_0 + temp_output_225_0 )).a )));
				
				float4 Color = appendResult104;
				float3 Normal = float3( 0, 0, 1 );

				Color *= IN.color;

				return NormalsRenderingShared( Color, Normal, IN.tangentWS.xyz, IN.bitangentWS, IN.normalWS);
			}

			ENDHLSL
		}

		
		Pass
		{
			
			Name "Sprite Forward"
			Tags { "LightMode"="UniversalForward" }

			Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
			ZTest LEqual
			ZWrite Off
			Offset 0 , 0
			ColorMask RGBA
			

			HLSLPROGRAM

			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag


			#define _SURFACE_TYPE_TRANSPARENT 1
			#define SHADERPASS SHADERPASS_SPRITEFORWARD

			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/SurfaceData2D.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Debug/Debugging2D.hlsl"

			

			sampler2D _MainTex;
			sampler2D _Noise_Tex;
			sampler2D _Dist_Tex;
			sampler2D _Shinings;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _Wires_Color;
			float _Aura_Intensity;
			float _Aura_Max;
			float _Aura_Min;
			float _Shining_Intensity;
			float _Fade_Intensity;
			float _Fade_Range;
			float _Shining_Speed;
			float _M_Y_Pan;
			float _M_X_Pan;
			float _M_Y_Scale;
			float _Distortion_Intensity;
			float _D_Y_Scale;
			float _D_X_Scale;
			float _D_Y_Pan;
			float _D_X_Pan;
			float _M_Max;
			float _M_Min;
			float _T_Max;
			float _T_Min;
			float _M_X_Scale;
			float _HDR;
			CBUFFER_END


			struct VertexInput
			{
				float4 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 uv0 : TEXCOORD0;
				float4 color : COLOR;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 texCoord0 : TEXCOORD0;
				float4 color : TEXCOORD1;
				float3 positionWS : TEXCOORD2;
				
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			#if ETC1_EXTERNAL_ALPHA
				TEXTURE2D( _AlphaTex ); SAMPLER( sampler_AlphaTex );
				float _EnableAlphaTexture;
			#endif

			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			VertexOutput vert( VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3( 0, 0, 0 );
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif
				v.normal = v.normal;
				v.tangent.xyz = v.tangent.xyz;

				VertexPositionInputs vertexInput = GetVertexPositionInputs( v.positionOS.xyz );

				o.texCoord0 = v.uv0;
				o.color = v.color;
				o.positionCS = vertexInput.positionCS;
				o.positionWS = vertexInput.positionWS;

				return o;
			}

			half4 frag( VertexOutput IN  ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX( IN );

				float3 positionWS = IN.positionWS.xyz;

				float2 uv_MainTex = IN.texCoord0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode106 = tex2D( _MainTex, uv_MainTex );
				float3 hsvTorgb108 = RGBToHSV( tex2DNode106.rgb );
				float2 appendResult9 = (float2(_D_X_Pan , _D_Y_Pan));
				float2 texCoord71 = IN.texCoord0.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV70 = texCoord71;
				float2 appendResult8 = (float2(_D_X_Scale , _D_Y_Scale));
				float2 panner15 = ( 1.0 * _Time.y * appendResult9 + (UV70*appendResult8 + 0.0));
				float4 tex2DNode17 = tex2D( _Dist_Tex, panner15 );
				float2 appendResult20 = (float2(( tex2DNode17.r * _Distortion_Intensity ) , ( tex2DNode17.b * _Distortion_Intensity )));
				float2 appendResult72 = (float2(_M_X_Scale , _M_Y_Scale));
				float2 UV_Tex76 = (UV70*appendResult72 + 0.0);
				float2 appendResult42 = (float2(_M_X_Pan , _M_Y_Pan));
				float2 M_Panning41 = ( appendResult42 * _TimeParameters.x );
				float smoothstepResult26 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( appendResult20 + (UV_Tex76*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 Distortion21 = appendResult20;
				float2 temp_cast_1 = (0.5).xx;
				float cos47 = cos( radians( 135.0 ) );
				float sin47 = sin( radians( 135.0 ) );
				float2 rotator47 = mul( UV_Tex76 - temp_cast_1 , float2x2( cos47 , -sin47 , sin47 , cos47 )) + temp_cast_1;
				float smoothstepResult29 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator47*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_2 = (0.5).xx;
				float cos57 = cos( radians( -45.0 ) );
				float sin57 = sin( radians( -45.0 ) );
				float2 rotator57 = mul( UV_Tex76 - temp_cast_2 , float2x2( cos57 , -sin57 , sin57 , cos57 )) + temp_cast_2;
				float smoothstepResult38 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator57*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_3 = (0.5).xx;
				float cos48 = cos( radians( 45.0 ) );
				float sin48 = sin( radians( 45.0 ) );
				float2 rotator48 = mul( UV_Tex76 - temp_cast_3 , float2x2( cos48 , -sin48 , sin48 , cos48 )) + temp_cast_3;
				float smoothstepResult34 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator48*float2( 1,1 ) + M_Panning41) ) ).r);
				float smoothstepResult88 = smoothstep( 0.0 , 0.75 , ( ( sin( ( smoothstepResult26 * 3.0 ) ) + sin( ( smoothstepResult29 * 3.0 ) ) + sin( ( smoothstepResult38 * 3.0 ) ) + sin( ( smoothstepResult34 * 3.0 ) ) ) / 4.0 ));
				float temp_output_89_0 = saturate( smoothstepResult88 );
				float smoothstepResult112 = smoothstep( _T_Min , _T_Max , temp_output_89_0);
				float3 hsvTorgb107 = HSVToRGB( float3(hsvTorgb108.x,hsvTorgb108.y,( smoothstepResult112 * hsvTorgb108.z )) );
				float4 appendResult111 = (float4(( saturate( hsvTorgb107 ) * smoothstepResult112 ) , tex2DNode106.a));
				float mulTime130 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult117 = smoothstep( (0.5 + (sin( ( mulTime130 + 4.0 ) ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*4.0 + 0.0) ).g);
				float mulTime126 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult124 = smoothstep( (0.5 + (sin( mulTime126 ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*3.0 + float2( -0.75,0.11 )) ).g);
				float2 break178 = UV70;
				float smoothstepResult179 = smoothstep( _Fade_Range , _Fade_Intensity , ( ( 1.0 - 0.05 ) - break178.x ));
				float smoothstepResult181 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.x - 0.05 ));
				float smoothstepResult183 = smoothstep( _Fade_Range , _Fade_Intensity , ( 1.05 - break178.y ));
				float smoothstepResult185 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.y - 0.725 ));
				float temp_output_188_0 = ( smoothstepResult179 * smoothstepResult181 * smoothstepResult183 * smoothstepResult185 );
				float Movement196 = temp_output_89_0;
				float smoothstepResult204 = smoothstep( 0.2 , (0.0 + (_Shining_Intensity - 0.0) * (3.0 - 0.0) / (1.0 - 0.0)) , Movement196);
				float2 appendResult217 = (float2(0.0 , -0.05));
				float2 panner215 = ( 1.0 * _Time.y * appendResult217 + (UV70*1.0 + 0.0));
				float smoothstepResult212 = smoothstep( _Aura_Min , _Aura_Max , tex2D( _Shinings, panner215 ).r);
				float4 temp_output_194_0 = ( appendResult111 + ( saturate( ( ( smoothstepResult117 + smoothstepResult124 ) * temp_output_188_0 ) ) * smoothstepResult204 * smoothstepResult212 ) );
				float General_Fade218 = temp_output_188_0;
				float temp_output_225_0 = saturate( ( General_Fade218 * ( ( saturate( ( ( General_Fade218 / ( 1.0 - smoothstepResult212 ) ) / 10.0 ) ) * _Aura_Intensity ) - (temp_output_194_0).a ) ) );
				float4 appendResult104 = (float4(( float4( (( temp_output_194_0 + temp_output_225_0 )).rgb , 0.0 ) * _Wires_Color * _HDR ).rgb , saturate( (( temp_output_194_0 + temp_output_225_0 )).a )));
				
				float4 Color = appendResult104;

				#if defined(DEBUG_DISPLAY)
					SurfaceData2D surfaceData;
					InitializeSurfaceData(Color.rgb, Color.a, surfaceData);
					InputData2D inputData;
					InitializeInputData(positionWS.xy, half2(IN.texCoord0.xy), inputData);
					half4 debugColor = 0;

					SETUP_DEBUG_DATA_2D(inputData, positionWS);

					if (CanDebugOverrideOutputColor(surfaceData, inputData, debugColor))
					{
						return debugColor;
					}
				#endif

				#if ETC1_EXTERNAL_ALPHA
					float4 alpha = SAMPLE_TEXTURE2D( _AlphaTex, sampler_AlphaTex, IN.texCoord0.xy );
					Color.a = lerp( Color.a, alpha.r, _EnableAlphaTexture );
				#endif

				Color *= IN.color;

				return Color;
			}

			ENDHLSL
		}
		
        Pass
        {
			
            Name "SceneSelectionPass"
            Tags { "LightMode"="SceneSelectionPass" }

            Cull Off

            HLSLPROGRAM

			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENESELECTIONPASS 1


            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

			

			sampler2D _MainTex;
			sampler2D _Noise_Tex;
			sampler2D _Dist_Tex;
			sampler2D _Shinings;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _Wires_Color;
			float _Aura_Intensity;
			float _Aura_Max;
			float _Aura_Min;
			float _Shining_Intensity;
			float _Fade_Intensity;
			float _Fade_Range;
			float _Shining_Speed;
			float _M_Y_Pan;
			float _M_X_Pan;
			float _M_Y_Scale;
			float _Distortion_Intensity;
			float _D_Y_Scale;
			float _D_X_Scale;
			float _D_Y_Pan;
			float _D_X_Pan;
			float _M_Max;
			float _M_Min;
			float _T_Max;
			float _T_Min;
			float _M_X_Scale;
			float _HDR;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};


            int _ObjectId;
            int _PassValue;

			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			VertexOutput vert(VertexInput v )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				float2 uv_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode106 = tex2D( _MainTex, uv_MainTex );
				float3 hsvTorgb108 = RGBToHSV( tex2DNode106.rgb );
				float2 appendResult9 = (float2(_D_X_Pan , _D_Y_Pan));
				float2 texCoord71 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV70 = texCoord71;
				float2 appendResult8 = (float2(_D_X_Scale , _D_Y_Scale));
				float2 panner15 = ( 1.0 * _Time.y * appendResult9 + (UV70*appendResult8 + 0.0));
				float4 tex2DNode17 = tex2D( _Dist_Tex, panner15 );
				float2 appendResult20 = (float2(( tex2DNode17.r * _Distortion_Intensity ) , ( tex2DNode17.b * _Distortion_Intensity )));
				float2 appendResult72 = (float2(_M_X_Scale , _M_Y_Scale));
				float2 UV_Tex76 = (UV70*appendResult72 + 0.0);
				float2 appendResult42 = (float2(_M_X_Pan , _M_Y_Pan));
				float2 M_Panning41 = ( appendResult42 * _TimeParameters.x );
				float smoothstepResult26 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( appendResult20 + (UV_Tex76*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 Distortion21 = appendResult20;
				float2 temp_cast_1 = (0.5).xx;
				float cos47 = cos( radians( 135.0 ) );
				float sin47 = sin( radians( 135.0 ) );
				float2 rotator47 = mul( UV_Tex76 - temp_cast_1 , float2x2( cos47 , -sin47 , sin47 , cos47 )) + temp_cast_1;
				float smoothstepResult29 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator47*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_2 = (0.5).xx;
				float cos57 = cos( radians( -45.0 ) );
				float sin57 = sin( radians( -45.0 ) );
				float2 rotator57 = mul( UV_Tex76 - temp_cast_2 , float2x2( cos57 , -sin57 , sin57 , cos57 )) + temp_cast_2;
				float smoothstepResult38 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator57*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_3 = (0.5).xx;
				float cos48 = cos( radians( 45.0 ) );
				float sin48 = sin( radians( 45.0 ) );
				float2 rotator48 = mul( UV_Tex76 - temp_cast_3 , float2x2( cos48 , -sin48 , sin48 , cos48 )) + temp_cast_3;
				float smoothstepResult34 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator48*float2( 1,1 ) + M_Panning41) ) ).r);
				float smoothstepResult88 = smoothstep( 0.0 , 0.75 , ( ( sin( ( smoothstepResult26 * 3.0 ) ) + sin( ( smoothstepResult29 * 3.0 ) ) + sin( ( smoothstepResult38 * 3.0 ) ) + sin( ( smoothstepResult34 * 3.0 ) ) ) / 4.0 ));
				float temp_output_89_0 = saturate( smoothstepResult88 );
				float smoothstepResult112 = smoothstep( _T_Min , _T_Max , temp_output_89_0);
				float3 hsvTorgb107 = HSVToRGB( float3(hsvTorgb108.x,hsvTorgb108.y,( smoothstepResult112 * hsvTorgb108.z )) );
				float4 appendResult111 = (float4(( saturate( hsvTorgb107 ) * smoothstepResult112 ) , tex2DNode106.a));
				float mulTime130 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult117 = smoothstep( (0.5 + (sin( ( mulTime130 + 4.0 ) ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*4.0 + 0.0) ).g);
				float mulTime126 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult124 = smoothstep( (0.5 + (sin( mulTime126 ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*3.0 + float2( -0.75,0.11 )) ).g);
				float2 break178 = UV70;
				float smoothstepResult179 = smoothstep( _Fade_Range , _Fade_Intensity , ( ( 1.0 - 0.05 ) - break178.x ));
				float smoothstepResult181 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.x - 0.05 ));
				float smoothstepResult183 = smoothstep( _Fade_Range , _Fade_Intensity , ( 1.05 - break178.y ));
				float smoothstepResult185 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.y - 0.725 ));
				float temp_output_188_0 = ( smoothstepResult179 * smoothstepResult181 * smoothstepResult183 * smoothstepResult185 );
				float Movement196 = temp_output_89_0;
				float smoothstepResult204 = smoothstep( 0.2 , (0.0 + (_Shining_Intensity - 0.0) * (3.0 - 0.0) / (1.0 - 0.0)) , Movement196);
				float2 appendResult217 = (float2(0.0 , -0.05));
				float2 panner215 = ( 1.0 * _Time.y * appendResult217 + (UV70*1.0 + 0.0));
				float smoothstepResult212 = smoothstep( _Aura_Min , _Aura_Max , tex2D( _Shinings, panner215 ).r);
				float4 temp_output_194_0 = ( appendResult111 + ( saturate( ( ( smoothstepResult117 + smoothstepResult124 ) * temp_output_188_0 ) ) * smoothstepResult204 * smoothstepResult212 ) );
				float General_Fade218 = temp_output_188_0;
				float temp_output_225_0 = saturate( ( General_Fade218 * ( ( saturate( ( ( General_Fade218 / ( 1.0 - smoothstepResult212 ) ) / 10.0 ) ) * _Aura_Intensity ) - (temp_output_194_0).a ) ) );
				float4 appendResult104 = (float4(( float4( (( temp_output_194_0 + temp_output_225_0 )).rgb , 0.0 ) * _Wires_Color * _HDR ).rgb , saturate( (( temp_output_194_0 + temp_output_225_0 )).a )));
				
				float4 Color = appendResult104;

				half4 outColor = half4(_ObjectId, _PassValue, 1.0, 1.0);
				return outColor;
			}

            ENDHLSL
        }

		
        Pass
        {
			
            Name "ScenePickingPass"
            Tags { "LightMode"="Picking" }

			Cull Off

            HLSLPROGRAM

			#define ASE_SRP_VERSION 140008


			#pragma vertex vert
			#pragma fragment frag

            #define _SURFACE_TYPE_TRANSPARENT 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define FEATURES_GRAPH_VERTEX
            #define SHADERPASS SHADERPASS_DEPTHONLY
			#define SCENEPICKINGPASS 1


            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
			#include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
			#include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"

        	

			sampler2D _MainTex;
			sampler2D _Noise_Tex;
			sampler2D _Dist_Tex;
			sampler2D _Shinings;
			CBUFFER_START( UnityPerMaterial )
			float4 _MainTex_ST;
			float4 _Wires_Color;
			float _Aura_Intensity;
			float _Aura_Max;
			float _Aura_Min;
			float _Shining_Intensity;
			float _Fade_Intensity;
			float _Fade_Range;
			float _Shining_Speed;
			float _M_Y_Pan;
			float _M_X_Pan;
			float _M_Y_Scale;
			float _Distortion_Intensity;
			float _D_Y_Scale;
			float _D_X_Scale;
			float _D_Y_Pan;
			float _D_X_Pan;
			float _M_Max;
			float _M_Min;
			float _T_Max;
			float _T_Min;
			float _M_X_Scale;
			float _HDR;
			CBUFFER_END


            struct VertexInput
			{
				float3 positionOS : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			struct VertexOutput
			{
				float4 positionCS : SV_POSITION;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

            float4 _SelectionID;

			float3 HSVToRGB( float3 c )
			{
				float4 K = float4( 1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0 );
				float3 p = abs( frac( c.xxx + K.xyz ) * 6.0 - K.www );
				return c.z * lerp( K.xxx, saturate( p - K.xxx ), c.y );
			}
			
			float3 RGBToHSV(float3 c)
			{
				float4 K = float4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
				float4 p = lerp( float4( c.bg, K.wz ), float4( c.gb, K.xy ), step( c.b, c.g ) );
				float4 q = lerp( float4( p.xyw, c.r ), float4( c.r, p.yzx ), step( p.x, c.r ) );
				float d = q.x - min( q.w, q.y );
				float e = 1.0e-10;
				return float3( abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
			}

			VertexOutput vert(VertexInput v  )
			{
				VertexOutput o = (VertexOutput)0;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );

				o.ase_texcoord.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord.zw = 0;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					float3 defaultVertexValue = v.positionOS.xyz;
				#else
					float3 defaultVertexValue = float3(0, 0, 0);
				#endif
				float3 vertexValue = defaultVertexValue;
				#ifdef ASE_ABSOLUTE_VERTEX_POS
					v.positionOS.xyz = vertexValue;
				#else
					v.positionOS.xyz += vertexValue;
				#endif

				VertexPositionInputs vertexInput = GetVertexPositionInputs(v.positionOS.xyz);
				float3 positionWS = TransformObjectToWorld(v.positionOS);
				o.positionCS = TransformWorldToHClip(positionWS);

				return o;
			}

			half4 frag(VertexOutput IN ) : SV_TARGET
			{
				float2 uv_MainTex = IN.ase_texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 tex2DNode106 = tex2D( _MainTex, uv_MainTex );
				float3 hsvTorgb108 = RGBToHSV( tex2DNode106.rgb );
				float2 appendResult9 = (float2(_D_X_Pan , _D_Y_Pan));
				float2 texCoord71 = IN.ase_texcoord.xy * float2( 1,1 ) + float2( 0,0 );
				float2 UV70 = texCoord71;
				float2 appendResult8 = (float2(_D_X_Scale , _D_Y_Scale));
				float2 panner15 = ( 1.0 * _Time.y * appendResult9 + (UV70*appendResult8 + 0.0));
				float4 tex2DNode17 = tex2D( _Dist_Tex, panner15 );
				float2 appendResult20 = (float2(( tex2DNode17.r * _Distortion_Intensity ) , ( tex2DNode17.b * _Distortion_Intensity )));
				float2 appendResult72 = (float2(_M_X_Scale , _M_Y_Scale));
				float2 UV_Tex76 = (UV70*appendResult72 + 0.0);
				float2 appendResult42 = (float2(_M_X_Pan , _M_Y_Pan));
				float2 M_Panning41 = ( appendResult42 * _TimeParameters.x );
				float smoothstepResult26 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( appendResult20 + (UV_Tex76*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 Distortion21 = appendResult20;
				float2 temp_cast_1 = (0.5).xx;
				float cos47 = cos( radians( 135.0 ) );
				float sin47 = sin( radians( 135.0 ) );
				float2 rotator47 = mul( UV_Tex76 - temp_cast_1 , float2x2( cos47 , -sin47 , sin47 , cos47 )) + temp_cast_1;
				float smoothstepResult29 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator47*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_2 = (0.5).xx;
				float cos57 = cos( radians( -45.0 ) );
				float sin57 = sin( radians( -45.0 ) );
				float2 rotator57 = mul( UV_Tex76 - temp_cast_2 , float2x2( cos57 , -sin57 , sin57 , cos57 )) + temp_cast_2;
				float smoothstepResult38 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator57*float2( 1,1 ) + M_Panning41) ) ).r);
				float2 temp_cast_3 = (0.5).xx;
				float cos48 = cos( radians( 45.0 ) );
				float sin48 = sin( radians( 45.0 ) );
				float2 rotator48 = mul( UV_Tex76 - temp_cast_3 , float2x2( cos48 , -sin48 , sin48 , cos48 )) + temp_cast_3;
				float smoothstepResult34 = smoothstep( _M_Min , _M_Max , tex2D( _Noise_Tex, ( Distortion21 + (rotator48*float2( 1,1 ) + M_Panning41) ) ).r);
				float smoothstepResult88 = smoothstep( 0.0 , 0.75 , ( ( sin( ( smoothstepResult26 * 3.0 ) ) + sin( ( smoothstepResult29 * 3.0 ) ) + sin( ( smoothstepResult38 * 3.0 ) ) + sin( ( smoothstepResult34 * 3.0 ) ) ) / 4.0 ));
				float temp_output_89_0 = saturate( smoothstepResult88 );
				float smoothstepResult112 = smoothstep( _T_Min , _T_Max , temp_output_89_0);
				float3 hsvTorgb107 = HSVToRGB( float3(hsvTorgb108.x,hsvTorgb108.y,( smoothstepResult112 * hsvTorgb108.z )) );
				float4 appendResult111 = (float4(( saturate( hsvTorgb107 ) * smoothstepResult112 ) , tex2DNode106.a));
				float mulTime130 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult117 = smoothstep( (0.5 + (sin( ( mulTime130 + 4.0 ) ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*4.0 + 0.0) ).g);
				float mulTime126 = _TimeParameters.x * _Shining_Speed;
				float smoothstepResult124 = smoothstep( (0.5 + (sin( mulTime126 ) - 0.0) * (1.0 - 0.5) / (1.0 - 0.0)) , 1.0 , tex2D( _Shinings, (UV70*3.0 + float2( -0.75,0.11 )) ).g);
				float2 break178 = UV70;
				float smoothstepResult179 = smoothstep( _Fade_Range , _Fade_Intensity , ( ( 1.0 - 0.05 ) - break178.x ));
				float smoothstepResult181 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.x - 0.05 ));
				float smoothstepResult183 = smoothstep( _Fade_Range , _Fade_Intensity , ( 1.05 - break178.y ));
				float smoothstepResult185 = smoothstep( _Fade_Range , _Fade_Intensity , ( break178.y - 0.725 ));
				float temp_output_188_0 = ( smoothstepResult179 * smoothstepResult181 * smoothstepResult183 * smoothstepResult185 );
				float Movement196 = temp_output_89_0;
				float smoothstepResult204 = smoothstep( 0.2 , (0.0 + (_Shining_Intensity - 0.0) * (3.0 - 0.0) / (1.0 - 0.0)) , Movement196);
				float2 appendResult217 = (float2(0.0 , -0.05));
				float2 panner215 = ( 1.0 * _Time.y * appendResult217 + (UV70*1.0 + 0.0));
				float smoothstepResult212 = smoothstep( _Aura_Min , _Aura_Max , tex2D( _Shinings, panner215 ).r);
				float4 temp_output_194_0 = ( appendResult111 + ( saturate( ( ( smoothstepResult117 + smoothstepResult124 ) * temp_output_188_0 ) ) * smoothstepResult204 * smoothstepResult212 ) );
				float General_Fade218 = temp_output_188_0;
				float temp_output_225_0 = saturate( ( General_Fade218 * ( ( saturate( ( ( General_Fade218 / ( 1.0 - smoothstepResult212 ) ) / 10.0 ) ) * _Aura_Intensity ) - (temp_output_194_0).a ) ) );
				float4 appendResult104 = (float4(( float4( (( temp_output_194_0 + temp_output_225_0 )).rgb , 0.0 ) * _Wires_Color * _HDR ).rgb , saturate( (( temp_output_194_0 + temp_output_225_0 )).a )));
				
				float4 Color = appendResult104;
				half4 outColor = _SelectionID;
				return outColor;
			}

            ENDHLSL
        }
		
	}
	CustomEditor "ASEMaterialInspector"
	Fallback "Hidden/InternalErrorShader"
	
}
/*ASEBEGIN
Version=19202
Node;AmplifyShaderEditor.CommentaryNode;239;-690,1102;Inherit;False;1130;618.095;Comment;9;115;119;121;123;122;120;118;233;232;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;238;-825.4818,1884.155;Inherit;False;1392;560.0007;Comment;9;130;131;172;173;126;125;127;132;174;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;237;734,-178;Inherit;False;1460;315;Comment;5;97;107;109;106;108;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;236;-1938,318;Inherit;False;1230;1072;Comment;11;25;27;28;30;31;32;33;35;86;87;88;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;235;-736,2640;Inherit;False;1732;1280;Comment;16;176;178;179;185;181;183;187;188;182;186;184;180;177;218;246;247;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;5;-4400,-224;Inherit;False;1028;371;Comment;7;76;75;74;73;72;71;70;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;6;-4400,592;Inherit;False;1476;896;Comment;23;69;68;67;66;65;64;63;62;61;60;59;58;57;56;55;54;53;52;51;50;49;48;47;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;7;-4400,224;Inherit;False;836;323;Comment;7;46;45;44;43;42;41;40;;1,1,1,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-4704,-592;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;9;-4704,-432;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;10;-4864,-592;Inherit;False;Property;_D_X_Scale;D_X_Scale;6;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;11;-4864,-512;Inherit;False;Property;_D_Y_Scale;D_Y_Scale;7;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-4864,-432;Inherit;False;Property;_D_X_Pan;D_X_Pan;9;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-4864,-352;Inherit;False;Property;_D_Y_Pan;D_Y_Pan;8;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;14;-4480,-688;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;15;-4224,-688;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;-3648,-688;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;19;-3648,-464;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;20;-3424,-688;Inherit;True;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;21;-3168,-592;Inherit;False;Distortion;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;26;-2128,368;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-3968,272;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-3808,272;Inherit;False;M_Panning;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;42;-4128,272;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-4352,272;Inherit;False;Property;_M_X_Pan;M_X_Pan;2;0;Create;True;0;0;0;False;0;False;0.2;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;44;-4352,352;Inherit;False;Property;_M_Y_Pan;M_Y_Pan;3;0;Create;True;0;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;45;-4352,432;Inherit;False;Constant;_Float5;Float 5;16;0;Create;True;0;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;46;-4192,432;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;70;-4128,-176;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;71;-4352,-176;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;72;-4192,-48;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;73;-4352,-48;Inherit;False;Property;_M_X_Scale;M_X_Scale;0;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;74;-4352,32;Inherit;False;Property;_M_Y_Scale;M_Y_Scale;1;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;75;-3872,-176;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;76;-3616,-176;Inherit;False;UV_Tex;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;77;-3232,208;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;78;-2688,208;Inherit;True;Property;_Noise;Noise;12;0;Create;True;0;0;0;False;0;False;-1;eef6705a3a248204aa6834967eadfd20;eef6705a3a248204aa6834967eadfd20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;79;-2944,208;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;90;-3952,-432;Inherit;False;Property;_Distortion_Intensity;Distortion_Intensity;12;0;Create;True;0;0;0;False;0;False;0.05;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;17;-4000,-688;Inherit;True;Property;_Dist_Tex;Dist_Tex;10;0;Create;True;0;0;0;False;0;False;-1;442fd87ef7912e24584225aad1a73e19;442fd87ef7912e24584225aad1a73e19;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TexturePropertyNode;39;-2993,-144;Inherit;True;Property;_Noise_Tex;Noise_Tex;13;0;Create;True;0;0;0;False;0;False;442fd87ef7912e24584225aad1a73e19;442fd87ef7912e24584225aad1a73e19;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SamplerNode;22;-2704,624;Inherit;True;Property;_Noise1;Noise;12;0;Create;True;0;0;0;False;0;False;-1;eef6705a3a248204aa6834967eadfd20;eef6705a3a248204aa6834967eadfd20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;23;-2704,880;Inherit;True;Property;_Noise2;Noise;12;0;Create;True;0;0;0;False;0;False;-1;eef6705a3a248204aa6834967eadfd20;eef6705a3a248204aa6834967eadfd20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;24;-2704,1136;Inherit;True;Property;_Noise3;Noise;12;0;Create;True;0;0;0;False;0;False;-1;eef6705a3a248204aa6834967eadfd20;eef6705a3a248204aa6834967eadfd20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SmoothstepOpNode;29;-2128,624;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;34;-2128,1136;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;38;-2128,880;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;47;-3840,720;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RotatorNode;48;-3840,1232;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;49;-4096,912;Inherit;False;Constant;_Float1;Float 1;16;0;Create;True;0;0;0;False;0;False;0.5;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;50;-4208,784;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;51;-4352,784;Inherit;False;Constant;_Float4;Float 2;16;0;Create;True;0;0;0;False;0;False;135;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;-4224,656;Inherit;False;76;UV_Tex;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RadiansOpNode;53;-4192,1296;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-4336,1296;Inherit;False;Constant;_Float2;Float 2;16;0;Create;True;0;0;0;False;0;False;45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RadiansOpNode;55;-4208,1040;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;56;-4352,1040;Inherit;False;Constant;_Float3;Float 2;16;0;Create;True;0;0;0;False;0;False;-45;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RotatorNode;57;-3840,976;Inherit;True;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;58;-3328,1232;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;59;-3520,1296;Inherit;False;41;M_Panning;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;60;-3296,1152;Inherit;False;21;Distortion;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;61;-3072,1152;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;62;-3328,976;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;63;-3520,1040;Inherit;False;41;M_Panning;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;64;-3072,896;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;65;-3296,896;Inherit;False;21;Distortion;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;66;-3328,720;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,1;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;67;-3520,784;Inherit;False;41;M_Panning;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;68;-3296,640;Inherit;False;21;Distortion;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;69;-3072,640;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SaturateNode;89;-704,848;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;37;-2416,576;Inherit;False;Property;_M_Max;M_Max;5;0;Create;True;0;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;36;-2416,495;Inherit;False;Property;_M_Min;M_Min;4;0;Create;True;0;0;0;False;0;False;0;-0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;112;218.7444,535.3252;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;114;0,768;Inherit;False;Property;_T_Max;T_Max;16;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;113;0,672;Inherit;False;Property;_T_Min;T_Min;15;0;Create;True;0;0;0;False;0;False;0;-0.82;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;16;-4864,-688;Inherit;False;70;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SmoothstepOpNode;124;768,1408;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.82;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;175;1152,1408;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;2048,512;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;196;-419.5215,932.0475;Inherit;False;Movement;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;193;1568,1408;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;195;1792,1392;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;202;1280,768;Inherit;True;196;Movement;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;206;1568,1024;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;205;1279,1022;Inherit;False;Property;_Shining_Intensity;Shining_Intensity;19;0;Create;True;0;0;0;False;0;False;1;0.678;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;204;1776,768;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;1.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;117;752,1152;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.82;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;213;1664,2160;Inherit;False;70;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;214;1952,2160;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;215;2256,2160;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;216;1920,2320;Inherit;False;Constant;_Float0;Float 0;23;0;Create;True;0;0;0;False;0;False;-0.05;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;217;2096,2320;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;176;-688,2944;Inherit;False;70;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.BreakToComponentsNode;178;-512,2944;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SmoothstepOpNode;179;80,2944;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;185;80,3664;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;181;80,3200;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;183;80,3424;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;187;-304,2784;Inherit;False;Property;_Fade_Intensity;Fade_Intensity;21;0;Create;True;0;0;0;False;0;False;0;0.1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;188;464,3328;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;182;-304,3440;Inherit;True;2;0;FLOAT;1.05;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;186;-304,2688;Inherit;False;Property;_Fade_Range;Fade_Range;20;0;Create;True;0;0;0;False;0;False;0;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;184;-304,3664;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0.725;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;218;752,3360;Inherit;False;General_Fade;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;25;-1888,368;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;27;-1680,368;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1888,624;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;30;-1680,624;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;31;-1888,880;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;32;-1680,880;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;33;-1888,1136;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;3;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;35;-1680,1136;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;86;-1408,848;Inherit;True;4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;87;-1200,848;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;4;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;88;-960,848;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.75;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;97;2016,-128;Inherit;False;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.HSVToRGBNode;107;1792,-128;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;109;1664,0;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;106;784,-128;Inherit;True;Property;_MainTex;_MainTex;14;0;Create;True;0;0;0;False;0;False;-1;None;506a8162d27f38545baf7957ef8e0716;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RGBToHSVNode;108;1136,-128;Inherit;False;1;0;FLOAT3;0,0,0;False;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.SimpleTimeNode;130;-487.4818,1934.155;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;131;-87.48183,1934.155;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;172;-295.4818,1934.155;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;173;-471.4818,2030.155;Inherit;False;Constant;_Float7;Float 7;22;0;Create;True;0;0;0;False;0;False;4;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;126;-487.4818,2190.156;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;125;-263.4818,2190.156;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-775.4818,2190.156;Inherit;False;Property;_Shining_Speed;Shining_Speed;18;0;Create;True;0;0;0;False;0;False;0;3;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;132;280.5182,1934.155;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;174;280.5182,2190.156;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;115;128,1152;Inherit;True;Property;_TextureSample0;Texture Sample 0;17;0;Create;True;0;0;0;False;0;False;-1;None;706aa8dc43b056747aa18b1365db18bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;119;128,1408;Inherit;True;Property;_TextureSample1;Texture Sample 0;17;0;Create;True;0;0;0;False;0;False;-1;None;706aa8dc43b056747aa18b1365db18bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;121;-640,1408;Inherit;False;70;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.Vector2Node;123;-637.686,1559.095;Inherit;False;Constant;_Vector0;Vector 0;18;0;Create;True;0;0;0;False;0;False;-0.75,0.11;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.ScaleAndOffsetNode;122;-384,1536;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;3;False;2;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;120;-384,1344;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;4;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.WireNode;233;-74.94635,1272.007;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.WireNode;232;140.751,1595.841;Inherit;False;1;0;SAMPLER2D;;False;1;SAMPLER2D;0
Node;AmplifyShaderEditor.SmoothstepOpNode;212;2976,1904;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.95;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;111;3461.751,725.6527;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleAddOpNode;194;3790.371,733.8183;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;203;3253.751,1541.653;Inherit;True;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;219;4036.959,883.4663;Inherit;True;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;221;4149.763,1285.653;Inherit;True;218;General_Fade;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;222;4424.86,1310.766;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;223;4675.339,1308.764;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;220;5503.171,1111.77;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ComponentMaskNode;103;6241.944,764.6838;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ComponentMaskNode;105;6241.944,860.6836;Inherit;False;False;False;False;True;1;0;COLOR;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;98;6225.944,988.6836;Inherit;False;Property;_HDR;HDR;11;0;Create;True;0;0;0;False;0;False;1;1.25;0;2;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;225;5919.558,1052.203;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;226;5955.558,736.2025;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;227;5686.436,1004.967;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;228;6053.094,853.7884;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;224;4965.774,1317.653;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;229;5237.775,1285.653;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;231;4883.103,1595.326;Inherit;False;Property;_Aura_Intensity;Aura_Intensity;24;0;Create;True;0;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;230;4223.217,1652.155;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;211;2560,1920;Inherit;True;Property;_Reflect_Tex;Reflect_Tex;22;0;Create;True;0;0;0;False;0;False;-1;None;706aa8dc43b056747aa18b1365db18bc;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;240;2685,2128;Inherit;False;Property;_Aura_Min;Aura_Min;22;0;Create;True;0;0;0;False;0;False;0;-0.24;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;241;2688,2224;Inherit;False;Property;_Aura_Max;Aura_Max;23;0;Create;True;0;0;0;False;0;False;0;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TexturePropertyNode;118;-640,1152;Inherit;True;Property;_Shinings;Shinings;17;0;Create;True;0;0;0;False;0;False;None;706aa8dc43b056747aa18b1365db18bc;False;white;Auto;Texture2D;-1;0;2;SAMPLER2D;0;SAMPLERSTATE;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;95;6976,752;Inherit;False;3;3;0;FLOAT3;0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;244;6439.214,395.196;Inherit;False;Property;_Wires_Color;Wires_Color;25;0;Create;True;0;0;0;False;0;False;0.6694998,0.7939436,0.8018868,1;0.8820755,1,0.9901257,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;177;-305,2944;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;180;-304,3200;Inherit;True;2;0;FLOAT;1;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;247;-532.7534,3121.039;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-677.7534,3156.039;Inherit;False;Constant;_Float6;Float 6;26;0;Create;True;0;0;0;False;0;False;0.05;0.05;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;245;7153,830;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;104;7408,768;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;248;8176,773;Float;False;True;-1;2;ASEMaterialInspector;0;17;Fajitas/Killzones/Barbed_Wire;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Lit;0;0;Sprite Lit;6;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=Universal2D;False;False;0;Hidden/InternalErrorShader;0;0;Standard;3;Vertex Position;1;0;Debug Display;0;0;External Alpha;0;0;0;5;True;True;True;True;True;False;;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;249;8176,773;Float;False;False;-1;2;ASEMaterialInspector;0;1;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Normal;0;1;Sprite Normal;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=NormalsRendering;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;250;8176,773;Float;False;False;-1;2;ASEMaterialInspector;0;1;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;Sprite Forward;0;2;Sprite Forward;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;True;2;5;False;;10;False;;3;1;False;;10;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;True;True;True;True;0;False;;False;False;False;False;False;False;False;True;False;0;False;;255;False;;255;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;0;False;;False;True;2;False;;True;3;False;;True;True;0;False;;0;False;;True;1;LightMode=UniversalForward;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;251;8176,773;Float;False;False;-1;2;ASEMaterialInspector;0;1;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;SceneSelectionPass;0;3;SceneSelectionPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=SceneSelectionPass;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;252;8176,773;Float;False;False;-1;2;ASEMaterialInspector;0;1;New Amplify Shader;199187dac283dbe4a8cb1ea611d70c58;True;ScenePickingPass;0;4;ScenePickingPass;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;5;RenderPipeline=UniversalPipeline;RenderType=Transparent=RenderType;Queue=Transparent=Queue=0;UniversalMaterialType=Lit;ShaderGraphShader=true;True;0;True;12;all;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;2;False;;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=Picking;False;False;0;Hidden/InternalErrorShader;0;0;Standard;0;False;0
WireConnection;8;0;10;0
WireConnection;8;1;11;0
WireConnection;9;0;12;0
WireConnection;9;1;13;0
WireConnection;14;0;16;0
WireConnection;14;1;8;0
WireConnection;15;0;14;0
WireConnection;15;2;9;0
WireConnection;18;0;17;1
WireConnection;18;1;90;0
WireConnection;19;0;17;3
WireConnection;19;1;90;0
WireConnection;20;0;18;0
WireConnection;20;1;19;0
WireConnection;21;0;20;0
WireConnection;26;0;78;1
WireConnection;26;1;36;0
WireConnection;26;2;37;0
WireConnection;40;0;42;0
WireConnection;40;1;46;0
WireConnection;41;0;40;0
WireConnection;42;0;43;0
WireConnection;42;1;44;0
WireConnection;46;0;45;0
WireConnection;70;0;71;0
WireConnection;72;0;73;0
WireConnection;72;1;74;0
WireConnection;75;0;70;0
WireConnection;75;1;72;0
WireConnection;76;0;75;0
WireConnection;77;0;76;0
WireConnection;77;2;41;0
WireConnection;78;0;39;0
WireConnection;78;1;79;0
WireConnection;79;0;20;0
WireConnection;79;1;77;0
WireConnection;17;1;15;0
WireConnection;22;0;39;0
WireConnection;22;1;69;0
WireConnection;23;0;39;0
WireConnection;23;1;64;0
WireConnection;24;0;39;0
WireConnection;24;1;61;0
WireConnection;29;0;22;1
WireConnection;29;1;36;0
WireConnection;29;2;37;0
WireConnection;34;0;24;1
WireConnection;34;1;36;0
WireConnection;34;2;37;0
WireConnection;38;0;23;1
WireConnection;38;1;36;0
WireConnection;38;2;37;0
WireConnection;47;0;52;0
WireConnection;47;1;49;0
WireConnection;47;2;50;0
WireConnection;48;0;52;0
WireConnection;48;1;49;0
WireConnection;48;2;53;0
WireConnection;50;0;51;0
WireConnection;53;0;54;0
WireConnection;55;0;56;0
WireConnection;57;0;52;0
WireConnection;57;1;49;0
WireConnection;57;2;55;0
WireConnection;58;0;48;0
WireConnection;58;2;59;0
WireConnection;61;0;60;0
WireConnection;61;1;58;0
WireConnection;62;0;57;0
WireConnection;62;2;63;0
WireConnection;64;0;65;0
WireConnection;64;1;62;0
WireConnection;66;0;47;0
WireConnection;66;2;67;0
WireConnection;69;0;68;0
WireConnection;69;1;66;0
WireConnection;89;0;88;0
WireConnection;112;0;89;0
WireConnection;112;1;113;0
WireConnection;112;2;114;0
WireConnection;124;0;119;2
WireConnection;124;1;174;0
WireConnection;175;0;117;0
WireConnection;175;1;124;0
WireConnection;96;0;97;0
WireConnection;96;1;112;0
WireConnection;196;0;89;0
WireConnection;193;0;175;0
WireConnection;193;1;188;0
WireConnection;195;0;193;0
WireConnection;206;0;205;0
WireConnection;204;0;202;0
WireConnection;204;2;206;0
WireConnection;117;0;115;2
WireConnection;117;1;132;0
WireConnection;214;0;213;0
WireConnection;215;0;214;0
WireConnection;215;2;217;0
WireConnection;217;1;216;0
WireConnection;178;0;176;0
WireConnection;179;0;177;0
WireConnection;179;1;186;0
WireConnection;179;2;187;0
WireConnection;185;0;184;0
WireConnection;185;1;186;0
WireConnection;185;2;187;0
WireConnection;181;0;180;0
WireConnection;181;1;186;0
WireConnection;181;2;187;0
WireConnection;183;0;182;0
WireConnection;183;1;186;0
WireConnection;183;2;187;0
WireConnection;188;0;179;0
WireConnection;188;1;181;0
WireConnection;188;2;183;0
WireConnection;188;3;185;0
WireConnection;182;1;178;1
WireConnection;184;0;178;1
WireConnection;218;0;188;0
WireConnection;25;0;26;0
WireConnection;27;0;25;0
WireConnection;28;0;29;0
WireConnection;30;0;28;0
WireConnection;31;0;38;0
WireConnection;32;0;31;0
WireConnection;33;0;34;0
WireConnection;35;0;33;0
WireConnection;86;0;27;0
WireConnection;86;1;30;0
WireConnection;86;2;32;0
WireConnection;86;3;35;0
WireConnection;87;0;86;0
WireConnection;88;0;87;0
WireConnection;97;0;107;0
WireConnection;107;0;108;1
WireConnection;107;1;108;2
WireConnection;107;2;109;0
WireConnection;109;0;112;0
WireConnection;109;1;108;3
WireConnection;108;0;106;0
WireConnection;130;0;127;0
WireConnection;131;0;172;0
WireConnection;172;0;130;0
WireConnection;172;1;173;0
WireConnection;126;0;127;0
WireConnection;125;0;126;0
WireConnection;132;0;131;0
WireConnection;174;0;125;0
WireConnection;115;0;118;0
WireConnection;115;1;120;0
WireConnection;119;0;118;0
WireConnection;119;1;122;0
WireConnection;122;0;121;0
WireConnection;122;2;123;0
WireConnection;120;0;121;0
WireConnection;233;0;118;0
WireConnection;232;0;233;0
WireConnection;212;0;211;1
WireConnection;212;1;240;0
WireConnection;212;2;241;0
WireConnection;111;0;96;0
WireConnection;111;3;106;4
WireConnection;194;0;111;0
WireConnection;194;1;203;0
WireConnection;203;0;195;0
WireConnection;203;1;204;0
WireConnection;203;2;212;0
WireConnection;219;0;194;0
WireConnection;222;0;221;0
WireConnection;222;1;230;0
WireConnection;223;0;222;0
WireConnection;220;0;229;0
WireConnection;220;1;219;0
WireConnection;103;0;226;0
WireConnection;105;0;228;0
WireConnection;225;0;227;0
WireConnection;226;0;194;0
WireConnection;226;1;225;0
WireConnection;227;0;221;0
WireConnection;227;1;220;0
WireConnection;228;0;194;0
WireConnection;228;1;225;0
WireConnection;224;0;223;0
WireConnection;229;0;224;0
WireConnection;229;1;231;0
WireConnection;230;0;212;0
WireConnection;211;0;232;0
WireConnection;211;1;215;0
WireConnection;95;0;103;0
WireConnection;95;1;244;0
WireConnection;95;2;98;0
WireConnection;177;0;247;0
WireConnection;177;1;178;0
WireConnection;180;0;178;0
WireConnection;180;1;246;0
WireConnection;247;0;246;0
WireConnection;245;0;105;0
WireConnection;104;0;95;0
WireConnection;104;3;245;0
WireConnection;248;1;104;0
ASEEND*/
//CHKSM=F72E5BFEF7C3CC30EA1ED0379D692D10AE1151A3