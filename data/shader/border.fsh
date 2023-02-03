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


// ��ñ�������
float getBackArea()
{
	vec4 color_up;
	vec4 color_down;
	vec4 color_left; 
	vec4 color_right; 
	vec4 color_up_left; 
	vec4 color_up_right; 
	vec4 color_down_left; 
	vec4 color_down_right; 
	float total = 0 ; 
	
	float u_line_size = 0.01; //������
	
	color_up = texture(CC_Texture0, v_texCoord + vec2(0, u_line_size)); 
	color_down = texture(CC_Texture0, v_texCoord - vec2(0, u_line_size)); 
	color_left = texture(CC_Texture0, v_texCoord - vec2(u_line_size, 0)); 
	color_right = texture(CC_Texture0, v_texCoord + vec2(u_line_size, 0)); 
	color_up_left = texture(CC_Texture0, v_texCoord + vec2(u_line_size, -u_line_size)); 
	color_up_right = texture(CC_Texture0, v_texCoord + vec2(u_line_size, u_line_size)); 
	color_down_left = texture(CC_Texture0, v_texCoord + vec2(-u_line_size, -u_line_size)); 
	color_down_right = texture(CC_Texture0, v_texCoord + vec2(-u_line_size, u_line_size)); 
	total = color_right.a + color_left.a + color_down.a + color_up.a + color_up_left.a + color_up_right.a + color_down_left.a + color_down_right.a; 
	return clamp(total, 0.0, 1.0);
}

void main()
{
	// ��ȡ��������ɫֵ
	vec4 col = texture2D(CC_Texture0, v_texCoord);
	vec4 fragColor = vec4(0.0);
	fragColor = v_fragmentColor * col; 
	float isBack = getBackArea();

	// ������rgb + ������͸������ * ������ɫ * �����ɫ
	if (fragColor.a < 0.001) //ȥ��ԭ����
	{
		gl_FragColor = vec4(0.0);
	}
	else
	{
		gl_FragColor = vec4(fragColor.rgb + (1.0 - fragColor.a)* vec3(0.0, 1.0, 0.0) * isBack, 1.0);
	}
	//gl_FragColor = vec4(fragColor.rgb + fragColor.a* vec3(0.0, 1.0, 0.0) * isBack, 1.0);
}