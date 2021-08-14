import haxe.Timer;

using tink.CoreApi;

class Loop {

	final id:String;
	final delay:Int;
	final max:Int;

	var counter = 0;
	var f:FutureTrigger<Noise>;

	public function new( id:String, delay:Int, max:Int ) {
		this.id = id;
		this.delay = delay;
		this.max = max;
	}

	public function start() {
		f = Future.trigger();
		next();
		return f.asFuture();
	}

	public function next() {
		trace( '$id: $counter' );
		counter++;
		Timer.delay(() -> if( counter < max ) next() else f.trigger( Noise ), delay );
	}
}