-module( xlib_color ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ hsv_to_rgb/3, uint24_to_rgb/1, test/0 ] ).

%-include( "eunit" ).

floor( X ) ->

	T = trunc( X ),
	if ( X < T ) -> ( T - 1 ); true -> T end
.

% see
%	https://en.wikipedia.org/wiki/HSL_and_HSV#From_HSV
%	https://colorscheme.ru/color-converter.html
%	http://colorizer.org/
%
% H: [ 0, 360 ]
% S: [ 0.0, 1.0 ]
% V: [ 0.0, 1.0 ]
hsv_to_rgb( H, S, V ) ->

	io:format( "HSV = ~p, ~p, ~p ~n", [ H, S, V ] ),

	Z = if ( H == 360.0 ) -> 0.0; true -> H / 60.0 end,
%	io:format( "Z = ~p~n", [ Z ] ),
	F = Z - floor( Z ),
%	io:format( "F = ~p~n", [ F ] ),
	P = V * ( 1.0 - S ),
    Q = V * ( 1.0 - S * F ),
    T = V * ( 1.0 - S * ( 1.0 - F ) ),
	
	{ R, G, B } =
		case round( Z ) of
			0 -> { V, T, P };
			1 -> { Q, V, P };
			2 -> { P, V, T };
			3 -> { P, Q, V };
			4 -> { T, P, V };
			5 -> { V, P, Q };
			_ -> { 0, 0, 0 }
		end,
		
	{ round( R * 255 ), round( G * 255 ), round( B * 255 ) }
.

uint24_to_rgb( I ) ->

	<< R:8, G:8, B:8 >> = << I:24 >>,
	{ R, G, B }
.

test() ->

	{   0,   0,   0 } = xlib_hsv_rgb:hsv_to_rgb(   0.0, 0.0, 0.0 ),
	{ 255, 255, 255 } = xlib_hsv_rgb:hsv_to_rgb(   0.0, 0.0, 1.0 ),
	
	{ 255,   0,   0 } = xlib_hsv_rgb:hsv_to_rgb(   0.0, 1.0, 1.0 ),
	{   0, 255,   0 } = xlib_hsv_rgb:hsv_to_rgb( 120.0, 1.0, 1.0 ),
	{   0,   0, 255 } = xlib_hsv_rgb:hsv_to_rgb( 240.0, 1.0, 1.0 ),
	
	{   0, 255, 255 } = xlib_hsv_rgb:hsv_to_rgb( 180.0, 1.0, 1.0 ),
	{ 255,   0, 255 } = xlib_hsv_rgb:hsv_to_rgb( 300.0, 1.0, 1.0 ),
	{ 255, 255,   0 } = xlib_hsv_rgb:hsv_to_rgb(  60.0, 1.0, 1.0 ),

	ok
.
