
import haxe.Timer;
using tink.CoreApi;

class Main {
	static function main() {
		
		getValue( "World!", 500 ).map( s -> s.toLowerCase()).handle( s -> trace( s ));
		getValue( "Hello", 250 ).map( s -> s.toUpperCase()).handle( s -> trace( s ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
