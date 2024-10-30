#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// DONE: Declare fragment shader inputs
layout(location = 0) in vec3 fsNor;
layout(location = 1) in float fsPosY;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color (make this better)

    vec3 light = vec3(0.0, 1.0, 0.0);
    float diffuseTerm = dot(normalize(fsNor), normalize(light));

    vec3 darkGreen = vec3(0.1f, 0.3f, 0.1f);
    vec3 lightGreen = vec3(0.25f, 0.45f, 0.15f);

    vec3 green = mix(darkGreen, lightGreen, fsPosY);

    outColor = vec4(green * (1.f + diffuseTerm),1.0);

}
