//
// Apply to spine character's material.
//
// Note:
//  Added transparent queue-tag to correctly sort render order.

// (C)2016.12. @kims modified.
//
Shader "Custom/SpriteWithMask" 
{
	Properties {
		_Cutoff("Shadow alpha cutoff", Range(0, 1)) = 0.1
		_MainTex ("Base", 2D) = "white" {}
		_MaskTex ("Mask", 2D) = "white" {}
		_Color ("Color", Color) = (0.5, 0.5, 0.5, 0.5)
	}
	SubShader {
			Tags{ "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" }
			LOD 100

			Fog{ Mode Off }
			Cull Off
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

		Pass {
			CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            sampler2D _MaskTex;
            float4 _Color;

            struct v2f {
                float4 pos : SV_POSITION;
                float2 uv1 : TEXCOORD0;
                float2 uv2 : TEXCOORD1;
            };

            float4 _MainTex_ST;
            float4 _MaskTex_ST;

            v2f vert (appdata_base v)
            {
                v2f o;
                o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
                o.uv1 = TRANSFORM_TEX (v.texcoord, _MainTex);
                o.uv2 = TRANSFORM_TEX (v.texcoord, _MaskTex);
                return o;
            }

			uniform fixed _Cutoff;

            half4 frag (v2f i) : COLOR
            {
	            half4 base = tex2D (_MainTex, i.uv1);
	            half4 mask = tex2D (_MaskTex, i.uv2);
	            base.w = mask.x * mask.x * mask.x;
				clip(base.w - _Cutoff);
                return base * (_Color * 2.0f);
            }
			ENDCG
		}
	} 
	FallBack Off
}