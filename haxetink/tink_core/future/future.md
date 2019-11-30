# Future

A Future is a value that is the result of a potentially asynchronous operation.

The tink [documentation](https://haxetink.github.io/tink_core/#/types/future) is already very detailed. For a better understanding it helped me to create some complete examples to see multiple aspects of futures in action.

## 01 Callback

To make it easier to understand the first example is of a callback. A callback is a standard way to deal with asynchrony.

```haxe
import haxe.Timer;

class Main {
	
	static function main() {
		
		getValue( "World!", 500, s -> trace( s ));
		getValue( "Hello", 250, s -> trace( s ));
	}

	static function getValue( message:String, delay:Int, callback:String -> Void ) {
		Timer.delay(() -> callback( message ), delay );
	}
}
```

The getValue function receives a message, a delay and a callback. After the number of milliseconds specified in 'delay' have passed, the callback function is called with the message.

The main function first calls 'getValue' with the message "World!" and delay 500ms, then with "Hello" and delay 250. The callback just traces the result. 'Hello' is traced first because the delay is shorter.

The output is   
```
src/Main.hx:8: Hello   
src/Main.hx:7: World!
```

Now let's create the exact same program with futures

## 02 Same thing with Futures

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	static function main() {
		
		getValue( "World!", 500 ).handle( s -> trace( s ));
		getValue( "Hello", 250 ).handle( s -> trace( s ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
```

What has changed?  
The getValue function only gets the message and the delay. An async Future is created by defining a function to serve as callback. It returns a Future which can be processed with 'handle'.

The output is the same
```
src/Main.hx:8: Hello   
src/Main.hx:7: World!
```


So what can we do with this?


## 03 Transformation

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	static function main() {
		
		getValue( "World!", 500 ).map( s -> s.toLowerCase()).handle( s -> trace( s ));
		getValue( "Hello", 250 ).map( s -> s.toUpperCase()).handle( s -> trace( s ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
```
Before handling the result there are map functions that transform "World!" to lowercase and "Hello" to uppercase.
```
src/Main.hx:9: HELLO
src/Main.hx:8: world!
```


## 04 Future composition first

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		final r1 = getValue( "Hello", 250 );
		final r2 = getValue( "World!", 500 );

		r1.first( r2 ).handle( s -> trace( s ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
```
Only the first result is handled.

```
src/Main.hx:11: Hello
```


## 05 Future composition ofMany

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		final r1 = getValue( "Hello", Std.random( 500 ));
		final r2 = getValue( "World!", Std.random( 500 ));

		final result = Future.ofMany([ r1, r2 ]);
		
		result.handle( a -> trace( a.join( " " ) ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
```

Future.ofMany constructs an array of the results which then can be handled with a single handle function. The order of the results is always as specified in 'ofMany' and handle is called when all results are available. Because of this the delay for r1 and r2 can be random. The output will always be

```
src/Main.hx:15: Hello World!
```


## 06 Future composition merge

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		final r1 = getValue( "Hello", Std.random( 500 ));
		final r2 = getValue( "World!", Std.random( 500 ));

		r1.merge( r2, ( s1, s2 ) -> trace( s1 + " " + s2 ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
```

Merges the two results.
```
src/Main.hx:11: Hello World!
```


## 07 Map and composition

One advantage of futures is that we can combine all the functionality and still get consistent results. Here an example with multiple maps and ofMany

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		final r1 = getValue( "Hello", Std.random( 500 )).map( s -> s.toLowerCase()).map( s -> s.substr( 0, 1 ) + "...." );
		final r2 = getValue( "World!", Std.random( 500 )).map( s -> s.toUpperCase());

		final result = Future.ofMany([ r1, r2 ]);
		
		result.handle( a -> trace( a.join( " " ) ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async(( callback ) -> Timer.delay(() -> callback( message ), delay ));
	}
}
```

And the output is
```
src/Main.hx:15: h.... WORLD!
```

## 08 Multiple ofMany

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		final r1 = getValue( "Hello", Std.random( 50 ));
		final r2 = getValue( "World!", Std.random( 600 ));
		final r3 = getValue( "You!", Std.random( 20 ));

		final helloWorld = Future.ofMany([ r1, r2 ]).map( a -> a.join( " " ));
		final helloYou = Future.ofMany([ r1, r3 ]).map( a -> a.join( " " ));
		
		helloWorld.handle( a -> trace( a ));
		helloYou.handle( a -> trace( a ));

		final helloBoth = Future.ofMany([ helloWorld, helloYou ]).map( a -> a.join( " - " ));

		helloBoth.handle( a -> trace( a ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async(( callback ) -> Timer.delay(() -> callback( message ), delay ));
	}
}
```
We can even compose new Futures on multiple levels.   
Here r1 and r2 are composed to the Future 'helloWorld'. r1 and r3 are composed to 'helloYou'. Both are handled separately but are also composed to 'helloBoth'.

The output is

```
src/Main.hx:17: Hello You!
src/Main.hx:16: Hello World!
src/Main.hx:22: Hello World! - Hello You!
```

## 09 Sync and async values

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	static function main() {
		
		getAsyncValue( "World!", 500 ).handle( s -> trace( s ));
		getSyncValue( "Hello" ).handle( s -> trace( s ));
	}
	
	static function getAsyncValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}

	static function getSyncValue( message:String )  {
		return Future.sync( message );
	}
}
```

Futures don't have to be asynchronous. You can also handle synchronous values in exactly the same way.

## 10 Lazy

```haxe
import haxe.Timer;
using tink.CoreApi;

class Main {
	
	static function main() {
		
		getValueWithTrace( "World!", 500, true );
		getValueWithTrace( "Hello", 250, false );
	}

	static function getValueWithTrace( message:String, delay:Int, lazy:Bool ) {
		return Future.async(
			callback -> Timer.delay(() -> {	
				trace( "delay for " + message + " is completed" );
				callback( message ); }, delay ),
			lazy );
	}
}
```

Future.async has the optional parameter 'lazy'.   
If lazy is false the callback definition of the Future is called right after it is defined.  
If lazy is true is only called after there is a handler for the Future.

In this example there are no handlers for both futures but the timer for "Hello" is executed and completed.

The output is
```
src/Main.hx:15: delay for Hello is completed
```

## 11 Outcome

```haxe
using tink.CoreApi;

class Main {
	static function main() {
		
		final handleOutcome = function( o:Outcome<String, String> ) {
			switch o {
				case Success(data): trace( data + " is a success" );
				case Failure(failure): trace( failure + " is a failure" );
			}
		}

		getSyncValue( "Joy", true ).handle( o -> handleOutcome( o ));
		getSyncValue( "Fifi Trixiebell", false ).handle( o -> handleOutcome( o ));
	}

	static function getSyncValue( name:String, isSuccess:Bool ) {
		return Future.sync( isSuccess ? Success( name ) : Failure( name ));
	}
}
```

When the Future should be able to have multiple states e.g. if it can fail, we use an enum as return value. The tink_core Outcome is well suited for this. The handle function then must be able to handle the states.

The output is
```
src/Main.hx:8: Joy is a success
src/Main.hx:9: Fifi Trixiebell is a failure
```
