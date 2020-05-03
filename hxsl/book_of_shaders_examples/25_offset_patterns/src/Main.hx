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
		
		function brickTile( st:Vec2, zoom:Float ):Vec2 {
			st *= zoom;

			// Here is where the offset is happening
			st.x += step( 1, mod( st.y, 2 )) * .5;
			return fract( st );
		}

		function box( st:Vec2, size:Vec2, smoothEdges:Float ):Float {
			size = vec2( .5 ) - size * .5;
			var aa = vec2( smoothEdges * .5 );
			var uv = smoothstep( size, size + aa, st );
			uv *= smoothstep( size, size + aa, vec2( 1 ) - st );
			return uv.x * uv.y;
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			// calculatedUV -= 0.5; // move 0 0 to center of screen
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			
			var st = calculatedUV.xy;
			var color = vec3( 0 );
			
			// Modern metric brick of 215mm x 102.5mm x 65mm
			// http://www.jaharrison.me.uk/Brickwork/Sizes.html
			// st /= vec2(2.15,0.65)/1.5;

			// Apply the brick tiling
			st = brickTile( st, 5 );

			// Draw a square
			color = vec3( box( st, vec2( 0.9 ), .01 ));

			pixelColor = vec4( color, 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}