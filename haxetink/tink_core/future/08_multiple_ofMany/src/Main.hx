import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		final r1 = getValue( "Hello", Std.random( 50 ));
		final r2 = getValue( "World!", Std.random( 600 ));
		final r3 = getValue( "You!", Std.random( 20 ));

		final helloWorld = Future.ofMany([ r1, r2 ]).map( a -> a.join( " " ));
		final helloYou = Future.ofMany([ r1, r3 ]).map( a -> a.join( " " ));
		
		// HelloYou is resolved before HelloWorld;
		helloWorld.handle( a -> trace( a ));
		helloYou.handle( a -> trace( a ));

		// HelloBoth is resolved after both futures are resolved
		final helloBoth = Future.ofMany([ helloWorld, helloYou ]).map( a -> a.join( " - " ));

		helloBoth.handle( a -> trace( a ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async(( callback ) -> Timer.delay(() -> callback( message ), delay ));
	}
}
