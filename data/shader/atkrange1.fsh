#ifdef GL_ES																						 
	precision mediump float;																		 
#endif																								 
																										 
varying vec2 v_texCoord;	
varying vec4 v_position;
uniform vec2 resolution;
uniform sampler2D CC_Texture0;
uniform float inner_r;

uniform float rr;
uniform float gg;
uniform float bb;

float sdfUnion( const float a, const float b ) {
    return min(a, b);
}

float sdfDifference( const float a, const float b) {
    return max(a, -b);
}

float sdfIntersection( const float a, const float b ) {
    return max(a, b);
}

float sdfCircle(vec2 center, float radius, vec2 coord) {
    vec2 offset = coord - center;

    return sqrt((offset.x * offset.x) + (offset.y * offset.y)) - radius;
}

void main() {
	vec2 position = (v_texCoord.xy + v_position.xy)/ min(resolution.x,resolution.y) ;
	
	float r = sdfCircle(vec2(0.5,0.5),0.47,position);

	float ir = sdfCircle(vec2(0.5,0.5),0.47 * inner_r,position);
	
	r = sdfDifference(r,ir);

	if(r < -0.02)
	{
		gl_FragColor = vec4(rr,gg,bb,0.7)*min((-0.01/r),1.0);
	}
	else
	{
		gl_FragColor = vec4(0.0);
	}
	gl_FragColor = mix( gl_FragColor, vec4(0.0), smoothstep( 0.46, 0.48, length(position - vec2(0.5,0.5)))); 
}