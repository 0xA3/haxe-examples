import h2d.Tile;
import h2d.Bitmap;

class Main extends hxd.App {

	var shader:MainShader;

	static function main() {
		new Main();
	}

	override function init() {
		var bmp = new Bitmap( Tile.fromColor( 0, s2d.width, s2d.height ), s2d );
		shader = new MainShader( new h3d.Vector( s2d.width, s2d.height ));
		bmp.addShader( shader );
	}

}

class MainShader extends hxsl.Shader {
	
	static var SRC = {
		@:import h3d.shader.Base2d;
		
		@param var iResolution : Vec2;
		
		// 2D Random
		function random2( p:Vec2 ):Vec2 {
			return fract( sin( vec2( dot( p, vec2(127.1,311.7)), dot( p, vec2( 269.5, 183.3 )))) * 43758.5453 );
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			var aspectRatio = iResolution.x / iResolution.y;
			calculatedUV.x *= aspectRatio; // remove width height distortion
			var st = calculatedUV.xy;

			// Scale
			st *= 3;

			// Tile the space
			var i_st = floor( st );
			var f_st = fract( st );

			var color = vec3( 0 );

			var m_dist = 1.0; // minimum distance

			for( y in -1...2 ) {
				for( x in -1...2 ) {
					// Neighbor place in the grid
					var neighbor = vec2( x, y );

					// Random position from current + neighbor place in the grid
					var point = random2( i_st + neighbor );

					// Animate the point
					point = 0.5 + 0.5 * sin( time + 6.2831 * point );

					// Vector between the pixel and the point
					var diff = neighbor + point - f_st;

					// Distance to the point
					var dist = length( diff );

					// Keep the closer distance
					m_dist = min( m_dist, dist );
				}
			}

			// Draw the min distance (distance field)
			color += m_dist;

			// Draw cell center
			color += 1 - step( .01, m_dist );

			// Draw grid
			color.r += step( .99, f_st.x ) + step( .99, f_st.y );

			pixelColor = vec4( vec3( color ), 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}