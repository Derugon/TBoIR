attribute vec3 Position;
attribute vec2 TexCoord;
attribute float Exposure;
attribute float Gamma;
varying vec2 TexCoord0;
varying float ExposureOut;
varying float GammaOut;
uniform mat4 Transform;

void main(void)
{
	ExposureOut = Exposure;
	GammaOut = Gamma;
	gl_Position = Transform * vec4(Position.xyz, 1.0);
	TexCoord0 = TexCoord;
}
