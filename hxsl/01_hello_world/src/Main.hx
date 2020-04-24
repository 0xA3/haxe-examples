import h2d.Tile;
import h2d.Bitmap;

class Main extends hxd.App {

	static function main() {
		// embed the resources
		new Main();
	}

	override function init() {
		var bmp = new Bitmap( Tile.fromColor( 0, s2d.width, s2d.height ), s2d );
		var shader = new BaseShader();
		bmp.addShader( shader );
	}

}

class BaseShader extends hxsl.Shader {
	
	static var SRC = {
		@:import h3d.shader.Base2d;

		function fragment() {
			pixelColor = vec4( 1, 0, 1, 1 );
		}
	}
}