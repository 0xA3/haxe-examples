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
		
		function circle( st:Vec2, radius:Float ):Float {
			var l = st - vec2( 0.5 );
			return 1 - smoothstep( radius - ( radius * .01 ), radius + ( radius * .01), dot( l, l ) * 4 );
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			// calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			
			var st = calculatedUV.xy;
			
			var color = vec3( 0 );
			
			st *= 3;			// Scale up the space by 3
			st = fract( st );	// Wrap arround 1.0

			// Now we have 3 spaces that goes from 0-1

			// color = vec3( st, 0 );
			color = vec3( circle( st, 0.5 ));

			pixelColor = vec4( color, 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}