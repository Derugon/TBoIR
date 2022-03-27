varying vec2 TexCoord0;
varying float ExposureOut;
varying float GammaOut;
uniform sampler2D Texture0;

void main(void)
{
	gl_FragColor = texture2D( Texture0, TexCoord0 );
	vec4 Exposed = gl_FragColor * ExposureOut;
	vec4 FinalColor = pow(clamp(Exposed, 0.0, 1.0), vec4(GammaOut));
	gl_FragColor.rgb = FinalColor.rgb;
}
