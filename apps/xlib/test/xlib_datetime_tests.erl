-module( xlib_datetime_tests ).

-include( "eunit" ).

-import( xlib_datetime, [ format/2 ] ).

format_test() ->
	
	Datetime = { { 2016, 9, 28 }, { 16, 55, 00 } },
	
	"2016.09.28 16:55:00"  = format( Datetime, yyyypmmpdd_hhcmmcss  ),
	"2016-09-28T16:55:00"  = format( Datetime, yyyyhmmhddThhcmmcss  ),
	"2016-09-28T16:55:00Z" = format( Datetime, yyyyhmmhddThhcmmcssZ ),
	
	"20160928T165500"   = format( Datetime, yyyymmddThhmmss  ),
	"20160928T165500"   = format( Datetime, yyyymmddThhmmss  ),
	"20160928T165500Z"  = format( Datetime, yyyymmddThhmmssZ ),
	
	ok
.

converters_test() ->

	todo % TODO
.

% EOF
