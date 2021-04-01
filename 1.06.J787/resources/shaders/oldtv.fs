varying vec2 TexCoord0;
varying float TimeOut;
varying float AmountOut;
varying vec4 OutScreenSize;
uniform sampler2D Texture0;

void main(void)
{
	vec2 screenRatio = OutScreenSize.zw / OutScreenSize.xy;
	vec2 screenUV = TexCoord0 * screenRatio;

	/*Distortion*/
	screenUV -= vec2(.5,.5);
	screenUV.x *= 1.0 + pow((abs(screenUV.y) / 5.0), 2.0);
	screenUV.y *= 1.0 + pow((abs(screenUV.x) / 1.5), 2.0);
	screenUV += vec2(.5,.5);

	/*Vigneting*/
	vec2 vigUV = (screenUV - 0.5) * vec2(1.5, 1.0) * 2.0;
	float vignete = 1.0 - pow(clamp(length(vigUV) * 0.65, 0.0, 1.0), 5.0) * 0.9;

	vec2 finalUV = screenUV / screenRatio;
	vec4 color = texture2D(Texture0, finalUV);
	color.r = texture2D(Texture0, finalUV + vec2(0.002, 0.0)).r;
	color.b = texture2D(Texture0, finalUV - vec2(0.002, 0.0)).b;
	color.rgb = mix(color.rgb, vec3((color.r + color.g + color.b) * 0.333), vec3(0.8, 0.0, 0.5));
	color.g *= 1.2;
	float scanline = abs(sin(finalUV.y * 700.0 - TimeOut)) * 0.2;
	float highlight = (1.0 - clamp(length(finalUV) * 3.5, 0.0, 1.0)) * (1.0 - clamp(length((finalUV - vec2(0.15, 0.15)) * 8.0), 0.0, 1.0));
	gl_FragColor = (color + vec4(vec3(scanline + highlight), 1.0)) * vignete;
}
