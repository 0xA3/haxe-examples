import haxe.Timer;
using tink.CoreApi;

class Main {
	static function main() {
		
		getAsyncValue( "World!", 500 ).handle( s -> trace( s ));
		getSyncValue( "Hello" ).handle( s -> trace( s ));
	}
	
	static function getAsyncValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}

	static function getSyncValue( message:String )  {
		return Future.sync( message );
	}
}
