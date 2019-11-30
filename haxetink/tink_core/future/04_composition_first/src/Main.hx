import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		final r1 = getValue( "Hello", 250 );
		final r2 = getValue( "World!", 500 );

		r1.first( r2 ).handle( s -> trace( s ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
