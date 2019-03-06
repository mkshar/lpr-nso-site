function is_null( e )      { return e == null; }
function if_null( e, val ) { return ( e == null ) ? val : e; }
function is_empty( e )     { return ( e == null ) || ( e == "" ); }
function is_not_empty( e ) { return ( e != null ) && ( e != "" ); }
function $( id )           { return document.getElementById( id ); }
function $value( id )      { return document.getElementById( id ).value; }
function log( s )          { if( window.console && window.console.log ) { console.log( s ); } }
function logret( s, res )  { log( s + ": " + res ); return res; }
function is_in_set( t, s ) { var i; for( i = 0; i != t.length; ++i ) if( s.indexOf( t[ i ] ) == -1 ) return false; return true; }