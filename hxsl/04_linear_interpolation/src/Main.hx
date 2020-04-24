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
			
			// plot a line
			var pct = plot( st, y );
			color = ( 1-pct ) * color + pct * vec3( 0, 1, 0 );

			pixelColor = vec4( color, 1 );
		}
	}
}