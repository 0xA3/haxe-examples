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
		
		// Plot a line on Y using a value between 0.0-1.0
		function plot( st:Vec2, pct:Float ):Float {
			return 	smoothstep( pct-0.02, pct, st.y ) -
					smoothstep( pct, pct+0.02, st.y );
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y;
			var st = calculatedUV.xy;
			
			var color = vec3( 0 );
			
			// plot a line
			var pct = vec3( st.x );
			pct.r = smoothstep( 0, 1, st.x );
			pct.g = sin( st.x * PI );
			pct.b = pow( st.x, 0.5 );
			color = mix( colorA, colorB, pct );

			// Plot transition lines for each channel
			color = mix( color, vec3( 1, 0, 0 ), plot( st, pct.r ));
			color = mix( color, vec3( 0, 1, 0 ), plot( st, pct.g ));
			color = mix( color, vec3( 0, 0, 1 ), plot( st, pct.b ));
			
			pixelColor = vec4( color, 1 );
		}
	}
}