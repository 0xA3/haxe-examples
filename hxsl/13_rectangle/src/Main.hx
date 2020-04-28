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
		
		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y;
			var st = calculatedUV.xy;
			
			// bottom-left
			var bl = step( vec2( 0.1 ), st );
			var pct = bl.x * bl.y;

			// top-right
			var tr = step( vec2( 0.1 ), 1 - st );
			pct *= tr.x * tr.y;

			var color = vec3( pct );

			pixelColor = vec4( color, 1 );
		}
	}
}