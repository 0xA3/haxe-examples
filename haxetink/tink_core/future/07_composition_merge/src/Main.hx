import haxe.Timer;
using tink.CoreApi;

function main() {
	final r1 = getValue( "Hello", Std.random( 500 ));
	final r2 = getValue( "World!", Std.random( 500 ));

	final r12 = r1.merge( r2, ( s1, s2 ) -> s1 + " " + s2 );
	r12.handle( s -> trace( s ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible( callback -> Timer.delay(() -> callback( message ), delay ));
}
