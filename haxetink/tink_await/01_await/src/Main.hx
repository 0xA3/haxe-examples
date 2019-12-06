import haxe.Timer;
using tink.CoreApi;

@await class Main {
	@await static function main() {
		
		trace( @await getValue( "Hello", 500 ));
		trace( @await getValue( "World!", 250 ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
