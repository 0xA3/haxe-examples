import h2d.Tile;
import h2d.Bitmap;

class Main extends hxd.App {

	static function main() {
		new Main();
	}

	override function init() {
		var bmp = new Bitmap( Tile.fromColor( 0, s2d.width, s2d.height ), s2d );
		var shader = new MainShader();
		bmp.addShader( shader );
	}

}

class MainShader extends hxsl.Shader {
	
	static var SRC = {
		@:import h3d.shader.Base2d;

		@param var TWO_PI = 6.28318530718;

		function rgb2hsb( c:Vec3 ):Vec3 {
			var K = vec4( 0, -1.0 / 3.0, 2.0 / 3.0, -1 );
			var p = mix( 	vec4( c.bg, K.wz ),
							vec4( c.gb, K.xy ),
							step( c.b, c.g ));
			var q = mix( 	vec4( p.xyw, c.r ),
							vec4( c.r, p.yzx ),
							step( p.x, c.r ));
			var d = q.x - min( q.w, q.y );
			var e = 1.0e-10;
			return vec3( 	abs( q.z + ( q.w - q.y ) / ( 6.0 * d + e )),
							d / ( q.x + e ),
							q.x);
		}

		//  Function from Iñigo Quiles
		//  https://www.shadertoy.com/view/MsS3Wc
		function hsb2rgb( c:Vec3 ):Vec3 {
			var rgb = clamp( abs( mod( c.x * 6 + vec3( 0, 4, 2 ), 6 ) -3 ) -1, 0.0,	1.0 );
			rgb = rgb * rgb * ( 3 - 2 * rgb );
			return c.z * mix( vec3( 1 ), rgb, c.y );
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y;
			var st = calculatedUV.xy;
			
			var color = vec3( 0 );
			
			// Use polar coordinates instead of cartesian
			var toCenter = vec2( 0.5 ) - st;
			var angle = atan( toCenter.y, toCenter.x );
			var radius = length( toCenter ) * 2;

			// Map the angle (-PI to PI) to the Hue (from 0 to 1)
			// and the Saturation to the radius
			color = hsb2rgb( vec3(( angle / TWO_PI ) + 0.5, radius, 1 ));
			
			pixelColor = vec4( color, 1 );
		}
	}
}