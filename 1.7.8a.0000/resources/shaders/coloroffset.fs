#ifndef GL_ES
#  define lowp
#  define mediump
#endif
varying lowp vec4 Color0;
varying mediump vec2 TexCoord0;
varying lowp vec4 ColorizeOut;
varying lowp vec3 ColorOffsetOut;
varying lowp vec2 TextureSizeOut;
varying lowp float PixelationAmountOut;
varying lowp vec3 ClipPlaneOut;

uniform sampler2D Texture0;
const vec3 _lum = vec3(0.212671, 0.715160, 0.072169);

/*
void main(void)
{
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	gl_FragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
}
*/

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	
	// vec4 Color = Color0 * texture2D(Texture0, TexCoord0);
	vec4 Color = Color0 * texture2D(Texture0, PixelationAmountOut > 0.0 ? TexCoord0 - mod(TexCoord0, pa) + pa * 0.5 : TexCoord0);
	
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	gl_FragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
	
	gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmountOut, 0.0, 1.0));
}

/*
void main(void)
{
	// Pixelate
    ivec2 TexSize = textureSize(Texture0, 0);
	vec2 pa = vec2(2, 2) / vec2(TexSize);
	
	vec4 Color = Color0 * texture2D(Texture0, TexCoord0 - mod(TexCoord0, pa) + pa * 0.5);
	vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	gl_FragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
	
	// Apply color reduction
	gl_FragColor.rgb = gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0);
}
*/
