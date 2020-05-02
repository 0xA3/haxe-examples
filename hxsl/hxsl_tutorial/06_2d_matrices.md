
# 06 2D Matrices

Now back to some more basic stuff: Translation, rotation and scaling with [2D Matrices](https://thebookofshaders.com/08/).

The shader for translation is very much like the glsl code.

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
		
		function box( st:Vec2, size:Vec2 ):Float {
			size = vec2( .5 ) - size * .5;
			var uv = smoothstep( size, size + vec2( .001 ), st );
			uv *= smoothstep( size, size + vec2( .001 ), vec2( 1 ) - st );
			return uv.x * uv.y;
		}

		function cross( st:Vec2, size:Float ):Float {
			return box( st, vec2( size, size / 4 )) + box( st, vec2( size / 4, size ));
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion

			var st = calculatedUV.xy;

			// To move the cross we move the space
			var translate = vec2( cos( time ), sin( time ));
			st += translate * .35;

			var color = vec3( 0 );

			// Show the coordinates of the space on the background
			// color = vec3( st.x, st.y, 0 );

			// Add the shape on the foreground
			color += vec3( cross( st, 0.25 ));

			pixelColor = vec4( color, 1 );

		}
	}

	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}
```

The rotation and scale examples are done with a 2D Matrix. This should also be pretty straightforward to do in HXSL.

I was a little surprised when rotation shader code did not compile with the error message ```Unsupported type Mat2```.

After browsing through the sourcecode I discovered that the 2D matrix type ist actually not implemented. I guess it never came up in previous projects or just wasn't that important.

 I rewrote the rotate2d method to directly calculate the resulting vector. I will update this tutorial when Mat2 is implemented in one of the next Heaps versions.

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
		
		function rotate2d( st:Vec2, angle:Float ):Vec2 {
			var x = st.x;
			var y = st.y;

			st.x = x * cos( angle ) - y * sin( angle );
			st.y = x * sin( angle ) + y * cos( angle );

			return st;
		}

		function box( st:Vec2, size:Vec2 ):Float {
			size = vec2( .5 ) - size * .5;
			var uv = smoothstep( size, size + vec2( .001 ), st );
			uv *= smoothstep( size, size + vec2( .001 ), vec2( 1 ) - st );
			return uv.x * uv.y;
		}

		function cross( st:Vec2, size:Float ):Float {
			return box( st, vec2( size, size / 4 )) + box( st, vec2( size / 4, size ));
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion

			var st = calculatedUV.xy;

			var color = vec3( 0 );

			// move space from the center to the vec2(0.0)
			st -= vec2( .5 );

			// rotate the space
			var st = rotate2d( st, sin( time ) * PI );

			// move it back to the original place
			st += vec2( .5 );

			// Show the coordinates of the space on the background
			// color = vec3( st.x, st.y, 0 );

			// Add the shape on the foreground
			color += vec3( cross( st, 0.25 ));

			pixelColor = vec4( color, 1 );

		}
	}

	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}
```

Same with scaling. In the Book of Shaders example it is done with a 2D Matrix. But it can easily be implemented by just multiplications.

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
		
		function scale( st:Vec2, scaleFactor:Vec2 ):Vec2 {
			st.x *= scaleFactor.x;
			st.y *= scaleFactor.y;

			return st;
		}

		function box( st:Vec2, size:Vec2 ):Float {
			size = vec2( .5 ) - size * .5;
			var uv = smoothstep( size, size + vec2( .001 ), st );
			uv *= smoothstep( size, size + vec2( .001 ), vec2( 1 ) - st );
			return uv.x * uv.y;
		}

		function cross( st:Vec2, size:Float ):Float {
			return box( st, vec2( size, size / 4 )) + box( st, vec2( size / 4, size ));
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion

			var st = calculatedUV.xy;

			var color = vec3( 0 );

			// move space from the center to the vec2(0.0)
			st -= vec2( .5 );

			// scale the space
			st = scale( st, vec2( sin( time ) + 1 ));

			// move it back to the original place
			st += vec2( .5 );

			// Show the coordinates of the space on the background
			// color = vec3( st.x, st.y, 0 );

			// Add the shape on the foreground
			color += vec3( cross( st, 0.25 ));

			pixelColor = vec4( color, 1 );

		}
	}

	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}
```

___

[Previous](05_danguafer_creation_by_silexars.md) ·  [Home](hxsl.md) · [Next](hxsl.md)
