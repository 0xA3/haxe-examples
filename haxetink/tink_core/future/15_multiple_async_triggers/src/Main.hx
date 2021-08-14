using tink.CoreApi;

function main() {

	final loop1 = new Loop( "loop 1", 500, 2 );
	final future1 = loop1.start();

	final loop2 = new Loop( "loop 2", 200, 4 );
	final future2 = loop2.start();
	
	Future.inSequence( [future1, future2] ).handle( s -> trace( 'finished' ));
}
