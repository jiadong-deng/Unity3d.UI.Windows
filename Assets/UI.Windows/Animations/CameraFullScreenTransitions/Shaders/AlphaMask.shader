﻿Shader "UI.Windows/Transitions/Alpha Mask" {
     Properties {
         [HideInInspector] _MainTex("From (RGB)", 2D) = "white" {}
         [HideInInspector] _ClearScreen("ClearScreen (RGB)", 2D) = "white" {}
         _Value("Value", Range(0, 1)) = 0
         
         _Mask("Mask (A)", 2D) = "white" {}
     }
     SubShader {
         Tags { "RenderType"="Opaque" }
         LOD 200
         
         CGPROGRAM
         #pragma surface surf Lambert
 
         sampler2D _MainTex;
         sampler2D _ClearScreen;
         sampler2D _Mask;
         fixed _Value;
         float4 _MainTex_TexelSize;
 
         struct Input {
             float2 uv_MainTex;
             float2 uv_Mask;
         };
 
         void surf(Input IN, inout SurfaceOutput o) {
         	
         	 float2 uv = IN.uv_MainTex;
         	 #if UNITY_UV_STARTS_AT_TOP
			 if (_MainTex_TexelSize.y < 0) uv.y = 1 - uv.y;
			 #endif
			
             half4 c = tex2D(_MainTex, uv);
             half4 d = tex2D(_ClearScreen, uv);
             half4 g = tex2D(_Mask, IN.uv_Mask);
             
             if ((g.r + g.g + g.b) * 0.33333f < _Value) {
             	
                 o.Albedo = d.rgb;
                 
             } else {
             
                 o.Albedo = c.rgb;
                 
             }
             
             o.Alpha = c.a;//lerp(c.a, d.a, _Value);
             
         }
         
         ENDCG
     } 
     FallBack "Diffuse"
 }