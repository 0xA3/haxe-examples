using tink.CoreApi;

function main() {

	final loop = new Loop( 3 );
	final future = loop.start();
	future.handle( s -> trace( 'finished' ));
}
