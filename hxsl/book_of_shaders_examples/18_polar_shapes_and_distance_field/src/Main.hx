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
		
		@param var TWO_PI = 6.28318530718;
		@param var iResolution : Vec2;
		
		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			
			var st = calculatedUV.xy * 2;
			
			// Number of sides of your shape
			var N = 3;
			
			// Angle and radius from the current pixel
			var a = atan( st.x, st.y ) + PI;
			var r = TWO_PI / float( N );

			// Shaping function that modulate the distance
			var d = cos( floor( .5 + a / r ) * r - a ) * length( st );

			var color = vec3( 1 - smoothstep( .4, .41, d ));

			pixelColor = vec4( color, 1 );

		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}