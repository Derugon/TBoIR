varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 Ratio0;
varying lowp float Amount0;
varying lowp float PixelationAmount0;

uniform sampler2D Texture0;

void main(void)
{
	vec2 newTexCoord = TexCoord0;
	
	newTexCoord.y += (0.001 / Ratio0.y) * sin(
		(newTexCoord.x - Ratio0.z) * 50.0 * Ratio0.x +
		(newTexCoord.y - Ratio0.w) * 100.0 * Ratio0.y +
		Amount0 * 6.28318530718 * 2.0
	);
	gl_FragColor = texture2D(Texture0, newTexCoord.xy) * Color0;
}
