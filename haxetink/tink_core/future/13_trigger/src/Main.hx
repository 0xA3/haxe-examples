import haxe.Timer;

using tink.CoreApi;

function main() {
	getValue( "World!", 500 ).handle( s -> trace( s ));
	getValue( "Hello", 250 ).handle( s -> trace( s ));
}

function getValue( message:String, delay:Int ) {
	final f = Future.trigger();
	Timer.delay(() -> f.trigger( message ), delay );
	return f.asFuture();
}
