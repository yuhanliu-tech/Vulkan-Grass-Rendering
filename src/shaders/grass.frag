#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// DONE: Declare fragment shader inputs
layout(location = 0) in float fsV;
layout(location = 1) in vec3 fsNor;

layout(location = 0) out vec4 outColor;

void main() {
    // TODO: Compute fragment color (make this better)

    vec4 green = vec4(0.f, 0.5f, 0.f, 1.f);

    outColor = green;
}
