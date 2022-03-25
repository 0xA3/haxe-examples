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
		
		// Some useful functions
		function mod289_3( x:Vec3 ):Vec3 { return x - floor( x * ( 1.0 / 289.0 )) * 289.0; }
		function mod289_2( x:Vec2 ):Vec2 { return x - floor( x * ( 1.0 / 289.0 )) * 289.0; }
		function permute( x:Vec3 ):Vec3 { return mod289_3((( x * 34.0 ) + 1.0 ) * x ); }

		//
		// Description : GLSL 2D simplex noise function
		//      Author : Ian McEwan, Ashima Arts
		//  Maintainer : ijm
		//     Lastmod : 20110822 (ijm)
		//     License :
		//  Copyright (C) 2011 Ashima Arts. All rights reserved.
		//  Distributed under the MIT License. See LICENSE file.
		//  https://github.com/ashima/webgl-noise
		//
		function snoise( v:Vec2 ):Float {
			// Precompute values for skewed triangular grid
			var c = vec4(	0.211324865405187,
							// (3.0-sqrt(3.0))/6.0
							0.366025403784439,
							// 0.5*(sqrt(3.0)-1.0)
							-0.577350269189626,
							// -1.0 + 2.0 * C.x
							0.024390243902439 );
							// 1.0 / 41.0

			// First corner (x0)
			var i = floor( v + dot( v, c.yy ));
			var x0 = v - i + dot( i, c.xx );

			// Other two corners (x1, x2)
			var i1 = x0.x > x0.y ? vec2( 1, 0 ) : vec2( 0, 1 );
			var x1 = x0.xy + c.xx - i1;
			var x2 = x0.xy + c.zz;

			// Do some permutations to avoid
			// truncation effects in permutation
			i = mod289_2( i );
			var p = permute(
					permute( i.y + vec3( 0, i1.y, 1 ))
					+ i.x + vec3( 0, i1.x, 1 ));
			
			var m = max( 0.5 - vec3(	
				dot( x0, x0 ),
				dot( x1, x1 ),
				dot( x2, x2 )), 0 );
			
			m = m * m;
			m = m * m;
			
			// Gradients:
			//  41 pts uniformly over a line, mapped onto a diamond
			//  The ring size 17*17 = 289 is close to a multiple
			//  of 41 (41*7 = 287)

			var x = 2 * fract( p * c.www ) - 1;
			var h = abs( x ) - 0.5;
			var ox = floor( x + 0.5 );
			var a0 = x - ox;

			// Normalise gradients implicitly by scaling m
			// Approximation of: m *= inversesqrt(a0*a0 + h*h);
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );

			// Compute final noise value at P
			var g = vec3( 0 );
			g.x  = a0.x  * x0.x  + h.x  * x0.y;
			g.yz = a0.yz * vec2( x1.x, x2.x ) + h.yz * vec2( x1.y, x2.y );
			return 130 * dot( m, g );
		}

		function fragment() {
			calculatedUV.y = 1 - calculatedUV.y; // Flip y axis
			calculatedUV.x *= iResolution.x / iResolution.y; // remove width height distortion
			var st = calculatedUV.xy;

			// st.x += time * 0.1;

 		   // Scale the space in order to see the function
			st *= 10;
			
			var color = vec3( snoise( st ) * .5 + .5 );

			pixelColor = vec4( vec3( color ), 1 );
		}
	}
	
	public function new( iResolution:h3d.Vector ) {
		super();
		this.iResolution = iResolution;
	}
}