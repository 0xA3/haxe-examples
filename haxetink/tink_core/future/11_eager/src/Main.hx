import haxe.Timer;
using tink.CoreApi;

function main() {
	getValueWithTrace( "World!", 500, false );
	getValueWithTrace( "Hello", 250, true );
}

function getValueWithTrace( message:String, delay:Int, eager:Bool ):Any {
	final future = Future.irreversible(
		callback -> Timer.delay(() -> {	
			trace( "delay for " + message + " is completed" );
			callback( message );
		}, delay )
	);
	
	return eager ? future.eager() : future;			
}
