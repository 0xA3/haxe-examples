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
	
	// based on
	// http://www.pouet.net/prod.php?which=57245
	// If you intend to reuse this shader, please add credits to 'Danilo Guanabara'
	static var SRC = {
		@:import h3d.shader.Base2d;

		@param var r : Vec2;
		
		function fragment() {
			
			var c = vec3( 0, 0, 0 );
			var l = 0.0;
			var z = time;

			var c0 = 0.;
			var c1 = 0.;
			var c2 = 0.;

			for( i in 0...3 ) {
				var p = calculatedUV.xy;
				var uv = p;
				p -= .5;
				p.x *= r.x / r.y;
				z += .07;
				l = length( p );
				uv += p / l * ( sin( z ) + 1 ) * abs( sin( l * 9 - z * 2 ));
				
				var result = .01 / length( mod( uv, 1 ) -.5 );
				if( i == 0 ) c.r = result;
				if( i == 1 ) c.g = result;
				if( i == 2 ) c.b = result;
			}
			
			pixelColor = vec4( c / l, time );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.r = iResolution;
	}
}