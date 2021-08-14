import haxe.Timer;
using tink.CoreApi;

function main() {
	getAsyncValue( "World!", 500 ).handle( s -> trace( s ));
	getSyncValue( "Hello" ).handle( s -> trace( s ));
}

function getAsyncValue( message:String, delay:Int ) {
	return Future.irreversible( callback -> Timer.delay(() -> callback( message ), delay ));
}

function getSyncValue( message:String )  {
	return Future.sync( message );
}
