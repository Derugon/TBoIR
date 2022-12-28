#ifdef GL_ES
precision highp float;
#endif

#if __VERSION__ >= 140

in vec4 Color0;
in vec2 TexCoord0;
in float OutPixelationAmount;
in vec4 OutScreenSize;
out vec4 fragColor;

#else

varying vec4 Color0;
varying vec2 TexCoord0;
varying float OutPixelationAmount;
varying vec4 OutScreenSize;
#define fragColor gl_FragColor
#define texture texture2D

#endif

uniform sampler2D Texture0;

/*
const int Samples = 4;

void main(void)
{
	vec2 screenRatio = OutScreenSize.zw / OutScreenSize.xy;
	float pa = OutPixelationAmount * 0.5;
	vec2 adjustedUVs = TexCoord0.st * screenRatio;
	if (OutScreenSize.y < OutScreenSize.x) {
		adjustedUVs.y *= OutScreenSize.y / OutScreenSize.x;
	} else {
		adjustedUVs.x *= OutScreenSize.x / OutScreenSize.y;
	}
	
	vec2 snapCoord = vec2(adjustedUVs.s - mod(adjustedUVs.s - pa*0.5 - 0.5, pa), adjustedUVs.t - mod(adjustedUVs.t - pa*0.5 - 0.5, pa));
	float samplesInv = pa / float(Samples);
	float maxSamplesInv = 1.0 / float(Samples * Samples);
	gl_FragColor = Color0;
	gl_FragColor *= 0.001;
	for (int i = 0; i < Samples; i++) {
		for (int j = 0; j < Samples; j++) {
			float u = clamp(snapCoord.s + float(i) * samplesInv, 0.0, 1.0);
			float v = clamp(snapCoord.t + float(j) * samplesInv, 0.0, 1.0);
			if (OutScreenSize.y < OutScreenSize.x) {
				v *= OutScreenSize.x / OutScreenSize.y;
			} else {
				u *= OutScreenSize.y / OutScreenSize.x;
			}
			u /= screenRatio.x;
			v /= screenRatio.y;
			gl_FragColor += texture2D( Texture0, vec2(u, v)) * maxSamplesInv;
		}
	}
}
*/

// SNES style mosaic effect, it's cheap, simple, and more crisp looking
void main(void)
{
	vec2 pa = OutPixelationAmount * 0.5 * min(OutScreenSize.z, OutScreenSize.w) / OutScreenSize.zw;
	//vec2 snapCoord = TexCoord0.st - mod(TexCoord0.st, pa) + pa * 0.5;
	
	// Centered pixelation
	// This is less faithful to the SNES mosaic effect but it looks better overall
	vec2 center = OutScreenSize.xy * 0.5 / OutScreenSize.zw;
	vec2 snapCoord = TexCoord0.st - mod(TexCoord0.st - center, pa) + pa * 0.5;
	
	fragColor = texture(Texture0, snapCoord);
}
