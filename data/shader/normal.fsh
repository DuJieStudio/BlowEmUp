#ifdef GL_ES
precision lowp float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D CC_Texture0;

varying vec4 v_fragmentColorr;
varying vec4 v_fragmentColorg;
varying vec4 v_fragmentColorb;
varying vec4 v_fragmentColora;
varying vec2 v_texSize;
varying float v_falg;
varying float v_flagvalue;

void main()
{
	vec4 vColor=texture2D(CC_Texture0, v_texCoord);
	
	gl_FragColor=vColor;

}