import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		final r1 = getValue( "Hello", Std.random( 500 )).map( s -> s.toLowerCase()).map( s -> s.substr( 0, 1 ) + "...." );
		final r2 = getValue( "World!", Std.random( 500 )).map( s -> s.toUpperCase());

		final result = Future.ofMany([ r1, r2 ]);
		
		// As soon as all the results are resolved the 'handle' function is called and 
		// the results are in an array in the order we defined in 'ofMany'
		result.handle( a -> trace( a.join( " " ) ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async(( callback ) -> Timer.delay(() -> callback( message ), delay ));
	}
}
