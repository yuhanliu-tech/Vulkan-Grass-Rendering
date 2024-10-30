#version 450
#extension GL_ARB_separate_shader_objects : enable

layout(vertices = 1) out;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// TODO: Declare tessellation control shader inputs and outputs

layout(location = 0) in vec4[] inV0;
layout(location = 1) in vec4[] inV1;
layout(location = 2) in vec4[] inV2;
layout(location = 3) in vec4[] inUp;

layout(location = 0) out vec4[] outV0;
layout(location = 1) out vec4[] outV1;
layout(location = 2) out vec4[] outV2;
layout(location = 3) out vec4[] outUp;

void main() {
	// Don't move the origin location of the patch
    gl_out[gl_InvocationID].gl_Position = gl_in[gl_InvocationID].gl_Position;

	// DONE: Write any shader outputs
    outV0[gl_InvocationID] = inV0[gl_InvocationID];
    outV1[gl_InvocationID] = inV1[gl_InvocationID];
    outV2[gl_InvocationID] = inV2[gl_InvocationID];
    outUp[gl_InvocationID] = inUp[gl_InvocationID];

    // Calculate distance to grass blade

    vec3 bladePos = vec3(gl_in[gl_InvocationID].gl_Position);
    vec3 cameraPos = vec3(inverse(camera.view)[3]); 
    float dist = length(bladePos - cameraPos);

    // Tessellate to varying levels of detail as a function of how far the grass blade is from the camera

    float tessLevel;
    if (dist < 15.0) {
        tessLevel = 20.0; 
    } else if (dist < 25.0) {
        tessLevel = 10.0; 
    } else {
        tessLevel = 6.0; 
    }

    // Low/varying tesselations doesn't work for the dandelion leaves, so use this instead
    tessLevel = 30.0;

    // Set tessellation level
    gl_TessLevelInner[0] = tessLevel;
    gl_TessLevelInner[1] = tessLevel;
    gl_TessLevelOuter[0] = tessLevel;
    gl_TessLevelOuter[1] = tessLevel;
    gl_TessLevelOuter[2] = tessLevel;
    gl_TessLevelOuter[3] = tessLevel;
}
