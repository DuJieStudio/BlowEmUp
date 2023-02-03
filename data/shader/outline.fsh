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
	//float radius = 0.005;
    //float threshold = 1.0;
    //��ʱ����
    vec4 accum = vec4(0.0);
    //ԭ����
    vec4 normal = vec4(0.0);
    normal = texture2D(CC_Texture0, v_texCoord);
     //��Ȩֵ��������Խ����Ӱ��
    float weight = 30.0;
    //����alphaȨ�أ�alphaԽ��ȨֵassessԽС
    float assess = 0.001;//pow(texture2D(CC_Texture0, v_texCoord).a, 3)*weight;
    //��ʼ����ƽ��alphaֵ
    float alpha = assess;
    //����Ϊ��˹ģ��������alpha��
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -3.0*0.003, -3.0*0.002 ) ).a;
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -2.0*0.003, -2.0*0.002 ) ).a;
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( -1.0*0.003, -1.0*0.002 ) ).a;
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( 0.0 , 0.0) ).a;
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( 1.0*0.003,  1.0*0.002 ) ).a;
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( 2.0*0.003,  2.0*0.002 ) ).a;
    alpha += texture2D( CC_Texture0, v_texCoord.st + vec2( 3.0*0.003, -3.0*0.002 ) ).a;
    alpha /= 7.0+assess;
	
    //float time = CC_Time[1];
    //accum *= threshold;
    accum.r = 127.0/255.0;
    accum.g = 255.0/255.0;
    accum.b = 0.0/255.0;
    accum.a = alpha;

	//ȥ��ԭ����
    if (alpha < 0.2)
    {
        normal = accum;
    }
    else
    {
        normal = (accum * (1.0 - normal.a)) + (normal * normal.a);
    }

    gl_FragColor = v_fragmentColor * normal * 1.5;

}