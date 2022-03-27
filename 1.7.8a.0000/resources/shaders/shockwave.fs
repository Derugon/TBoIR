varying vec4 Color0;
varying vec2 TexCoord0;
varying vec4 Shockwave1Out;
varying vec4 Shockwave2Out;
varying vec2 OutRatio;
uniform sampler2D Texture0;

void main(void)
{
	vec2 newTexCoord = TexCoord0;
	float distance1 = length((TexCoord0.st - Shockwave1Out.xy) * OutRatio);
	float time1 = Shockwave1Out.z;
	bool combine = false;
	if (Shockwave1Out.x > -100.0 && distance1 <= time1 + 0.05 && distance1 >= time1 - 0.05) {
		float diff = (distance1 - time1);
		float powDiff = 1.0-pow(abs(diff*20.0), 0.8);
		vec2 diffUV = normalize((TexCoord0.st - Shockwave1Out.xy) * OutRatio);
		newTexCoord = TexCoord0.st + (diffUV * powDiff * Shockwave1Out.a) / OutRatio;
		combine = true;
	}
	float distance2 = length((TexCoord0.st - Shockwave2Out.xy) * OutRatio);
	float time2 = Shockwave2Out.z;
	if (Shockwave2Out.x > -100.0 && distance2 <= time2 + 0.05 && distance2 >= time2 - 0.05) {
		float diff = (distance2 - time2);
		float powDiff = 1.0-pow(abs(diff*20.0), 0.8);
		vec2 diffUV = normalize((TexCoord0.st - Shockwave2Out.xy) * OutRatio);
		vec2 calcCoord = TexCoord0.st + (diffUV * powDiff * Shockwave2Out.a) / OutRatio;
		if (combine)
			newTexCoord = (calcCoord + newTexCoord) * 0.5;
		else
			newTexCoord = calcCoord;
	}
	gl_FragColor = texture2D(Texture0, newTexCoord.st) * Color0;
}
