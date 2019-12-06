# Async/await

Transforms functions and classes to wait for the completion of async operations.

## 01 Await
```haxe
import haxe.Timer;
using tink.CoreApi;

@await class Main {
	@await static function main() {
		
		trace( @await getValue( "Hello", 500 ));
		trace( @await getValue( "World!", 250 ));
	}
	
	static function getValue( message:String, delay:Int ) {
		return Future.async( callback -> Timer.delay(() -> callback( message ), delay ));
	}
}
```

When calling an function that returns a Future with @await. The program waits until the future is resolved and then returns its result.
Without the @await keyword the value of "World!" would be retrieved first because it has a lower delay.

The output is
```
src/Main.hx:7: Hello
src/Main.hx:8: World!
```
The class and the function must be marked as @await to be transformed.
