Shader "Unlit/Particle_Add AlphaTex" {	
		
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AlphaTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
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
			sampler2D _AlphaTex;
			float4 _MainTex_ST;
			fixed4 _TintColor;
					
			struct appdata_t {
				float4 vertex : POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f {
				float4 vertex : SV_POSITION;
				fixed4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};
			
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.color = v.color;
				o.texcoord = TRANSFORM_TEX(v.texcoord,_MainTex);
				return o;
			}

			fixed4 frag (v2f i) : COLOR
			{
				fixed4 col = 2.0f * i.color * tex2D(_MainTex, i.texcoord);
				half4 alphaCol = tex2D(_AlphaTex, i.texcoord);
				col.a *= alphaCol.r;
				col *= _TintColor;
				//fixed4 col = 2.0f *  _TintColor * tex2D(_MainTex, i.texcoord);
				return col;
			}
			ENDCG 
		}
	}	
	

}
