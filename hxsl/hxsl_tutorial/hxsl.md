# HXSL

This is a little tutorial on how to get into the Haxe Shader Language that is used by the Heaps Game Engine.  

When I first learned that Heaps has it's own shader language I was sceptical. Of course it could be easier to write shaders in Haxe code, but there are many tutorials and thousands of example shaders for the standard shading languages. How hard would it be to convert those examples to HXSL?

Well, turns out it's pretty easy.  

To try out my examples, first install the [Heaps Game Engine](https://heaps.io/). I used version 1.8.. In newer versions there may be differences.  
Please make sure you know [how to create and run Heaps applications](https://heaps.io/documentation/getting-started.html) first.

A great resource to learn about shaders is [The Book of Shaders](https://thebookofshaders.com/). So let's see how their examples are done in HXSL.

[01 "Hello World!"](01_hello_world.md)  
[02 Time](02_time.md)  
[03 FragCoord](03_frag_coord.md)  
[04 Shaping functions](04_shaping_functions.md)  
[05 Creation by Silexars](05_danguafer_creation_by_silexars.md)  
[06 2D Matrices](06_2d_matrices.md)  
[07 Color transformation](07_color_transformation.md)  

## GLSL to HXSL quick overview (work in progress)

### Variable names

| | GLSL | HXSL (with ```@:import h3d.shader.Base2d```)
|-|:-----|:-----
| default input coordinates | ```gl_FragCoord``` (position 0,0 at left bottom) | ```calculatedUV``` (range 0-1, position 0,0 at left top) 
| final pixel color | ```gl_FragColor``` | ```pixelColor``` |
| screen resolution | ```u_resolution``` | custom
| time | ```u_time``` | ```time```

### Methods

| | GLSL | HXSL
|-|:-----|:-----
| create variable | ```float x = 1.0``` | ```var x = 1.0``` (with type inference)
| create vector | ```vec2(1., 2.)``` | ```vec2(1, 2)``` (values are cast to float)
| vector access | ```.x, .y, .z, .w, .r, .g, .b, .a, .s, .t, .p, .q``` | ```.x, .y, .z, .w, .r, .g, .b, .a, .s, .t, .p, .q```
| vector array access | ```name[1]``` | not available yet
| create 2d matrix | ```mat2(1., 2., 3., 4.)``` | not available yet
| create 3d matrix | ```mat2(1., 2., 3., 4., 5., 6., 7., 8., 9.)``` | ```mat3(vec3(1., 2., 3.), vec3(4., 5., 6.), vec3( 7., 8., 9.))```
| vector x matrix | ```v x m``` | ```v x m```
| matrix x vector | ```m x v``` | not available - transpose matix and use v x m
| function definition | ```vec4 red() { ... }``` | ```function red():Vec4 { ... }```
