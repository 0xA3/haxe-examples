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
	
	static var SRC = {
		@:import h3d.shader.Base2d;
		
		@param var iResolution : Vec2;
		
		function rotate2d( st:Vec2, angle:Float ):Vec2 {
			st -= 0.5;
			
			var x = st.x;
			var y = st.y;
			st.x = x * cos( angle ) - y * sin( angle );
			st.y = x * sin( angle ) + y * cos( angle );

			st += 0.5;
			return st;
		}
		
		function tile( st:Vec2, zoom:Float ):Vec2 {
			st *= zoom;
			return fract( st );
		}

		function rotateTilePattern( st:Vec2 ):Vec2 {

			//  Scale the coordinate system by 2x2
			st *= 2;

			//  Give each cell an index number
			//  according to its position
			var index = 0.0;
			index += step( 1, mod( st.x, 2 ));
			index += step( 1, mod( st.y, 2 )) * 2;

			//      |
			//  2   |   3
			//      |
			//--------------
			//      |
			//  0   |   1
			//      |

			// Make each cell between 0.0 - 1.0
			st = fract( st );

			// Rotate each cell according to the index
			if( index == 1.0 ) {
				//  Rotate cell 1 by 90 degrees
				st = rotate2d( st, PI * .5 );
			} else if( index == 2.0 ) {
				//  Rotate cell 2 by -90 degrees
				st = rotate2d( st, PI * -.5 );
			} else if( index == 3.0 ) {
				//  Rotate cell 3 by 180 degrees
				st = rotate2d( st, PI );
			}

			return st;
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			// calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			
			var st = calculatedUV.xy;
			var color = vec3( 0 );
			
			st = tile( st, 3 );
			st = rotateTilePattern( st );

			// Make more interesting combinations
			// st = tile( st, 2 );
			// st = rotate2d( st, -PI * time * .25 );
			// st = rotateTilePattern( st * 2 );
			// st = rotate2d( st, PI * time * .25 );

			// step(st.x,st.y) just makes a b&w triangles
			// but you can use whatever design you want.
			color = vec3( step( st.x, st.y ));

			pixelColor = vec4( color, 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}