import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		getValueWithTrace( "World!", 500, true );
		getValueWithTrace( "Hello", 250, false );
	}

	static function getValueWithTrace( message:String, delay:Int, lazy:Bool ) {
		return Future.async(
			callback -> Timer.delay(() -> {	
				trace( "delay for " + message + " is completed" );
				callback( message ); }, delay ),
			lazy );
	}
}