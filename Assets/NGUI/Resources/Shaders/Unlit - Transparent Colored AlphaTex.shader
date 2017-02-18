Shader "Unlit/Transparent Colored AlphaTex"
{
	Properties
	{
		_MainTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		_AlphaTex ("Base (RGB), Alpha (A)", 2D) = "black" {}
		_CircleRange("CircleRange",Range(0,.5)) = 0
	}
	
	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag			
			#include "UnityCG.cginc"

			sampler2D _MainTex;
			sampler2D _AlphaTex;
			float4 _MainTex_ST;
			float _CircleRange;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			struct v2f
			{
				float4 vertex : SV_POSITION;
				half2 texcoord : TEXCOORD0;
				fixed4 color : COLOR;
			};
	
			v2f vert (appdata_t v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texcoord = v.texcoord;
				o.color = v.color;
				return o;
			}
				
			fixed4 frag (v2f IN) : COLOR
			{
				fixed4 col = tex2D(_MainTex, IN.texcoord) * IN.color;
				fixed4 alphaCol = tex2D(_AlphaTex, IN.texcoord);
				col.a *= alphaCol.r;

				 
				float2 uv = IN.texcoord.xy - float2(0.5, 0);   
				
				float filletAlpha = 0;
				float internal = 0.5 - _CircleRange;
				if(abs(uv.x) > internal && abs(uv.y) > internal)
				{
					half2 dir = half2(abs(uv.x) - internal,abs(uv.y)- internal);
					if(length(dir) > _CircleRange)
					{
						filletAlpha = 1;
					}
				}
				col.a -= filletAlpha;				
				return col;
			}
			ENDCG
		}
	}

	SubShader
	{
		LOD 100

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Fog { Mode Off }
			Offset -1, -1
			ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha
			ColorMaterial AmbientAndDiffuse
			
			SetTexture [_MainTex]
			{
				Combine Texture * Primary
			}
		}
	}
}
