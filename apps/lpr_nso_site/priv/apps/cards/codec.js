function show_loading_error( s )
{
	alert( "Простите, не удалось загрузить данные.\n" + s );
	return null;
}

function decode( s )
{
	s = s.trim();
	var pos;
	var start_signature = "<card encoding=\"";
	pos = s.search( start_signature );
	if( pos < 0 )
		return show_loading_error( "Не найдена стартовая сигнатура." );
	s = s.substr( pos + start_signature.length );
	pos = s.search( "\">" );
	if( pos < 0 )
		return show_loading_error( "Не найден терминатор стартовой сигнатуры." );
	var encoding = s.substr( 0, pos ).toUpperCase();

	s = s.substr( pos + 2 );

	pos = s.search( "</card>" );
	if( pos < 0 )
		return show_loading_error( "Не найдена хвостовая сигнатура." );
	s = s.substr( 0, pos ).trim();
	s = remove_line_feeds( s );
	
	encoding = encoding.toUpperCase();
	if( encoding == "BASE64" )
	{
		s = LZString.decompressFromBase64( s );
	}
	else
	{
		return show_loading_error( "Неподдерживаемый вариант кодирования." );
	}

	return s;
}

function remove_line_feeds( text )
{
	var res = "";
	var i;
	for( i = 0; i != text.length; ++i )
	{
		var ch = text[ i ];
		if( ch == "\n" )
			continue;
		res += ch;
	}
	return res;
}

function break_long_lines( text, max_line_length )
{
	var res = "";
	var pos = 0;
	var i;
	for( i = 0; i != text.length; ++i )
	{
		if( pos == max_line_length )
		{
			res += "\n";
			pos = 0;
		}
		var ch = text[ i ];
		if( ch == "\n" )
			pos = 0;
		else
			++pos;
		res += ch;
	}
	return res;
}

function encode( obj, encoding, version, generator )
{
	encoding_unified = encoding.toUpperCase();
	var envelop =
	{
		envelop:
		{
			timestamp : new Date().toISOString(),
			version   : version,
			generator : generator
		},
		contents : obj
	};
	var s = JSON.stringify( envelop, null, 0 );
	if( encoding_unified == "BASE64" )
		s = LZString.compressToBase64( s );
	else if( encoding_unified == "JSON" )
		;
	else
	{
		return show_loading_error( "Неподдерживаемый вариант кодирования." );
	}
	return "<card encoding=\"" + encoding + "\">\n" +  break_long_lines( s, 50 ) + "\n</card>";
}
