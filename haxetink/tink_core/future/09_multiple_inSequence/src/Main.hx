import haxe.Timer;
using tink.CoreApi;

function main() {
	final r1 = getValue( "Hello", Std.random( 50 ));
	final r2 = getValue( "World!", Std.random( 600 ));
	final r3 = getValue( "You!", Std.random( 20 ));

	final helloWorld = Future.inSequence([ r1, r2 ]).map( a -> a.join( " " ));
	final helloYou = Future.inSequence([ r1, r3 ]).map( a -> a.join( " " ));
	
	// HelloYou is resolved before HelloWorld;
	helloWorld.handle( a -> trace( a ));
	helloYou.handle( a -> trace( a ));

	// HelloBoth is resolved after both futures are resolved
	final helloBoth = Future.inSequence([ helloWorld, helloYou ]).map( a -> a.join( " - " ));

	helloBoth.handle( a -> trace( a ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible(( callback ) -> Timer.delay(() -> callback( message ), delay ));
}
