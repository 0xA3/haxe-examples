
# 05 Creation by Silexars

Further down on the [page](https://thebookofshaders.com/05/) finally a challenge. The [demoscene shader by Danguafer](https://www.shadertoy.com/view/XsXXDn).

For this shader we need the resolution in pixels to calculate the aspect ratio. So our ```MainShader``` gets a custom constructor with a ```Vector``` for the screen width and height of the application. This changes our ```Main``` class slightly.

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

	// based on
	// http://www.pouet.net/prod.php?which=57245
	// If you intend to reuse this shader, please add credits to 'Danilo Guanabara'
	static var SRC = {
		@:import h3d.shader.Base2d;

		@param var r : Vec2;
		
		function fragment() {

			var c = vec3( 0, 0, 0 );
			var l = 0.0;
			var z = time;

			var c0 = 0.;
			var c1 = 0.;
			var c2 = 0.;

			for( i in 0...3 ) {
				var p = calculatedUV.xy;
				var uv = p;
				p -= .5;
				p.x *= r.x / r.y;
				z += .07;
				l = length( p );
				uv += p / l * ( sin( z ) + 1 ) * abs( sin( l * 9 - z * 2 ));

				var result = .01 / length( mod( uv, 1 ) -.5 );
				if( i == 0 ) c.r = result;
				if( i == 1 ) c.g = result;
				if( i == 2 ) c.b = result;
			}

			pixelColor = vec4( c / l, time );
		}
	}

	public function new( iResolution:h3d.Vector ) {
		super();
		this.r = iResolution;
	}
}
```

Let's take a closer look at the ```MainShader```.

First there is this

```haxe
@param var r : Vec2;
```

which declares the ```r``` to be variable that can be changed from outside the shader.

In the constuctor at the bottom of the shader code the resolution vector is assigned to ```r```.

```haxe
public function new( iResolution:h3d.Vector ) {
	super();
	this.r = iResolution;
}
```

There are a bunch of assignments and calculations and a ```for``` loop.

In GLSL you can assign and access vector data by index position ```c[i]=...``` This is not yet implmented in HXSL.
Therefore I translated the line

```glsl
c[i]=.01/length(abs(mod(uv,1.)-.5));
```

of the original code to

```haxe
var result = .01 / length( mod( uv, 1 ) -.5 );
if( i == 0 ) c.r = result;
if( i == 1 ) c.g = result;
if( i == 2 ) c.b = result;
```

which is sadly not very elegant but it works.  

___

[Previous](04_shaping_functions.md) ·  [Home](hxsl.md) · [Next](06_2d_matrices.md)
