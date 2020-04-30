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
		
		function fragment() {
			
			// YUV to RGB matrix
			var yuv2rgb = mat3(
				vec3( 1, 0, 1.13983 ),
				vec3( 1 , -0.39465, -0.58060 ),
				vec3( 1, 2.03211, 0 )
			);

			// RGB to YUV matrix
			var rgb2yuv = mat3(
				vec3( 0.2126, 0.7152, 0.0722 ),
				vec3( -0.09991, -0.33609, 0.43600 ),
				vec3( 0.615, -0.5586, -0.05639 )
			);
			
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			// calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			
			var st = calculatedUV.xy;
			
			var color = vec3( 0 );
			
			// UV values goes from -1 to 1
			// So we need to remap st (0.0 to 1.0)
			st -= 0.5; // becomes -0.5 to 0.5
			st *= 2.0; // becomes -1.0 to 1.0

			// we pass st as the y & z values of
			// a three dimensional vector to be
			// properly multiply by a 3x3 matrix
			
			color = yuv2rgb * vec3( 0.5, st.x, st.y ); //Error Cannot multiply Mat3 and Vec3

			pixelColor = vec4( color, 1 );

		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}