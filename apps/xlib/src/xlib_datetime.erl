-module( xlib_datetime ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ utc/0, unix_to_datetime/1, format/2, unix_timestamp/0, utc_datetime_string/0, utc_time_string/0 ] ).

-include( "eunit" ).

-compile( [ { nowarn_deprecated_function, { erlang, now, 0 } } ] ). % Warning: erlang:now/0: Deprecated BIF. See the "Time and Time Correction in Erlang" chapter of the ERTS User's Guide for more information.

% see-also:
%	erlang:localtime/0, erlang:localtime_to_universaltime/1/2, erlang:universaltime_to_localtime/1,
%	os:timestamp/0, os:system_time/0/1,
%	calendar:now_to_universal_time/1, calendar:now_to_local_time/1 

%
% format_utc_timestamp() ->
%	
%	TS = { _, _, Micro } = os:timestamp(),
%	{ { Year, Month, Day},{ Hour, Minute, Second } } = calendar:now_to_universal_time( TS ),
%	Mstr = element( Month, { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" } ),
%	io_lib:format( "~2w ~s ~4w ~2w:~2..0w:~2..0w.~6..0w", [ Day, Mstr, Year, Hour, Minute, Second, Micro ] )
%.
%

utc() ->

	erlang:universaltime() % { { Year, Month, Day }, { Hour, Min, Sec } }
.

utc_datetime_string() ->

	list_to_binary( format( utc(), yyyyhmmhddThhcmmcssZ ) )
.

utc_time_string() ->

	list_to_binary( lists:flatten( io_lib:format( "~2.10.0B:~2.10.0B:~2.10.0BZ", time_to_list( utc() ) ) ) )
.

unix_timestamp() ->

	try erlang:system_time( seconds ) of
		Result -> Result
	catch _E:_X ->
		{ Mega_secs, Secs, _Micro_secs } = erlang:now(), % fallback for Erlang/OTP 17 and earlier
		Mega_secs * 1000000 + Secs
	end
.

unix_to_datetime( Unix_time ) ->

	Unix_epoch = { { 1970, 1, 1 }, { 0, 0, 0 } },
	calendar:gregorian_seconds_to_datetime( calendar:datetime_to_gregorian_seconds( Unix_epoch ) + Unix_time )
.

time_to_list( Datetime ) ->

	{ { _Year, _Month, _Day }, { Hour, Min, Sec } } = Datetime,
	
	[ Hour, Min, Sec ]
.

datetime_to_list( Datetime ) ->

	{ { Year, Month, Day }, { Hour, Min, Sec } } = Datetime,
	
	[ Year, Month, Day, Hour, Min, Sec ]
.

format( Datetime, yyyypmmpdd_hhcmmcss ) ->

	lists:flatten( io_lib:format( "~4.10.0B.~2.10.0B.~2.10.0B ~2.10.0B:~2.10.0B:~2.10.0B", datetime_to_list( Datetime ) ) )
;

format( Datetime, yyyyhmmhddThhcmmcss ) ->

	lists:flatten( io_lib:format( "~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0B", datetime_to_list( Datetime ) ) )
;

format( Datetime, yyyyhmmhdd_hhcmmcss ) ->

	lists:flatten( io_lib:format( "~4.10.0B-~2.10.0B-~2.10.0B ~2.10.0B:~2.10.0B:~2.10.0B", datetime_to_list( Datetime ) ) )
;

format( Datetime, yyyyhmmhddThhcmmcssZ ) ->

	lists:flatten( io_lib:format( "~4.10.0B-~2.10.0B-~2.10.0BT~2.10.0B:~2.10.0B:~2.10.0BZ", datetime_to_list( Datetime ) ) )
;

format( Datetime, yyyymmddhhmmss ) ->

	lists:flatten( io_lib:format( "~4.10.0B~2.10.0B~2.10.0B~2.10.0B~2.10.0B~2.10.0B", datetime_to_list( Datetime ) ) )
;

format( Datetime, yyyymmddThhmmss ) ->

	lists:flatten( io_lib:format( "~4.10.0B~2.10.0B~2.10.0BT~2.10.0B~2.10.0B~2.10.0B", datetime_to_list( Datetime ) ) )
;

format( Datetime, yyyymmddThhmmssZ ) ->

	lists:flatten( io_lib:format( "~4.10.0B~2.10.0B~2.10.0BT~2.10.0B~2.10.0B~2.10.0BZ", datetime_to_list( Datetime ) ) )
.