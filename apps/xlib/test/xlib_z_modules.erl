-module( xlib_z_modules ).

-export( [ get_modules/0 ] ).

get_modules() ->
	
	[
		xlib_align,
		xlib_binary,
		xlib_dec,
		xlib_crc16_ccitt,
		xlib_datetime,
		xlib_hex,
		xlib_parity,
		xlib_version
	]
.