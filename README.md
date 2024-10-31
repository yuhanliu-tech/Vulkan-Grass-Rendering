Vulkan Grass Rendering
==================================

**University of Pennsylvania, CIS 565: GPU Programming and Architecture, Project 5**

### Yuhan Liu

[LinkedIn](https://www.linkedin.com/in/yuhan-liu-), [Personal Website](https://liuyuhan.me/), [Twitter](https://x.com/yuhanl_?lang=en)

**Tested on: Windows 11 Pro, Ultra 7 155H @ 1.40 GHz 32GB, RTX 4060 8192MB (Personal Laptop)**

 <img src="img/cover.gif" width="700"/>

### Project Breakdown

This project aims to create a grass simulation and rendering application using Vulkan. Each blade of grass is represented by a Bezier curve, enabling realistic motion and appearance. The simulator uses compute shaders for physics calculations and for culling non-visible blades to improve performance. Only the necessary blades are passed through the graphics pipeline for rendering.

This project is an implementation of the paper, [Responsive Real-Time Grass Rendering for General 3D Scenes](https://www.cg.tuwien.ac.at/research/publications/2017/JAHRMANN-2017-RRTG/JAHRMANN-2017-RRTG-draft.pdf).

## Vulkan Rendering

This project uses the Vulkan API to build a grass simulator and renderer that operates at real-time performance. It leverages a compute shader to apply physics to Bezier curve representations of individual grass blades. By culling non-visible grass blades in each frame, compute shaders optimize efficiency. The remaining visible blades are sent through a graphics pipeline with vertex, tessellation, and fragment shaders to transform, shape, and render them in detail.

## Representing Grass as Bezier Curves

 <img src="img/blade_model.jpg" width="300"/>

Grass blades are represented as Bezier curves, defined by three control points ```(v0, v1, v2)```. Each point carries specific roles: ```v0``` anchors the blade on the ground, ```v1``` serves as a guiding point above ```v0```, and ```v2``` is used for physics-based transformations. Additional blade attributes include orientation, height, width, up vector, and stiffness, which are compactly stored across four ```vec4``` values. These attributes facilitate realistic grass movement and structural integrity in the simulation.

## Simulating Forces

Simulating forces like gravity, recovery, and wind involves updating the ```v2``` control point of each grass blade's Bezier curve. Total force is computed and applied as translation to ```v2```, ensuring blades remain stable and preserve length by correcting ```v1``` and ```v2``` positions.

|Force|Description|Result|
|---|---|---|
| No Forces | Result of rendering 4,096 blades of grass with no additional forces. | <img align="center"  src="./img/noforces.png" width="320"> |
| Gravity | Computed with both environmental and front-facing components, acts downward on each blade. | <img align="center"  src="./img/gravity.png" width="320"> |
| Recovery | Derived from Hooke's Law, counteract deformation, restoring blades to their initial position. | <img align="center"  src="./img/recovery.png" width="320"> |
| Wind | Calculated with custom heuristic functions that vary over time, considers blade position to produce swaying effect. | <img align="center"  src="./img/wind.gif" width="320"> |

## Culling Blades

Culling optimizes performance by removing non-contributing grass blades from the render pipeline. Three main types of culling are employed:

|Culling Type|Description|Result|
|---|---|---|
| Orientation Culling | Removes blades perpendicular to the view vector, as these would appear too thin and create artifacts. | <img align="center"  src="./img/orientculling.gif" width="320"> |
| Frustum Culling | Discards blades entirely outside the camera’s view, based on the visibility of control points ```v0```, ```v2```, and midpoint ```m```. | <img align="center"  src="./img/frustculling.gif" width="320"> |
| Distance Culling | Blades far from the camera are culled to avoid rendering details that are indistinguishable at a distance. | <img align="center"  src="./img/distculling.gif" width="320"> |

## Tessellating Bezier curves into grass blades

Each Bezier curve passes into the grass graphics pipeline as a patch, then tessellated in the tessellation control shader. This step generates vertices that shape each blade’s quad geometry. The tessellation evaluation shader then positions these vertices in world space, adjusting them to match the blade’s width, height, and orientation. This process creates detailed, lifelike grass blades that reflect their underlying Bezier curves and attributes, producing a visually accurate and efficient rendering.

### Distance-Based Level of Detail

Tessellate to varying levels of detail as a function of how far the grass blade is from the camera.

<img src="img/disttest.png" width="500"/> 

The blade shown in left image has tesselation level of four because it is at the farthest distance level. After moving the camera closer towards the blade as seen in the right image, the blade is rendered at a higher tesselation level of 20, producing a smoother curve.

### Complex Blade Shapes

|Basic Blade|Spiky Blade|Bubble Blade|
|---|---|---|
| <img align="center" src="./img/blade1.png" width="120"> | <img align="center" src="./img/blade2.png" width="120"> | <img align="center" src="./img/blade3.png" width="120"> |
| Triangular interpolation, follows equation given in paper. | Add symmetric sinusoidal displacement to create ridges. | Rounder displacement that forms bubbles around a blade |

Hash function based on blade position to determine which shape, and thus color scheme, to render: 

<img src="img/closeup.gif" width="500"/>

### Performance Analysis

#### Grass Simulation Performance

* Your renderer handles varying numbers of grass blades

#### Improvements from Culling Techniques

* There will be an insightful graph here trust. 

### Bloopers (that Produced Cool Imagery)

<img src="img/blooper.png" width="500"/> 
Interpolated blade color based on normals instead of y-position. 

<img src="img/blooper2.png" width="500"/>
Determined color from hash function using discrete comparison instead of range buckets, producing the colored stripes on the blade. 

