attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute float BloomAmount;
attribute vec2 Ratio;
varying vec4 Color0;
varying vec2 TexCoord0;
varying float OutBloomAmount;
varying vec2 OutRatio;
uniform mat4 Transform;

void main(void)
{
	OutBloomAmount = BloomAmount;
	OutRatio = Ratio;
	Color0 = Color;
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	TexCoord0 = TexCoord;
}
