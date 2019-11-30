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

The getValue function receives a message, a delay and a callback. After the number of milliseconds specified in 'delay' have passed the callback function is called with the message.

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
The getValue function only gets the message and the delay. It returns a Future which can be processed later with 'handle'.

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

## 08 multiple ofMany

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

