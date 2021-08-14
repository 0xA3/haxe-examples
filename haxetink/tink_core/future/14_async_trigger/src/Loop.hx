import haxe.Timer;

using tink.CoreApi;

class Loop {

	final max:Int;

	var counter = 0;
	var f:FutureTrigger<Noise>;

	public function new( max:Int ) {
		this.max = max;
	}

	public function start() {
		f = Future.trigger();
		next();
		return f.asFuture();
	}

	public function next() {
		trace( counter );
		counter++;
		Timer.delay(() -> if( counter < max ) next() else f.trigger( Noise ), 500 );
	}
}