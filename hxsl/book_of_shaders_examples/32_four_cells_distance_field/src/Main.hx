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

	override function update( dt:Float ) {
		shader.iMouse.x = s2d.mouseX;
		shader.iMouse.y = s2d.height - s2d.mouseY;
	}
}

class MainShader extends hxsl.Shader {
	
	static var SRC = {
		@:import h3d.shader.Base2d;
		
		@param var iResolution : Vec2;
		@param var iMouse : Vec2;
		
		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			var aspectRatio = iResolution.x / iResolution.y;
			calculatedUV.x *= aspectRatio; // remove width height distortion
			var st = calculatedUV.xy;

    		// Cell positions
			var point = [
				vec2( 0.83, 0.75 ),
				vec2( 0.60, 0.07 ),
				vec2( 0.28, 0.64 ),
				vec2( 0.31, 0.26 ),
				vec2( iMouse.x / iResolution.x * aspectRatio, iMouse.y / iResolution.y )
			];
			
			var m_dist = 1.; // minimum distance

			// Iterate through the points positions
			for( i in 0...5 ) {
				var dist = distance( st, point[i] );

				// Keep the closer distance
				m_dist = min( m_dist, dist );
			}

			// Draw the min distance (distance field)

			var color = vec3( m_dist );
			color += 1 - step( .002, m_dist );

			pixelColor = vec4( color, 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
		this.iMouse = new h3d.Vector( 0, 0 );
	}
}