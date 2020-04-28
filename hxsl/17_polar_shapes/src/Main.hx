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
			
			var pos = calculatedUV.xy;
			
			var r = length( pos ) * 2;
			var a = atan( pos.y, pos.x );

			var f = cos( a * 3 );
			// var f = abs( cos( a * 3 ));
			// var f = abs( cos( a * 2.5 )) * .5 + .3;
			// var f = abs( cos( a * 12 ) * sin( a * 3 )) * .8 + .1;
			// var f = smoothstep( -.5, 1, cos( a * 10 )) * .2 + .5;

			var color = vec3( 1 - smoothstep( f, f + 0.02, r ));

			pixelColor = vec4( color, 1 );

		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}