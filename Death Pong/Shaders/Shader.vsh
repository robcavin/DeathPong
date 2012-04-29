//
//  Shader.vsh
//  Death Pong
//
//  Created by Robert Cavin on 2/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

attribute vec4 position;
attribute vec3 normal;

varying lowp vec4 colorVarying;
varying lowp vec3 v_light_vec;
varying lowp vec3 v_normal;

uniform mat4 modelViewProjectionMatrix;
uniform mat4 modelViewMatrix;
uniform mat3 normalMatrix;
uniform vec3 lightPos;

void main()
{

    v_normal = normalize(normalMatrix * normal);
    
    vec3 lightPosition = lightPos;
    
    vec4 transformed_position = modelViewMatrix * position;

    v_light_vec = transformed_position.xyz;

    lowp float nDotVP3 = max(0.0, dot(v_normal, normalize(-v_light_vec)));
    lowp vec4 diffuseColor3 = vec4(1.0, 0.4, 0.4, 1.0);
    colorVarying = (diffuseColor3 * nDotVP3);
    
    gl_Position = modelViewProjectionMatrix * position;
}
