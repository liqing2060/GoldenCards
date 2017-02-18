Shader "Hidden/Unlit/Particle_Add 1" {	
		
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_TintColor ("Tint Color",Color) = (0.5, 0.5, 0.5, 0.5)
	}
	SubShader {
	
		Tags { "QUEUE"="Transparent" "IGNOREPROJECTOR"="true" "RenderType"="Transparent" }
		LOD 100
		
		Pass {
		
			Cull Off Lighting Off ZWrite Off Fog { Color (0,0,0,0) }
    		Blend SrcAlpha One	
    		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _TintColor;
			
			float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
			float2 _ClipArgs0 = float2(1000.0, 1000.0);
					
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				float2 worldPos : TEXCOORD1;
			};
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				o.worldPos = v.vertex.xy * _ClipRange0.zw + _ClipRange0.xy;
				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 col = 2.0f * i.color * _TintColor * tex2D(_MainTex, i.texcoord);
				//fixed4 col = 2.0f *  _TintColor * tex2D(_MainTex, i.texcoord);
				
				// Softness factor
				float2 factor = (float2(1.0, 1.0) - abs(i.worldPos)) * _ClipArgs0;
				col.a *= clamp( min(factor.x, factor.y), 0.0, 1.0);
				
				return col;
			}
			ENDCG 
		}
	}	
	

}
