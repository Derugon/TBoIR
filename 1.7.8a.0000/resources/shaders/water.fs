#ifndef GL_ES
#  define lowp
#endif

varying lowp vec4 Color0;
varying vec2 TexCoord0;
varying float OutTime;
varying float OutAmount;
varying vec2 OutRatio;
varying vec2 OutOffset;
varying vec2 OutPlayerPos;
varying vec2 OutPlayerVel;
uniform sampler2D Texture0;
const float distIntensity = 0.004; // distortion intensity

void main(void)	{
	vec2 uv = TexCoord0;
	// uv correction
	uv -= OutOffset * OutRatio.y;
	uv.x *= OutRatio.x;
	vec3 dist;
	// oscilators
	dist.x = abs(sin(uv.x * 100.0 + OutTime * 0.01) + sin(uv.y * 30.0) * cos(uv.y * 120.0)) * distIntensity;
	dist.y = abs(cos(uv.y * 150.0 + OutTime * 0.01) + cos(uv.x * 150.0) * sin(uv.y * 75.0)) * distIntensity;
	dist.z = (distIntensity - length(dist.xy)) * 0.1;
	// player wave
	vec2 playerdiff = TexCoord0 - OutPlayerPos;
	vec2 playervel = OutPlayerVel;
	float vellen = length(playervel);
	if (vellen > 0.1) {
		float velinterp = clamp(vellen * 0.15, 0.0, 1.0);
		vec2 perpvel = vec2(playervel.y, -playervel.x); // for shrinking
		vec2 normplayerdiff = normalize(playerdiff);
		float perpdot = abs(dot(normalize(perpvel), normplayerdiff)) * velinterp;
		float directionalDot = dot(normalize(playervel), normplayerdiff);
		// distort the wave inverse of direction of movement
		playerdiff *= 1.0 + directionalDot * 0.6 * velinterp + perpdot * (1.0 - abs(directionalDot));
	}
	// player wave oscilator
	float len = length(playerdiff);
	float sinwave = sin(len * 500.0 - OutTime * 0.075);
	playerdiff *= sinwave;
	// gradient for amplitude
	float interp = 1.0 - clamp(len, 0.0, 0.05) / 0.05;
	dist.xy = dist.xy * (1.0 - interp) + normalize(playerdiff) * distIntensity * interp;
	// set distorted color
	vec4 color = texture2D( Texture0, TexCoord0 + dist.xy * OutAmount );
	// fix edges
	if (color.a == 0.0)
		color = texture2D( Texture0, TexCoord0 );
	vec4 origcolor = color;
	// desaturate
	color.rgb *= 0.75;
	// color
	color.b += 0.2;
	color.g += 0.1;
	// light reflection
	vec3 lightsource = vec3(OutPlayerPos.x, OutPlayerPos.y, 5.0);
	vec3 diff = lightsource - vec3(TexCoord0, 0.0);
	float dtp = dot(normalize(dist), normalize(diff));
	// main reflection
	color.rgb *= 0.7 + dtp * 0.3;
	// additional light for player wave
	color.rgb *= 1.0 + sinwave * interp * 0.1;
	color.rgb = clamp(color.rgb, vec3(0.0,0.0,0.0), vec3(1.0,1.0,1.0));
	color.rgb = mix(origcolor.rgb, color.rgb, OutAmount);
	gl_FragColor = color * Color0;
}
