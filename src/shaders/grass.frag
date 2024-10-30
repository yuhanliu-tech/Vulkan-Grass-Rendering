#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// DONE: Declare fragment shader inputs
layout(location = 0) in vec3 fsNor;
layout(location = 1) in float fsPosY;
layout(location = 2) in float fsType;

layout(location = 0) out vec4 outColor;

void main() {
    // DONE: Compute fragment color

    vec3 light = vec3(0.0, 1.0, 0.0);
    float diffuseTerm = dot(normalize(fsNor), normalize(light));

    vec3 darkGreen;
    vec3 lightGreen;

    if (fsType < 0.7f) { // normal grass

        darkGreen = vec3(0.184f, 0.329f, 0.027f);
        lightGreen = vec3(0.431f, 0.62f, 0.2f);

    } else if (fsType < 0.95) { // spiky grass (cool tone)

        darkGreen = vec3(0.204f, 0.192f, 0.212f);
        lightGreen = vec3(0.369f, 0.49f, 0.345f);

    } else { // bubble grass (warm tone)

        darkGreen = vec3(0.376f, 0.588f, 0.361f);
        lightGreen = vec3(0.51f, 0.529f, 0.318f);

    }

    vec3 green = mix(darkGreen, lightGreen, fsPosY);

    outColor = vec4(green * (1.f + diffuseTerm),1.0);

}
