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
