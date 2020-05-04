
# 07 Color transformation

The last example of [Matrices](https://thebookofshaders.com/08/) in The Book of Shaders can be a bit of a challenge. Rewriting the example for HXSL is straighforward.



```haxe
import h2d.Tile;
import h2d.Bitmap;

class Main extends hxd.App {

	static function main() {
		new Main();
	}

	override function init() {
		var bmp = new Bitmap( Tile.fromColor( 0, s2d.width, s2d.height ), s2d );
		var shader = new MainShader( new h3d.Vector( s2d.width, s2d.height ));
		bmp.addShader( shader );
	}

}

class MainShader extends hxsl.Shader {

	static var SRC = {
		@:import h3d.shader.Base2d;
		
		@param var iResolution : Vec2;
		
		function fragment() {

			// YUV to RGB matrix
			var yuv2rgb = mat3(
				vec3( 1, 0, 1.13983 ),
				vec3( 1 , -0.39465, -0.58060 ),
				vec3( 1, 2.03211, 0 )
			);

			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			// calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion

			var st = calculatedUV.xy;

			var color = vec3( 0 );

			// UV values goes from -1 to 1
			// So we need to remap st (0.0 to 1.0)
			st -= 0.5; // becomes -0.5 to 0.5
			st *= 2.0; // becomes -1.0 to 1.0

			// we pass st as the y & z values of
			// a three dimensional vector to be
			// properly multiply by a 3x3 matrix

			color = yuv2rgb * vec3( 0.5, st.x, st.y );

			pixelColor = vec4( color, 1 );
		}
	}

	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}
```

But the compiler complains: ```Cannot multiply Mat3 and Vec3```.

What's going on?

Well, it looks like HXSL intentionally doesn't support this operation. I got a friendly explanation from Nicolas Cannasse, the creator of Heaps and HXSL. [link](https://github.com/HeapsIO/heaps/pull/812)

The solution is to turn the operation around: Vec3 x Mat3. But to get the same result you have to transpose the matrix.

We change the yuv2rgb variable to

```haxe
var yuv2rgb_transposed = mat3(
	vec3( 1, 1, 1 ),
	vec3( 0, -0.39465, 2.03211 ),
	vec3( 1.13983,  -0.58060, 0 )
);
```

and the color calculation to

```haxe
color = vec3( 0.5, st.x, st.y ) * yuv2rgb_transposed;
```

And everything works fine.

___

[Previous](06_2d_matrices.md) ·  [Home](hxsl.md) · [Next](hxsl.md)
