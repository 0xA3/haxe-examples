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
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			
			var d = 0.0;
			
			// Remap the space to -1 to 1
			var st = calculatedUV * 2;
			
			// Make the distance field
			d = length( abs( st ) - .3 );
			// d = length( min( abs( st ) - .3, 0 ));
			// d = length( max( abs( st ) - .3, 0 ));
			
			// Visualize the distance field
			pixelColor = vec4( vec3( fract( d * 10 )), 1 );

			// Drawing with the distance field
			// pixelColor = vec4( vec3( step( .3, d )), 1 );
			// pixelColor = vec4( vec3( step( .3, d ) * step( d, .4 )), 1 );
			// pixelColor = vec4( vec3( smoothstep( .3, .4, d ) * smoothstep( .6, .5, d )), 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}