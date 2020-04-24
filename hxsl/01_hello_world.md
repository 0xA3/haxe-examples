
## 01 "Hello World!"

The [first example](https://thebookofshaders.com/02/) from The Book of Shaders just displays a single color on the screen. 

To recreate that in Heaps we first create a new application with an init method. The ```init``` method creates a new 
fullscreen bitmap and adds the class ```BaseShader```.

```haxe
class Main extends hxd.App {
	
	static function main() {
		new Main();
	}

	override function init() {
		var bmp = new Bitmap( Tile.fromColor( 0, s2d.width, s2d.height ), s2d );
		var shader = new BaseShader();
		bmp.addShader( shader );
	}
}
```
 
We create a new class BaseShader that extends hxsl.Shader.  
A shader class only has one static variable SRC that contains all the code for the shader.

```haxe
class BaseShader extends hxsl.Shader {
	
	static var SRC = {
		@:import h3d.shader.Base2d;

		function fragment() {
			pixelColor = vec4( 1, 0, 1, 1 );
		}
	}
}
```
When compiling and running it should show an empty screen with a bright color. Great!

Let's take a look at the shader code.  
First we have an import statement. It imports useful parameters from a predefined Base2d shader.

```haxe
@:import h3d.shader.Base2d;
```

Then we have the fragment method. Here we set the variable ```pixelColor``` which corresponds to ```gl_FragColor``` in the original code. One advantage of HXSL is that we don't have to use float values for vec4. The compiler converts them automatically. 

```haxe
function fragment() {
	pixelColor = vec4( 1, 0, 1, 1 );
}
```

___

[Previous](hxsl.md) ·  [Home](hxsl.md) · Next