Shader "OCB/SunDialMRAO"
{
    Properties
    {
        _Color("Color", Color) = (1,1,1,1)
        _MainTex("Albedo", 2D) = "white" { }
        _Normal("Normal", 2D) = "white" { }
        _MRAO("MRAO", 2D) = "white" { }
    }
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _Normal;
        sampler2D _MRAO;

        struct Input
        {
            float2 uv_MainTex;
            float2 uv_Normal;
            float2 uv_MRAO;
        };

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf(Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 mrao = tex2D(_MRAO, IN.uv_MRAO);
            fixed4 albedo = tex2D(_MainTex, IN.uv_MainTex);
            o.Albedo = albedo.rgb;
            o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
            o.Metallic = mrao.r;
            o.Smoothness = 1 - mrao.a;
            o.Occlusion = mrao.g;
            o.Alpha = 1;
        }
        ENDCG
    }
    FallBack "Standard"
}
