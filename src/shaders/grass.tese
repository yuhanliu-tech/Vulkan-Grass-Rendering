#version 450
#extension GL_ARB_separate_shader_objects : enable

#define EXTRA_BLADES 0

layout(quads, equal_spacing, ccw) in;

layout(set = 0, binding = 0) uniform CameraBufferObject {
    mat4 view;
    mat4 proj;
} camera;

// DONE: Declare tessellation evaluation shader inputs and outputs
layout(location = 0) in vec4 inV0[];
layout(location = 1) in vec4 inV1[];
layout(location = 2) in vec4 inV2[];
layout(location = 3) in vec4 inUp[];

layout(location = 0) out vec3 fsNor;
layout(location = 1) out float fsPosY;
layout(location = 2) out float fsType;

float hash(float x, float z) {
    return fract(sin(dot(vec2(x, z), vec2(12.9898, 78.233))) * 43758.5453);
}

void main() {
    float u = gl_TessCoord.x;
    float v = gl_TessCoord.y;

	// DONE: Use u and v to parameterize along the grass blade and output positions for each vertex of the grass blade

    vec3 v0 = inV0[0].xyz;
    vec3 v1 = inV1[0].xyz;
    vec3 v2 = inV2[0].xyz;

    float direction = inV0[0].w;
    float width = inV2[0].w;

    // bitangent: direction vector along width of the blade (first col of rotation matrix)
    vec3 t1 = vec3(cos(direction), 0.0, -sin(direction)); 
    
    // De Casteljau's Algorithm

    vec3 a = v0 + v * (v1 - v0); 
    vec3 b = v1 + v * (v2 - v1); 
    vec3 c = a + v * (b - a); 

    vec3 c0 = c - width * t1;
    vec3 c1 = c + width * t1;

    vec3 t0 = normalize(b - a); 

    // -------------------------------------------------------------------

    // Generate a random float based on the blade’s position
    float bladeHash = hash(v0.x, v0.y); // Change ID for unique pattern per blade

    // Choose shape style based on the hash
    float t; // Interpolation parameter
    vec3 pos;

    fsType = bladeHash;

#if EXTRA_BLADES
    if (bladeHash < 0.70) {
#endif        
        // normal grass

        float threshold = 0.0;
        t = 0.5 + (u - 0.5) * (1 - (max(v - threshold, 0) / (1 - threshold)));
        pos = (1 - t) * c0 + t * c1;
#if EXTRA_BLADES
    } else if (bladeHash < 0.95) {
        
        // spiky grass

        float threshold = 0.0;
        t = 0.5 + (u - 0.5) * (1 - (max(v - threshold, 0) / (1 - threshold)));

        // enhance shape of grass, inspired by paper's section on dandelion leaves
        float spikes = 0.5 * abs(fract(50.f * v)) * smoothstep(0.9, 0.1, v);

         if (u > 0) {
            t += spikes;
        } else {
            t -= spikes;
        }

        pos = (1 - t) * c0 + t * c1;

    } else {

        // bubble grass

        float leafFrequency = 25.0;
        float leafAmplitude = 0.15;
        t = 0.5 + (u - 0.5) * (1 - (max(v - 0.5, 0) / 0.5));
        float offset = sin(leafFrequency * v) * leafAmplitude * (u < 0.5 ? -1.0 : 1.0) + v;
        pos = (1 - t) * (c0 + offset * t1) + t * (c1 + offset * t1);
    
    }
#endif
    fsNor = normalize(cross(t0, t1));
    fsPosY = pos.y;
    
    gl_Position = camera.proj * camera.view * vec4(pos, 1.0);

}
