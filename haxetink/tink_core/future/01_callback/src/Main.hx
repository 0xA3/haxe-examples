import haxe.Timer;

class Main {
	
	static function main() {
		
		getValue( "World!", 500, s -> trace( s ));
		getValue( "Hello", 250, s -> trace( s ));
	}

	static function getValue( message:String, delay:Int, callback:String -> Void ) {
		
/* 		final timer = new Timer( delay );
		timer.run = () -> {
			timer.stop();
			callback( message );
		}
 */		
		// is the same
		Timer.delay(() -> callback( message ), delay );
	}
}
