varying vec4 Color0;
varying vec2 TexCoord0;
varying vec2 TextureSize0;
varying vec4 Ratio0;
varying lowp float Time0;
varying lowp float Amount0;
varying lowp float PixelationAmount0;

uniform sampler2D Texture0;

vec2 mirrorclamp(vec2 uv, vec2 m)
{
	return uv + max(vec2(0.0, 0.0), -2.0 * uv) + min(vec2(0.0, 0.0), -2.0 * (uv - m));
}

void main(void)
{
	float time = Time0 * 6.28318530718 * 0.5;
	float amount = Amount0+0.1;
	
	vec2 center = 0.5 * TextureSize0.xy;
	vec2 texcoord = TexCoord0;
	
	vec2 diff = 0.7 * (texcoord - center) / TextureSize0;
	amount = min(1.0, 2.0*(pow(abs(diff.x),4.0)+pow(max(0.0, abs(diff.y)+0.1),4.0)));
	
	vec2 amp = amount * vec2(0.016, 0.016) / Ratio0.xy;
	vec2 freq = vec2(8.0, 12.0);
	float speed = 1.0;
	vec2 uv = mirrorclamp(texcoord + amp * sin(freq * 3.141593 * Ratio0.xy * (TexCoord0.yx - Ratio0.wz) + speed*time), TextureSize0.xy);
	
	amp = amount * vec2(0.016, 0.016) / Ratio0.xy;
	freq = vec2(8.0, 12.0);
	speed = 2.0;
	vec2 uv2 = mirrorclamp((texcoord-center)*(1.0+0.05*amount) + center + amp * sin(freq * 3.141593 * Ratio0.xy * (TexCoord0.yx - Ratio0.wz) + speed*time), TextureSize0.xy);
	
	vec3 rgb = mix(texture2D(Texture0, uv).xyz, texture2D(Texture0, uv2).xyz, 0.5);
	rgb += vec3(1.0, 1.0, 1.0) * 0.05 * pow(max(0.0, sin(speed*time+dot(texcoord, vec2(-1.0, 1.0)))), 20.0);
	rgb += vec3(0.05, 0.05, 0.05) + 0.2 * vec3(texcoord.x, texcoord.y, 1.0 - texcoord.x - texcoord.y);
	rgb *= (1.0 - 10.0* amount);
	
	
	gl_FragColor = vec4(rgb, 1.0);
}
