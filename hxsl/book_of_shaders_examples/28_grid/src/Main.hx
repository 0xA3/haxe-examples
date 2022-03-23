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

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			var st = calculatedUV.xy;

			st *= 10; // Scale the coordinate system by 10
			var ipos = floor( st ); // get the integer coords
			var fpos = fract( st ); // get the fractional coords
			
			// Assign a random value based on the integer coord
			var color = vec3( random( ipos ) );
			
			// Uncomment to see the subdivided grid
			// color = vec3(fpos,0.0);
			
			pixelColor = vec4( color, 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}