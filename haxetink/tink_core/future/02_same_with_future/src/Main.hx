
import haxe.Timer;
using tink.CoreApi;

class Main {
	static function main() {
		
		getValue( "World!", 500 ).handle( s -> trace( s ));
		getValue( "Hello", 250 ).handle( s -> trace( s ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
