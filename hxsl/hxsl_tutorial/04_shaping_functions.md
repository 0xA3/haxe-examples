
## 04 Shaping functions

The examples [on this page](https://thebookofshaders.com/05/) display different interpolation types.

The Main Class still stays the same.

```haxe
class Main extends hxd.App {
	
	static function main() {
		new Main();
	}

	override function init() {
		var bmp = new Bitmap( Tile.fromColor( 0, s2d.width, s2d.height ), s2d );
		var shader = new MainShader();
		bmp.addShader( shader );
	}
}
```
 
Let's start with linear interpolation.

```haxe
class MainShader extends hxsl.Shader {
	
	static var SRC = {
		@:import h3d.shader.Base2d;

		// Plot a line on Y using a value between 0.0-1.0
		function plot( st:Vec2, pct:Float ):Float {
			return 	smoothstep( pct-0.02, pct, st.y ) -
					smoothstep( pct, pct+0.02, st.y );
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y;
			var st = calculatedUV.xy;
			
			var y = st.x;

			var color = vec3( y );
			
			// Plot a line
			var pct = plot( st, y );
			color = ( 1 - pct ) * color + pct * vec3( 0, 1, 0 );

			pixelColor = vec4( color, 1 );
		}
	}
}
```

It gets a little bit more complex but the conversion form GLSL to HXSL is straightforward.

We create the addition ```plot``` method inside of ```SRC``` and call it from ```fragment```.  

The implementations for [exponential interpolation](../book_of_shaders_examples/05_exponential_interpolation/src/Main.hx), [step](../book_of_shaders_examples/06_step/src/Main.hx) and [smoothstep](../book_of_shaders_examples/07_smoothstep/src/Main.hx) are very similar.
___

[Previous](03_frag_coord.md) ·  [Home](hxsl.md) · [Next](05_danguafer_creation_by_silexars.md)