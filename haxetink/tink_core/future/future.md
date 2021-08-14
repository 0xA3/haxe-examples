# Future

A Future is a value that is the result of a potentially asynchronous operation.

The tink [documentation](https://haxetink.github.io/tink_core/#/types/future) is already very detailed. For a better understanding it helped me to create some complete examples to see multiple aspects of futures in action.

## 01 Callback

To make it easier to understand the first example is of a callback. A callback is a standard way to deal with asynchrony.

```haxe
import haxe.Timer;

function main() {
	getValue( "World!", 500, s -> trace( s ));
	getValue( "Hello", 250, s -> trace( s ));
}

function getValue( message:String, delay:Int, callback:String -> Void ) {
	Timer.delay(() -> callback( message ), delay );
}
```

The getValue function receives a message, a delay and a callback. After the number of milliseconds specified in 'delay' have passed, the callback function is called with the message.

The main function first calls 'getValue' with the message "World!" and delay 500ms, then with "Hello" and delay 250. The callback just traces the result. 'Hello' is traced first because the delay is shorter.

The output is

```bash
src/Main.hx:8: Hello
src/Main.hx:7: World!
```

Now let's create the exact same program with Futures

## 02 Same thing with Futures

```haxe
import haxe.Timer;
using tink.CoreApi;

function main() {
	getValue( "World!", 500 ).handle( s -> trace( s ));
	getValue( "Hello", 250 ).handle( s -> trace( s ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible( callback -> Timer.delay(() -> callback( message ), delay ) );
}
```

What has changed?
The getValue function only gets the message and the delay. An async Future is created by defining a function to serve as callback. It returns a Future which can be processed with 'handle'.

The output is the same

```bash
src/Main.hx:8: Hello
src/Main.hx:7: World!
```

So what can we do with this?

## 03 Transformation

```haxe
import haxe.Timer;
using tink.CoreApi;

function main() {
	getValue( "World!", 500 ).map( s -> s.toLowerCase()).handle( s -> trace( s ));
	getValue( "Hello", 250 ).map( s -> s.toUpperCase()).handle( s -> trace( s ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible( callback -> Timer.delay(() -> callback( message ), delay ));
}
```

Before handling the result there are map functions that transform "World!" to lowercase and "Hello" to uppercase.

```bash
src/Main.hx:9: HELLO
src/Main.hx:8: world!
```

## 04 Future composition first

```haxe
import haxe.Timer;
using tink.CoreApi;

function main() {
	final r1 = getValue( "Hello", 250 );
	final r2 = getValue( "World!", 500 );

	r1.first( r2 ).handle( s -> trace( s ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible( callback -> Timer.delay(() -> callback( message ), delay ));
}
```

Only the first result is handled.

```bash
src/Main.hx:11: Hello
```

## 05 Future composition inSequence

```haxe
import haxe.Timer;
using tink.CoreApi;

function main() {
	final r1 = getValue( "Hello", Std.random( 500 ));
	final r2 = getValue( "World!", Std.random( 500 ));

	final result = Future.inSequence([ r1, r2 ]);
	
	result.handle( a -> trace( a.join( " " ) ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible( callback -> Timer.delay(() -> callback( message ), delay ));
}
```

Future.inSequence constructs an array of the results which then can be handled with a single handle function. The order of the results is always as specified in 'inSequence' and handle is called when all results are available. Because of this the delay for r1 and r2 can be random. The output will always be

```bash
src/Main.hx:15: Hello World!
```

## 06 Future composition inParallel

```haxe
import haxe.Timer;
using tink.CoreApi;

function main() {
	final r1 = getValue( "Hello", Std.random( 500 ));
	final r2 = getValue( "World!", Std.random( 100 ));

	final result = Future.inParallel([ r1, r2 ] );
	
	result.handle( a -> trace( a.join( " " ) ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible( callback -> Timer.delay(() -> callback( message ), delay ));
}
```

Future.inParallel creates the sames result as inSequence but the futures are processed simultaneously. There ist an optional parameter 'concurrency' to limit how many are processed at a time.

```bash
src/Main.hx:15: Hello World!
```

## 07 Future composition merge

```haxe
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
```

Merges the two results. Note: Futures are lazy by default in tink_core 2.0. That means it only tries to fetch the result if there is a handle function call.

```bash
src/Main.hx:11: Hello World!
```

## 08 Map and composition

One advantage of futures is that we can combine all the functionality and still get consistent results. Here an example with multiple maps and inSequence

```haxe
import haxe.Timer;
using tink.CoreApi;

function main() {
	final r1 = getValue( "Hello", Std.random( 500 )).map( s -> s.toLowerCase()).map( s -> s.substr( 0, 1 ) + "...." );
	final r2 = getValue( "World!", Std.random( 500 )).map( s -> s.toUpperCase());

	final result = Future.inSequence([ r1, r2 ]);
	
	result.handle( a -> trace( a.join( " " ) ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible(( callback ) -> Timer.delay(() -> callback( message ), delay ));
}
```

And the output is

```bash
src/Main.hx:15: h.... WORLD!
```

## 09 Multiple inSequence

```haxe
import haxe.Timer;
using tink.CoreApi;

function main() {
	final r1 = getValue( "Hello", Std.random( 50 ));
	final r2 = getValue( "World!", Std.random( 600 ));
	final r3 = getValue( "You!", Std.random( 20 ));

	final helloWorld = Future.inSequence([ r1, r2 ]).map( a -> a.join( " " ));
	final helloYou = Future.inSequence([ r1, r3 ]).map( a -> a.join( " " ));
	
	// HelloYou is resolved before HelloWorld;
	helloWorld.handle( a -> trace( a ));
	helloYou.handle( a -> trace( a ));

	// HelloBoth is resolved after both futures are resolved
	final helloBoth = Future.inSequence([ helloWorld, helloYou ]).map( a -> a.join( " - " ));

	helloBoth.handle( a -> trace( a ));
}

function getValue( message:String, delay:Int ) {
	return Future.irreversible(( callback ) -> Timer.delay(() -> callback( message ), delay ));
}
```

We can even compose new Futures on multiple levels.
Here r1 and r2 are composed to the Future 'helloWorld'. r1 and r3 are composed to 'helloYou'. Both are handled separately but are also composed to 'helloBoth'.

The output is

```bash
src/Main.hx:17: Hello You!
src/Main.hx:16: Hello World!
src/Main.hx:22: Hello World! - Hello You!
```

## 10 Sync and async values

```haxe
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
```

Futures don't have to be asynchronous. You can also handle synchronous values in exactly the same way.

## 11 Eager

```haxe
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
```

A Future has the additional method 'eager'.
If eager is true the callback definition of the Future is called right after it is defined.
If eager is false is only called after there is a handler for the Future.

In this example there are no handlers for both futures but the timer for "Hello" is executed and completed.

The output is

```bash
src/Main.hx:15: delay for Hello is completed
```

## 12 Outcome

```haxe
using tink.CoreApi;

function main() {
	final handleOutcome = function( o:Outcome<String, String> ) {
		switch o {
			case Success(data): trace( data + " is a success" );
			case Failure(failure): trace( failure + " is a failure" );
		}
	}

	getSyncValue( "Joy", true ).handle( o -> handleOutcome( o ));
	getSyncValue( "Fifi Trixiebell", false ).handle( o -> handleOutcome( o ));
}

function getSyncValue( name:String, isSuccess:Bool ) {
	return Future.sync( isSuccess ? Success( name ) : Failure( name ));
}
```

When the Future should be able to have multiple states e.g. if it can fail, we use an enum as return value. The tink_core Outcome is well suited for this. The handle function then must be able to handle the states.

The output is

```bash
src/Main.hx:8: Joy is a success
src/Main.hx:9: Fifi Trixiebell is a failure
```

## 13 Trigger

To create custom Futures there is a helper class FutureTrigger. First we recreate example 02 with Future.trigger();

```haxe
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
```

As expected, the output is

```bash
src/Main.hx:8: Hello
src/Main.hx:7: World!
```

## 14 Async Trigger

Now let's create a class with multiple async operations.

```haxe
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
```

```haxe
using tink.CoreApi;

function main() {

	final loop = new Loop( 3 );
	final future = loop.start();
	future.handle( s -> trace( 'finished' ));
}
```

So after getting a new instance of the Loop class, the method start() is called which causes a loop of 3 delays. When the loops are finished the Future is resolved.

```bash
src/Loop.hx:23: 0
src/Loop.hx:23: 1
src/Loop.hx:23: 2
src/Main.hx:7: finished
```

## 14 Multiple Async Triggers

Here a more complex version in which 2 loops are started simultaneously with different delays.

```haxe
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
```

```haxe
using tink.CoreApi;

function main() {

	final loop1 = new Loop( "loop 1", 500, 2 );
	final future1 = loop1.start();

	final loop2 = new Loop( "loop 2", 200, 4 );
	final future2 = loop2.start();
	
	Future.inSequence( [future1, future2] ).handle( s -> trace( 'finished' ));
}
```

Loop 2 has a shorter delay, so it loops faster. We can combine future1 and future2 with the inSequence method and handle them together.

```bash
src/Loop.hx:27: loop 1: 0
src/Loop.hx:27: loop 2: 0
src/Loop.hx:27: loop 2: 1
src/Loop.hx:27: loop 2: 2
src/Loop.hx:27: loop 1: 1
src/Loop.hx:27: loop 2: 3
src/Main.hx:11: finished
```
