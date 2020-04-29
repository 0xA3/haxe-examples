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

class MainShader extends hxsl.Shader {
	
	static var SRC = {
		@:import h3d.shader.Base2d;

		@param var colorA = vec3( 0.149, 0.141, 0.912 );
		@param var colorB = vec3( 1.000, 0.833, 0.224 );

		function fragment() {
			
			var color = vec3( 0 );
			
			var pct = abs( sin( time ));
			
			// Mix uses pct (a value from 0-1) to
			// mix the two colors
			color = mix( colorA, colorB, pct );

			pixelColor = vec4( color, 1 );
		}
	}
}