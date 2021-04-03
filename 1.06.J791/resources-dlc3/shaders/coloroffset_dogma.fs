varying lowp vec4 Color0;
varying mediump vec2 TexCoord0;
varying lowp vec4 ColorizeOut;
varying lowp vec3 ColorOffsetOut;
varying lowp vec2 TextureSizeOut;
varying lowp float PixelationAmountOut;
varying lowp vec3 ClipPlaneOut;

uniform sampler2D Texture0;
//const vec3 _lum = vec3(0.212671, 0.715160, 0.072169);

//
// Description : Array and textureless GLSL 2D simplex noise function.
//      Author : Ian McEwan, Ashima Arts.
//  Maintainer : ijm
//     Lastmod : 20110822 (ijm)
//     License : Copyright (C) 2011 Ashima Arts. All rights reserved.
//               Distributed under the MIT License. See LICENSE file.
//               https://github.com/ashima/webgl-noise
// 

vec3 mod289(vec3 x)
{
	return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec2 mod289(vec2 x)
{
	return x - floor(x * (1.0 / 289.0)) * 289.0;
}

vec3 permute(vec3 x)
{
	return mod289(((x*34.0)+1.0)*x);
}

float snoise(vec2 v)
{
	const vec4 C = vec4(0.211324865405187,  // (3.0-sqrt(3.0))/6.0
					  0.366025403784439,  // 0.5*(sqrt(3.0)-1.0)
					 -0.577350269189626,  // -1.0 + 2.0 * C.x
					  0.024390243902439); // 1.0 / 41.0
	// First corner
	vec2 i  = floor(v + dot(v, C.yy) );
	vec2 x0 = v -   i + dot(i, C.xx);

	// Other corners
	vec2 i1;
	//i1.x = step( x0.y, x0.x ); // x0.x > x0.y ? 1.0 : 0.0
	//i1.y = 1.0 - i1.x;
	i1 = (x0.x > x0.y) ? vec2(1.0, 0.0) : vec2(0.0, 1.0);
	// x0 = x0 - 0.0 + 0.0 * C.xx ;
	// x1 = x0 - i1 + 1.0 * C.xx ;
	// x2 = x0 - 1.0 + 2.0 * C.xx ;
	vec4 x12 = x0.xyxy + C.xxzz;
	x12.xy -= i1;

	// Permutations
	i = mod289(i); // Avoid truncation effects in permutation
	vec3 p = permute( permute( i.y + vec3(0.0, i1.y, 1.0 ))
		+ i.x + vec3(0.0, i1.x, 1.0 ));

	vec3 m = max(0.5 - vec3(dot(x0,x0), dot(x12.xy,x12.xy), dot(x12.zw,x12.zw)), 0.0);
	m = m*m ;
	m = m*m ;

	// Gradients: 41 points uniformly over a line, mapped onto a diamond.
	// The ring size 17*17 = 289 is close to a multiple of 41 (41*7 = 287)

	vec3 x = 2.0 * fract(p * C.www) - 1.0;
	vec3 h = abs(x) - 0.5;
	vec3 ox = floor(x + 0.5);
	vec3 a0 = x - ox;

	// Normalise gradients implicitly by scaling m
	// Approximation of: m *= inversesqrt( a0*a0 + h*h );
	m *= 1.79284291400159 - 0.85373472095314 * ( a0*a0 + h*h );

	// Compute final noise value at P
	vec3 g;
	g.x  = a0.x  * x0.x  + h.x  * x0.y;
	g.yz = a0.yz * x12.xz + h.yz * x12.yw;
	return 130.0 * dot(m, g);
}

void main(void)
{
	// Clip
	if(dot(gl_FragCoord.xy, ClipPlaneOut.xy) < ClipPlaneOut.z)
		discard;
	
	// Pixelate
	vec2 pa = vec2(1.0+PixelationAmountOut, 1.0+PixelationAmountOut) / TextureSizeOut;
	
	vec2 uv_aligned = TexCoord0 - mod(TexCoord0, pa) + pa * 0.5;
	vec2 uv = PixelationAmountOut > 0.0 ? uv_aligned : TexCoord0;
	
	// Glitch distortion
	float uOffset = snoise(vec2(ColorizeOut.a*1000.0, TextureSizeOut * 0.5 * uv_aligned.y));
	uOffset = uOffset * ColorizeOut.r * 10.0 / TextureSizeOut.x;
	uv.x += uOffset;
	
	vec4 Color = texture2D(Texture0, uv);
	
	//vec3 Colorized = mix(Color.rgb, dot(Color.rgb, _lum) * ColorizeOut.rgb, ColorizeOut.a);
	//gl_FragColor = vec4(Colorized + ColorOffsetOut * Color.a, Color.a);
	
	// No colorization support, instead use colorize parameter for noise control
	if(Color.r == Color.g && Color.b > Color.r)
	{
		// Blue: Replace with simplex noise
		//float a = mix((snoise(TextureSizeOut * 0.5 * uv_aligned + vec2(ColorizeOut.a*1000.0, 0.0))+0.5)*Color.b, Color.b, Color.r/Color.b);
		
		vec2 NoiseUV = gl_FragCoord.xy + vec2(ColorizeOut.a*10000.0, ColorizeOut.a*10000.0);
		NoiseUV -= mod(NoiseUV, vec2(2.0+2.0*PixelationAmountOut,2.0+2.0*PixelationAmountOut));
		float a = mix((snoise(NoiseUV)+0.5)*Color.b, Color.b, Color.r/Color.b);
		Color.r = Color.g = Color.b = a;
	}
	else if(Color.r == Color.b && Color.g > Color.r)
	{
		// Green: Flicker a solid color
		//float a = mix((snoise(vec2(ColorizeOut.a*1000.0, 0.0))+1.0)*0.5*Color.g, Color.g, Color.r/Color.g);
		float a = mix(step(0.0,snoise(vec2(ColorizeOut.a*1000.0, 0.0)))*Color.g, Color.g, Color.r/Color.g);
		Color.r = Color.g = Color.b = a;
	}
	
	Color *= Color0;
	gl_FragColor = vec4(Color.rgb + ColorOffsetOut * Color.a, Color.a);
	gl_FragColor.rgb = mix(gl_FragColor.rgb, gl_FragColor.rgb - mod(gl_FragColor.rgb, 1.0/16.0) + 1.0/32.0, clamp(PixelationAmountOut, 0.0, 1.0));
}
