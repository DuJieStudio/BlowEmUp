attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

attribute vec4 a_colorr;
attribute vec4 a_colorg;
attribute vec4 a_colorb;
attribute vec4 a_colora;
attribute vec2 a_texSize;
attribute float a_falg;
attribute float a_flagvalue;


varying vec4 v_fragmentColorr;
varying vec4 v_fragmentColorg;
varying vec4 v_fragmentColorb;
varying vec4 v_fragmentColora;
varying vec2 v_texSize;
varying float v_falg;
varying float v_flagvalue;
					

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
								
void main()	
{							
	gl_Position = CC_MVPMatrix * a_position;
	v_texCoord = a_texCoord;
}