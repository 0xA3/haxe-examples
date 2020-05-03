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

		function box( st:Vec2, size:Vec2, smoothEdges:Float ):Float {
			size = vec2( .5 ) - size * .5;
			var aa = vec2( smoothEdges * .5 );
			var uv = smoothstep( size, size + aa, st );
			uv *= smoothstep( size, size + aa, vec2( 1 ) - st );
			return uv.x * uv.y;
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			// calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			
			var st = calculatedUV.xy;
			var color = vec3( 0 );
			
			// Divide the space in 4
			st = tile( st, 4 );
			
			// Use a matrix to rotate the space 45 degrees
			st = rotate2d( st, PI * .25 );

			// Draw a square
			color = vec3( box( st, vec2( 0.7 ), .01 ));

			pixelColor = vec4( color, 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}