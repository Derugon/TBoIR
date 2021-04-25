varying lowp vec4 Color0;
varying vec2 TexCoord0;
varying float OutBloomAmount;
varying vec2 OutRatio;
uniform sampler2D Texture0;

void main(void)
{
	vec4 sum = vec4(0);
	vec2 texcoord = vec2(TexCoord0);
	gl_FragColor = Color0 * texture2D(Texture0, texcoord);
	int j, i;
	for( i=-4;i < 4; i++){
		for (j = -3; j < 3; j++) {
			vec4 col = texture2D(Texture0, texcoord + vec2(j, i) * OutRatio);
			sum += col * col * 0.05;
		}
	}
	gl_FragColor += sum * OutBloomAmount;
}
