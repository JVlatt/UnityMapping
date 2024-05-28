// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Fajitas/GPE/Killzones/Hot_Resistance"
{
	Properties
	{
		[HideInInspector]_Bubbles_Tex_3("Bubbles_Tex_2", 2D) = "white" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}

	}
	
	SubShader
	{
		
		
		Tags { "RenderType"="Opaque" }
	LOD 100

		CGINCLUDE
		#pragma target 3.0
		ENDCG
		Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
		AlphaToMask Off
		Cull Back
		ColorMask RGBA
		ZWrite On
		ZTest LEqual
		Offset 0 , 0
		
		
		
		Pass
		{
			Name "Unlit"
			Tags { "LightMode"="ForwardBase" }
			CGPROGRAM

			

			#ifndef UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX
			//only defining to not throw compilation error over Unity 5.5
			#define UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(input)
			#endif
			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_instancing
			#include "UnityCG.cginc"
			#if defined(SHADER_API_D3D11) || defined(SHADER_API_XBOXONE) || defined(UNITY_COMPILER_HLSLCC) || defined(SHADER_API_PSSL) || (defined(SHADER_TARGET_SURFACE_ANALYSIS) && !defined(SHADER_TARGET_SURFACE_ANALYSIS_MOJOSHADER))//ASE Sampler Macros
			#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex.Sample(samplerTex,coord)
			#else//ASE Sampling Macros
			#define SAMPLE_TEXTURE2D(tex,samplerTex,coord) tex2D(tex,coord)
			#endif//ASE Sampling Macros
			


			struct appdata
			{
				float4 vertex : POSITION;
				float4 color : COLOR;
				float4 ase_texcoord : TEXCOORD0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};
			
			struct v2f
			{
				float4 vertex : SV_POSITION;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 worldPos : TEXCOORD0;
				#endif
				float4 ase_texcoord1 : TEXCOORD1;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};

			UNITY_DECLARE_TEX2D_NOSAMPLER(_Bubbles_Tex_3);
			uniform float4 _Bubbles_Tex_3_ST;
			SamplerState sampler_Bubbles_Tex_3;

			
			v2f vert ( appdata v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
				UNITY_TRANSFER_INSTANCE_ID(v, o);

				o.ase_texcoord1.xy = v.ase_texcoord.xy;
				
				//setting value to unused interpolator channels and avoid initialization warnings
				o.ase_texcoord1.zw = 0;
				float3 vertexValue = float3(0, 0, 0);
				#if ASE_ABSOLUTE_VERTEX_POS
				vertexValue = v.vertex.xyz;
				#endif
				vertexValue = vertexValue;
				#if ASE_ABSOLUTE_VERTEX_POS
				v.vertex.xyz = vertexValue;
				#else
				v.vertex.xyz += vertexValue;
				#endif
				o.vertex = UnityObjectToClipPos(v.vertex);

				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				#endif
				return o;
			}
			
			fixed4 frag (v2f i ) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID(i);
				UNITY_SETUP_STEREO_EYE_INDEX_POST_VERTEX(i);
				fixed4 finalColor;
				#ifdef ASE_NEEDS_FRAG_WORLD_POSITION
				float3 WorldPosition = i.worldPos;
				#endif
				float2 uv_Bubbles_Tex_3 = i.ase_texcoord1.xy * _Bubbles_Tex_3_ST.xy + _Bubbles_Tex_3_ST.zw;
				
				
				finalColor = SAMPLE_TEXTURE2D( _Bubbles_Tex_3, sampler_Bubbles_Tex_3, uv_Bubbles_Tex_3 );
				return finalColor;
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=18400
-16.33325;-2.333333;1920;1019;-2555.79;398.2291;1;True;True
Node;AmplifyShaderEditor.CommentaryNode;28;-2939.124,1334.708;Inherit;False;2152;653;Comment;16;44;43;42;41;40;39;38;37;36;35;34;33;32;31;30;29;Distortion;1,0.6841278,0,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;92;-2935.203,682.3331;Inherit;False;1919.588;584.5558;Comment;15;83;88;87;86;85;84;82;81;80;79;78;99;102;104;105;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleTimeNode;121;-282.2236,987.8221;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;116;-394.2238,875.8223;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.SamplerNode;9;-1664,0;Inherit;True;Property;_Noise_Tex;Noise_Tex;0;0;Create;True;0;0;False;0;False;-1;None;c8b5855c01e949c4a827cc5bbcb6d375;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleTimeNode;74;-848,256;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;60;-1632,-512;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;70;-1540.386,238.4564;Inherit;False;Property;_N_Min;N_Min;6;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;224;1018.057,-732.4364;Inherit;True;240;Bubbles_2;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;71;-1538.386,342.4564;Inherit;False;Property;_N_Max;N_Max;7;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;82;-1991.202,730.3331;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;117;-42.22378,875.8223;Inherit;True;2;0;FLOAT;0.01;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;76;-656,256;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;107;-640,368;Inherit;False;Property;_Time_Min;Time_Min;23;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;321;1056,-848;Inherit;False;41;Dist;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;27;-1296,0;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;268;1463.08,-1171.327;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;63;-1424,-512;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;300;1334.055,-1264.921;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;88;-2727.203,1082.333;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;79;-2279.202,730.3331;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;266;880,-1280;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;262;440.2971,-1388.956;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.25;False;2;FLOAT;0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;236;-128,-2176;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;18;-2112,0;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;84;-2743.203,826.3331;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;83;-2887.203,730.3331;Inherit;False;45;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;47;-1961.752,179.7372;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;7;-2176,-768;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.05;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;85;-2887.203,986.3331;Inherit;False;Property;_B_Scale;B_Scale;15;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;323;1391.996,-882.9448;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.4;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;78;-2503.203,730.3331;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2887.203,1082.333;Inherit;False;Property;_B_X_Pan;B_X_Pan;18;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;-640,992;Inherit;False;Property;_Scrolling_fade_Speed;Scrolling_fade_Speed;25;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;75;-1088,256;Inherit;False;Property;_Fade_Time_Speed;Fade_Time_Speed;24;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;86;-2887.203,1162.333;Inherit;False;Property;_B_Y_Pan;B_Y_Pan;19;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;97;-1920,-768;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0.001;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;57;-1920,-512;Inherit;True;2;0;FLOAT;0.23;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;240;128,-2176;Inherit;False;Bubbles_2;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;115;-874.2233,875.8223;Inherit;False;45;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;46;-1815.358,31.25809;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TFHCRemapNode;318;692.0168,-1142.128;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;-1;False;4;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;288;1689.975,-1101.086;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;99;-1776,752;Inherit;True;Property;_B_Noise;B_Noise;22;0;Create;True;0;0;False;0;False;-1;None;eef6705a3a248204aa6834967eadfd20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;53;-1216,-512;Inherit;False;Base_White;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;61;1502,409;Inherit;True;53;Base_White;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;66;1552,-16;Inherit;True;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;308;2685.828,-482.5542;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;50;-2208,-1024;Inherit;False;Base;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;52;1056,-144;Inherit;False;50;Base;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;307;2880,-512;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;311;3034.892,-698.4482;Inherit;False;0;2;2;0,0,0,0;1,1,1,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.DynamicAppendNode;69;1744,0;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.GradientSampleNode;312;3245.892,-595.4482;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;23;2048,-128;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;110;2007.373,140.8713;Inherit;False;109;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;112;2307.373,-118.1287;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.DynamicAppendNode;313;3545.103,-380.3558;Inherit;False;COLOR;4;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;295;959.3826,988.6602;Inherit;False;Scrolling;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;228;3648,-96;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;331;3501.323,206.9565;Inherit;True;Property;_Bubbles_Tex_3;Bubbles_Tex_2;35;1;[HideInInspector];Create;True;1;Smoke;0;0;False;0;False;-1;442fd87ef7912e24584225aad1a73e19;c8b5855c01e949c4a827cc5bbcb6d375;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ComponentMaskNode;68;1312,0;Inherit;False;True;True;True;False;1;0;COLOR;0,0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-2432,-1024;Inherit;True;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TFHCRemapNode;108;1408.332,695.9426;Inherit;True;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;1;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;314;2613.411,-302.5184;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;20;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;22;-384,0;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;102;-1648,944;Inherit;False;Property;_B_Min;B_Min;20;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;109;-2432,-640;Inherit;False;Alpha;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;104;-1652.051,1025.013;Inherit;False;Property;_B_Max;B_Max;21;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;155.817,869.1379;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.SinOpNode;119;357.7762,875.8223;Inherit;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;322;1815.514,-983.5956;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;105;-1390.356,767.6739;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;77;-432,240;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0.5;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientNode;24;224,-96;Inherit;False;0;4;2;0,0,0,0;0.9782646,0,0,0.162005;0.999371,0.404076,0,0.8296025;1,0.5851397,0,1;1,0;1,1;0;1;OBJECT;0
Node;AmplifyShaderEditor.GetLocalVarNode;226;1356.057,-541.4361;Inherit;False;109;Alpha;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GradientSampleNode;25;976,-16;Inherit;True;2;0;OBJECT;;False;1;FLOAT;0;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;227;1580.057,-509.436;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;67;1135,628;Inherit;False;Property;_HDR;HDR;48;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;306;2158.162,-318.3482;Inherit;False;Property;_Smoke_Intensity;Smoke_Intensity;44;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;124;639.7502,703.7806;Inherit;True;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;269;2092.704,-748.6943;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;225;2448.275,-566.8163;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;96;480,16;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;59;-2176,-512;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;17;-2912,384;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;81;-2887.203,826.3331;Inherit;False;Property;_B_X_Tile;B_X_Tile;16;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;39;-1611.123,1382.708;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;284;-2880,2224;Inherit;False;45;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;273;-2688,2320;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;244;-2672,-2080;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;276;-2880,2480;Inherit;False;Property;_N2_Scale;N2_Scale;10;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;249;-2816,-1824;Inherit;False;Property;_B2_X_Pan;B2_X_Pan;40;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;250;-2816,-1744;Inherit;False;Property;_B2_Y_Pan;B2_Y_Pan;41;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;-1067.123,1382.708;Inherit;False;Dist;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;248;-2816,-1920;Inherit;False;Property;_B2_Scale;B2_Scale;37;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;277;-2880,2640;Inherit;False;Property;_N2_Y_Pan;N2_Y_Pan;14;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;280;-2880,2560;Inherit;False;Property;_N2_X_Pan;N2_X_Pan;13;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;281;-2400,2224;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;242;-2432,-2176;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;251;-2192,-2176;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;255;-1832.17,-1959.6;Inherit;False;Property;_Smoke_Dist;Smoke_Dist;34;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;272;-2688,2576;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;282;-2176,2224;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0.5;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;275;-2880,2400;Inherit;False;Property;_N2_Y_Tile;N2_Y_Tile;12;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;274;-2880,2320;Inherit;False;Property;_N2_X_Tile;N2_X_Tile;11;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;247;-2816,-2000;Inherit;False;Property;_B2_Y_Tile;B2_Y_Tile;39;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-1995.123,1382.708;Inherit;True;Property;_Distortion_Tex1;Distortion_Tex;26;1;[HideInInspector];Create;True;1;Smoke_Distortion;0;0;False;0;False;-1;eef6705a3a248204aa6834967eadfd20;eef6705a3a248204aa6834967eadfd20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.WorldPosInputsNode;293;-2816,-2368;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.RegisterLocalVarNode;294;-2604.215,-2374.5;Inherit;False;WorldPos;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-2891.123,1510.708;Inherit;False;Property;_Dist_X_Tile1;Dist_X_Tile;28;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;32;-2891.123,1590.708;Inherit;False;Property;_Dist_Y_Tile1;Dist_Y_Tile;29;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;33;-2731.124,1510.708;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.GetLocalVarNode;29;-2889.555,1383.391;Inherit;False;294;WorldPos;1;0;OBJECT;;False;1;FLOAT3;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;36;-2603.124,1382.708;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT3;1,0,0;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;31;-2891.123,1766.708;Inherit;False;Property;_Dist_X_Pan1;Dist_X_Pan;30;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;257;-247.7017,-1388.956;Inherit;False;45;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;30;-2891.123,1846.708;Inherit;False;Property;_Dist_Y_Pan1;Dist_Y_Pan;31;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;37;-2395.123,1382.708;Inherit;False;3;0;FLOAT3;0,0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.DynamicAppendNode;34;-2731.124,1766.708;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;38;-2203.123,1398.708;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;10;-3072,0;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;1,1;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RegisterLocalVarNode;45;-2853.992,-81.47485;Inherit;False;UV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;43;-1995.123,1638.708;Inherit;False;Property;_Dist_Min1;Dist_Min;32;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;246;-2816,-2080;Inherit;False;Property;_B2_X_Tile;B2_X_Tile;38;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;35;-1995.123,1718.708;Inherit;False;Property;_Dist_Max1;Dist_Max;33;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-2891.123,1670.708;Inherit;False;Property;_Dist_Scale1;Dist_Scale;27;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WorldPosInputsNode;332;3268.426,273.2858;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;256;-1754.17,-2056.6;Inherit;False;41;Dist;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;324;-3968,-1024;Inherit;False;41;Dist;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;264;312.2975,-1132.956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;16;-2912,208;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;11;-2720,0;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT;1;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;260;105.2977,-1388.956;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;317;322.8969,-856.6078;Inherit;False;5;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;-1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;287;-894.3389,2247.979;Inherit;False;Move;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-2432,-768;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;238;-384,-2016;Inherit;False;Property;_B2_Max;B2_Max;43;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;239;-656,-2160;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScaleAndOffsetNode;20;-2432,0;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;1,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;56;-2368,-512;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;265;472.297,-1132.956;Inherit;True;3;0;FLOAT;0;False;1;FLOAT;0.2;False;2;FLOAT;-0.2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;261;280.2975,-1388.956;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;-2224,143;Inherit;False;287;Move;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;48;-2309.752,226.7372;Inherit;False;Property;_Distortion_Intensity;Distortion_Intensity;9;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;80;-2887.203,906.3331;Inherit;False;Property;_B_Y_Tile;B_Y_Tile;17;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;237;-384,-2096;Inherit;False;Property;_B2_Min;B2_Min;42;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;5;-2944,-1024;Inherit;True;Property;_MainTex;_MainTex;47;0;Create;True;0;0;False;0;False;-1;None;442fd87ef7912e24584225aad1a73e19;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.BreakToComponentsNode;55;-2496,-512;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;15;-3072,464;Inherit;False;Property;_N_Y_Pan;N_Y_Pan;5;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;315;0,-960;Inherit;False;Property;_Smoke_Height;Smoke_Height;45;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;327;-3968,-896;Inherit;False;Property;_Resistance_Disotortion_Intensity;Resistance_Disotortion_Intensity;49;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;328;-3584,-1152;Inherit;False;45;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;326;-3584,-1024;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;259;-55.70196,-1388.956;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.PannerNode;283;-1792,2224;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;254;-1536.17,-2026.6;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;252;-1920,-2176;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;325;-3200,-1024;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.DynamicAppendNode;245;-2656,-1824;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;285;-1376,2224;Inherit;True;Property;_Water_Tex_2;Water_Tex_2;8;1;[HideInInspector];Create;True;1;Distortion;0;0;False;0;False;-1;442fd87ef7912e24584225aad1a73e19;eef6705a3a248204aa6834967eadfd20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;253;-1296,-2192;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;316;0,-864;Inherit;False;Property;_Smoke_Fade;Smoke_Fade;46;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;12;-3072,208;Inherit;False;Property;_N_X_Tile;N_X_Tile;2;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-3072,288;Inherit;False;Property;_N_Y_Tile;N_Y_Tile;3;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;263;136.2977,-1132.956;Inherit;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;54;-2688,-512;Inherit;False;45;UV;1;0;OBJECT;;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;241;-1024,-2176;Inherit;True;Property;_Bubbles_Tex_2;Bubbles_Tex_2;36;1;[HideInInspector];Create;True;1;Smoke;0;0;False;0;False;-1;442fd87ef7912e24584225aad1a73e19;eef6705a3a248204aa6834967eadfd20;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-3072,384;Inherit;False;Property;_N_X_Pan;N_X_Pan;4;0;Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;19;-3072,128;Inherit;False;Property;_N_Scale;N_Scale;1;0;Create;True;0;0;False;0;False;0;0.08;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;330;3952,-32;Float;False;True;-1;2;ASEMaterialInspector;100;1;Fajitas/GPE/Killzones/Hot_Resistance;0770190933193b94aaa3065e307002fa;True;Unlit;0;0;Unlit;2;True;2;5;False;-1;10;False;-1;3;1;False;-1;10;False;-1;True;0;False;-1;0;False;-1;False;False;False;False;False;False;True;0;False;-1;True;0;False;-1;True;True;True;True;True;0;False;-1;False;False;False;True;False;255;False;-1;255;False;-1;255;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;7;False;-1;1;False;-1;1;False;-1;1;False;-1;True;1;False;-1;True;3;False;-1;True;True;0;False;-1;0;False;-1;True;1;RenderType=Opaque=RenderType;True;2;0;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;True;1;LightMode=ForwardBase;False;0;;0;0;Standard;1;Vertex Position,InvertActionOnDeselection;1;0;1;True;False;;True;0
WireConnection;121;0;126;0
WireConnection;116;0;115;0
WireConnection;9;1;46;0
WireConnection;74;0;75;0
WireConnection;60;0;97;0
WireConnection;60;1;57;0
WireConnection;82;0;79;0
WireConnection;82;2;88;0
WireConnection;117;0;121;0
WireConnection;117;1;116;0
WireConnection;76;0;74;0
WireConnection;27;0;9;1
WireConnection;27;1;70;0
WireConnection;27;2;71;0
WireConnection;268;0;300;0
WireConnection;268;1;224;0
WireConnection;63;0;60;0
WireConnection;300;0;266;0
WireConnection;88;0;87;0
WireConnection;88;1;86;0
WireConnection;79;0;78;0
WireConnection;79;1;85;0
WireConnection;266;0;262;0
WireConnection;266;1;318;0
WireConnection;262;0;261;0
WireConnection;236;0;239;0
WireConnection;236;1;237;0
WireConnection;236;2;238;0
WireConnection;18;0;20;0
WireConnection;18;2;17;0
WireConnection;84;0;81;0
WireConnection;84;1;80;0
WireConnection;47;0;49;0
WireConnection;47;1;48;0
WireConnection;7;0;8;0
WireConnection;323;0;321;0
WireConnection;78;0;83;0
WireConnection;78;1;84;0
WireConnection;97;0;7;0
WireConnection;57;1;59;0
WireConnection;240;0;236;0
WireConnection;46;0;18;0
WireConnection;46;1;47;0
WireConnection;318;0;265;0
WireConnection;288;0;268;0
WireConnection;99;1;82;0
WireConnection;53;0;63;0
WireConnection;66;0;68;0
WireConnection;66;1;108;0
WireConnection;308;0;225;0
WireConnection;308;1;314;0
WireConnection;50;0;51;0
WireConnection;307;0;308;0
WireConnection;69;0;66;0
WireConnection;69;3;61;0
WireConnection;312;0;311;0
WireConnection;312;1;307;0
WireConnection;23;0;52;0
WireConnection;23;1;69;0
WireConnection;112;0;23;0
WireConnection;112;3;110;0
WireConnection;313;0;312;0
WireConnection;313;3;307;0
WireConnection;295;0;124;0
WireConnection;228;0;313;0
WireConnection;228;1;112;0
WireConnection;68;0;25;0
WireConnection;51;0;5;0
WireConnection;51;1;5;4
WireConnection;108;0;124;0
WireConnection;108;4;67;0
WireConnection;314;0;306;0
WireConnection;22;0;63;0
WireConnection;22;1;27;0
WireConnection;109;0;5;4
WireConnection;120;0;117;0
WireConnection;119;0;120;0
WireConnection;322;0;288;0
WireConnection;322;1;323;0
WireConnection;105;0;99;1
WireConnection;105;1;102;0
WireConnection;105;2;104;0
WireConnection;77;0;76;0
WireConnection;77;3;107;0
WireConnection;25;0;24;0
WireConnection;25;1;96;0
WireConnection;227;0;226;0
WireConnection;124;0;105;0
WireConnection;124;1;119;0
WireConnection;269;0;322;0
WireConnection;269;1;224;0
WireConnection;225;0;269;0
WireConnection;225;1;227;0
WireConnection;96;0;22;0
WireConnection;96;1;77;0
WireConnection;59;0;56;0
WireConnection;59;1;56;0
WireConnection;17;0;14;0
WireConnection;17;1;15;0
WireConnection;39;0;44;1
WireConnection;39;1;43;0
WireConnection;39;2;35;0
WireConnection;273;0;274;0
WireConnection;273;1;275;0
WireConnection;244;0;246;0
WireConnection;244;1;247;0
WireConnection;41;0;39;0
WireConnection;281;0;284;0
WireConnection;281;1;273;0
WireConnection;242;0;293;0
WireConnection;242;1;244;0
WireConnection;251;0;242;0
WireConnection;251;1;248;0
WireConnection;272;0;280;0
WireConnection;272;1;277;0
WireConnection;282;0;281;0
WireConnection;282;1;276;0
WireConnection;44;1;38;0
WireConnection;294;0;293;0
WireConnection;33;0;42;0
WireConnection;33;1;32;0
WireConnection;36;0;29;0
WireConnection;36;1;33;0
WireConnection;37;0;36;0
WireConnection;37;1;40;0
WireConnection;34;0;31;0
WireConnection;34;1;30;0
WireConnection;38;0;37;0
WireConnection;38;2;34;0
WireConnection;45;0;10;0
WireConnection;264;0;263;0
WireConnection;264;1;263;0
WireConnection;16;0;12;0
WireConnection;16;1;13;0
WireConnection;11;0;10;0
WireConnection;11;1;19;0
WireConnection;260;0;259;0
WireConnection;317;0;316;0
WireConnection;287;0;285;1
WireConnection;8;0;5;1
WireConnection;8;1;5;4
WireConnection;239;0;241;1
WireConnection;20;0;11;0
WireConnection;20;1;16;0
WireConnection;56;0;55;0
WireConnection;265;0;264;0
WireConnection;265;1;315;0
WireConnection;265;2;317;0
WireConnection;261;0;260;0
WireConnection;261;1;260;0
WireConnection;5;1;325;0
WireConnection;55;0;54;0
WireConnection;326;0;324;0
WireConnection;326;1;327;0
WireConnection;259;0;257;0
WireConnection;283;0;282;0
WireConnection;283;2;272;0
WireConnection;254;0;256;0
WireConnection;254;1;255;0
WireConnection;252;0;251;0
WireConnection;252;2;245;0
WireConnection;325;0;328;0
WireConnection;325;1;326;0
WireConnection;245;0;249;0
WireConnection;245;1;250;0
WireConnection;285;1;283;0
WireConnection;253;0;254;0
WireConnection;253;1;252;0
WireConnection;263;0;259;1
WireConnection;241;1;253;0
WireConnection;330;0;331;0
ASEEND*/
//CHKSM=832682BC8A4D78105A2360E03BF5E7F4B1717D4B