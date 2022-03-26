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

		// Based on Morgan McGuire @morgan3d
		// https://www.shadertoy.com/view/4dS3Wd
		function noise( st:Vec2 ):Float {
			var i = floor( st );
			var f = fract( st );

			// Four corners in 2D of a tile
			var a = random( i );
			var b = random( i + vec2( 1.0, 0.0 ));
			var c = random( i + vec2( 0.0, 1.0 ));
			var d = random( i + vec2( 1.0, 1.0 ));

			var u = f * f * ( 3.0 - 2.0 * f );

			return mix( a, b, u.x ) + ( c - a ) * u.y * ( 1.0 - u.x ) + ( d - b ) * u.x * u.y;
		}
		
		function fbm( st:Vec2 ):Float {
			// Initial values
			var value = 0.;
			var amplitude = .5;
			var frequency = 0.;
			var octaves = 6;

			// Loop of octaves
			for( i in 0...octaves ) {
				value += amplitude * noise( st );
				st *= 2;
				amplitude *= .5;
			}
			return value;
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			var st = calculatedUV.xy;

			var color = vec3( 0 );
			color += fbm( st * 3 );
			
			pixelColor = vec4( color, 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}