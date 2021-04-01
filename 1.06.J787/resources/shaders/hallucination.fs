varying vec2 TexCoord0;
varying float AmountOut;
//varying vec2 NoiseOut;
varying vec4 OutScreenSize;
uniform sampler2D Texture0;

/*float random (vec2 st) {
	return fract(sin(dot(st.xy,
		vec2(12.9898,78.233)))*
		43758.5453123);
}*/

void main(void)
{
	vec2 screenRatio = OutScreenSize.zw / OutScreenSize.xy;
	vec2 screenUV = TexCoord0 * screenRatio;

	/*Vigneting*/
	vec2 vigUV = (screenUV - 0.5) * vec2(1.5, 1.0) * 2.0;
	float vignete = 1.0 - pow(clamp(length(vigUV) * 0.65, 0.0, 1.0), 5.0) * 0.9;

	vec4 origColor = texture2D(Texture0, TexCoord0);
	/*Small bloom*/
	int i, j;
	vec4 sum = vec4(0);
	for(i = -1; i <= 1; i++) {
		for (j = -1; j <= 1; j++) {
			vec4 col = texture2D(Texture0, TexCoord0 + vec2(i, j) * 3.0 / OutScreenSize.zw);
			sum += col * col * 0.13;
		}
	}
	vec4 color = origColor + sum;
	color.a = origColor.a;
	/*Desaturate + Sepia*/
	color.rgb = vec3(dot(vec3(0.2126,0.7152,0.0722), color.rgb));
	color.rgb *= vec3(1.1, 1.0, 0.9);
	color.rgb *= vignete;
	vec4 finalColor = mix(origColor, color, AmountOut);
	/*Apply noise*/
	//finalColor.rgb = mix(finalColor.rgb, vec3(random(TexCoord0 * (NoiseOut.y * 100.0))), NoiseOut.x);
	gl_FragColor = finalColor;
}
