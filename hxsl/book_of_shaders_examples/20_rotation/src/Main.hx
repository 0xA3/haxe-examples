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
		
		// rotate2d_1 with Mat2
		// function rotate2d_1( angle:Float ):Mat2 {
		// 	return 	mat2(	cos(angle), -sin(angle),
		// 		        	sin(angle),cos(angle)); 
		// }

		// rotate2d_2 with Mat3
		function rotate2d_2( angle:Float ):Mat3 {
			return 	mat3(
				vec3( cos(angle), -sin(angle), 0 ),
				vec3( sin(angle), cos(angle), 0 ),
				vec3( 0, 0, 1 ));
		}

		// rotate2d_2 manually calculates the new angle
		function rotate2d_3( st:Vec2, angle:Float ):Vec2 {
			var x = st.x;
			var y = st.y;
			
			st.x = x * cos( angle ) - y * sin( angle );
			st.y = x * sin( angle ) + y * cos( angle );

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

			// rotate the space
			
			// rotate2d_1 with Mat2
			// st = rotate2d_1( sin( time ) * PI ) * st; // Error: Unsupported type Mat2
			
			// rotate2d_2 uses Mat3
			// var st3 = rotate2d_2( sin( time ) * PI ) * vec3( st, 1 ); // Error: Cannot multiply Mat3 and Vec3
			// st = st3.xy;
			
			// rotate2d_3 manually calculates the values
			st = rotate2d_3( st, sin( time ) * PI );

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