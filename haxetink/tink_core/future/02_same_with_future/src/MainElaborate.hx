import haxe.Timer;

using tink.CoreApi;

function main() {
	final future = getValue( "Hello dummy", 250 );
	
	final callback = function( s ) {
		trace( s );
	}
	
	future.handle( callback );
}

function getValue( message:String, delay:Int ) {
	final init = function( callback ) {
		final timer = new Timer( delay );
		
		final run = function() {
			timer.stop();
			callback( message );
		}
		timer.run = run;
	}

	return Future.irreversible( init );
}
