
# 03 FragCoord

The [third example](https://thebookofshaders.com/03/) from The Book of Shaders assigns the screen coordinates to colors.

The Main Class for this example is the same as in the previous example.

```haxe
import h2d.Tile;
import h2d.Bitmap;

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

This is the shader code.

```haxe
class MainShader extends hxsl.Shader {

	static var SRC = {
		@:import h3d.shader.Base2d;

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y;
			var st = calculatedUV.xy;
			pixelColor = vec4( st.x, st.y, 0, 1 );
		}
	}
}
```

The original shader divides ```gl_FragCoord``` by the pixel resolution. The ```Base2d``` shader provides a variable ```calculatedUV``` that already does this. I noticed however that the coordinates are mirrored vertically. We can correct this with the line ```calculatedUV.y = 1 - calculatedUV.y```.
___

[Previous](02_time.md) ·  [Home](hxsl.md) · [Next](04_shaping_functions.md)
