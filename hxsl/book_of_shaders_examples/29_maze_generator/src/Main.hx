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
		
		function random( st:Vec2 ):Float {
			return fract( sin( dot( st.xy, vec2( 12.9898,78.233 ))) * 43758.5453123 );
		}

		function truchetPattern( st:Vec2, index:Float ):Vec2 {
			index = fract(( index - 0.5 ) * 2.0 );
			if( index > 0.75 ) {
				st = vec2( 1.0 ) - st;
			} else if( index > 0.5 ) {
				st = vec2( 1.0 - st.x, st.y );
			} else if( index > 0.25 ) {
				st = 1.0 - vec2( 1.0 - st.x, st.y );
			}
			return st;
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			var st = calculatedUV.xy;

			st *= 10;
			// st = ( st - vec2( 5 )) * abs( sin( time * 0.2 ) * 5 );
			// st.x += time * 3;
			
			
			var ipos = floor( st ); // get the integer coords
			var fpos = fract( st ); // get the fractional coords
			
			var tile = truchetPattern( fpos, random( ipos ));

			// Maze
			var color = smoothstep( tile.x - 0.3, tile.x, tile.y ) -
						smoothstep( tile.x, tile.x + 0.3, tile.y );
			
			// Circles
			// var color = (	step( length( tile ), 0.6 ) -
			// 				step( length( tile ), 0.4 )) +
			// 			(	step( length( tile - vec2( 1 )), 0.6 ) -
			// 				step( length( tile - vec2( 1 )), 0.4 ));

			// Truchet ( 2 triangles )
			// var color = step( tile.x, tile.y );
					
			pixelColor = vec4( vec3( color ), 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}