#ifdef GL_ES
precision highp float;
#endif

#if __VERSION__ >= 140

in vec4 Color0;
in vec2 TexCoord0;
in float OutBloomAmount;
in vec2 OutRatio;
out vec4 fragColor;

#else

varying vec4 Color0;
varying vec2 TexCoord0;
varying float OutBloomAmount;
varying vec2 OutRatio;
#define fragColor gl_FragColor
#define texture texture2D

#endif

uniform sampler2D Texture0;

void main(void)
{
	vec4 sum = vec4(0);
	vec2 texcoord = vec2(TexCoord0);
	fragColor = Color0 * texture(Texture0, texcoord);
	int j, i;
	for( i=-4;i < 4; i++){
		for (j = -3; j < 3; j++) {
			vec4 col = texture(Texture0, texcoord + vec2(j, i) * OutRatio);
			sum += col * col * 0.05;
		}
	}
	fragColor += sum * OutBloomAmount;
}
