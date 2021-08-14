import haxe.Timer;
using tink.CoreApi;

function main() {
	getValue( "World!", 500 ).map( s -> s.toLowerCase()).handle( s -> trace( s ));
	getValue( "Hello", 250 ).map( s -> s.toUpperCase()).handle( s -> trace( s ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible( callback -> Timer.delay(() -> callback( message ), delay ));
}
