//
//  Shader.fsh
//  Death Pong
//
//  Created by Robert Cavin on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

varying lowp vec4 colorVarying;
varying lowp vec3 v_light_vec;
varying lowp vec3 v_normal;
uniform highp vec3 lightPos;

void main()
{

    lowp vec4 diffuseColor = vec4(0.4, 0.4, 1.0, 1.0);
    //lowp vec4 diffuseColor2 = vec4(0.4, 1.0, 0.4, 1.0);

    //lowp vec3 fixed_light_pos = vec3(0.0,0,-1);
    
    lowp vec3 light_vec = lightPos - v_light_vec;
    //lowp float atten = 1.0 / (1.0 + 5.0*length(light_vec));    
    //lowp float atten2 = 1.0 / (1.0 + 2.0*length(fixed_light_pos-v_light_vec));    
    //lowp float atten3 = 1.0 / (1.0 + 2.0*length(-v_light_vec));    
    lowp float atten = max(0.0,(1.0 - 10.0*length(light_vec)));
    //lowp float nDotVP = max(0.0, dot(v_normal, normalize(light_vec)));

    //lowp float nDotVP2 = max(0.0, dot(v_normal, normalize(fixed_light_pos-v_light_vec)));
    //lowp float nDotVP3 = max(0.0, dot(v_normal, normalize(-v_light_vec)));
    

    gl_FragColor = (diffuseColor * atten) + colorVarying;// * nDotVP);// + 0.5*colorVarying;// + (diffuseColor2 * atten2 * nDotVP2) + (diffuseColor3 * atten3 * nDotVP3);    
    //gl_FragColor.r = v_light_vec.z;
    //gl_FragColor.g = (lightPos.z-v_light_vec.z);
    //gl_FragColor.ba = vec2(0.0,1.0); 
}
