attribute vec3 Position;
attribute vec4 Color;
attribute vec2 TexCoord;
attribute float Time;
attribute float Amount;
attribute vec2 Ratio;
attribute vec2 Offset;
attribute vec2 PlayerPos;
attribute vec2 PlayerVel;
varying vec4 Color0;
varying vec2 TexCoord0;
varying float OutTime;
varying float OutAmount;
varying vec2 OutRatio;
varying vec2 OutOffset;
varying vec2 OutPlayerPos;
varying vec2 OutPlayerVel;
uniform mat4 Transform;

void main(void)
{
	OutTime = Time;
	OutAmount = Amount;
	OutRatio = Ratio;
	OutOffset = Offset;
	OutPlayerPos = PlayerPos;
	OutPlayerVel = PlayerVel;
	Color0 = Color;
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	TexCoord0 = TexCoord;
}
