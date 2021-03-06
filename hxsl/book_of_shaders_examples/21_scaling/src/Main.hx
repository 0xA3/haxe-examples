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
		
		function scale( scaleFactor:Vec2 ):Mat2 {
			return mat2( 	scaleFactor.x, 0.0,
							0.0, scaleFactor.y );
		}

		function scale2( st:Vec2, scaleFactor:Vec2 ):Vec2 {
			st.x *= scaleFactor.x;
			st.y *= scaleFactor.y;

			return st;
		}

		function box( st:Vec2, size:Vec2 ):Float {
			size = vec2( .5 ) - size * .5;
			var uv = smoothstep( size, size + vec2( .001 ), st );
			uv *= smoothstep( size, size + vec2( .001 ), vec2( 1 ) - st );
			return uv.x * uv.y;
		}

		function cross( st:Vec2, size:Float ):Float {
			return box( st, vec2( size, size / 4 )) + box( st, vec2( size / 4, size ));
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			// calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			
			var st = calculatedUV.xy;
			
			var color = vec3( 0 );
			
			// move space from the center to the vec2(0.0)
			st -= vec2( .5 );

			// scale the space
			// st = scale( vec2( sin( time ) + 1 )) * st;
			st = scale2( st, vec2( sin( time ) + 1 ));

			// move it back to the original place
			st += vec2( .5 );

			// Show the coordinates of the space on the background
			// color = vec3( st.x, st.y, 0 );

			// Add the shape on the foreground
			color += vec3( cross( st, 0.25 ));

			pixelColor = vec4( color, 1 );

		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}