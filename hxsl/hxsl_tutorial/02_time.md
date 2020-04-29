
## 02 Time

The [second example](https://thebookofshaders.com/03/) from The Book of Shaders animates the color on the screen. 

The Main Class for this example is the same as in Hello World.

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
 
This is the shader code.

```haxe
class MainShader extends hxsl.Shader {
	
	static var SRC = {
		@:import h3d.shader.Base2d;

		function fragment() {
			pixelColor = vec4( abs( sin( time )), 0, 0, 1 );
		}
	}
}
```
You can see that the shader code is again pretty similar to the original. We can use ```abs``` and ```sin```. And we don't need to declare a variable to get access to the time. It is already done in ```Base2d``` and is simply called ```time```.

___

[Previous](01_hello_world.md) ·  [Home](hxsl.md) · [Next](03_frag_coord.md)