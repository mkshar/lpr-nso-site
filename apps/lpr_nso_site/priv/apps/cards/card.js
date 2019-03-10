function hr() { return "<hr/>"; }
function table( args,   contents ) { return "<table" + ( contents == null ? ( ">" + args ) : ( " " + args + ">" + contents ) ) + "</table>"; }
function tr   (         contents ) { return "<tr>" + contents + "</tr>"; }
function td   ( args,   contents ) { return "<td" + ( contents == null ? ( ">" + args ) : ( " " + args + ">" + contents ) ) + "</td>"; }
function div  ( class_, contents ) { return "<div class=\"" + class_ + "\">" + contents + "</div>"; }
function divi ( class_, id       ) { return "<div class=\"" + class_ + "\" id=\"" + id + "\"/>"; }

function make_non_empty( str ) { return ( str.trim() == "" ) ? "<span style=\"color:red\">INVALID NAME</span>" : str; }

function make_face( first_name, last_name, id, status, transliteration_variant )
{
	id = id + "";
	id = id.substr( 0, 4 ) + " " + id.substr( 4, 4 );
	
	var res =
		div( "card-top-" + status, div( "party-name", "Либертарианская партия России" ) ) +
		div
		(
			"card-bottom",
			table
			(
				"width=\"100%\"",
				tr
				(
					td( "width=\"50%\"", "<img class=\"logo\" src=\"/logo/LPR-mod.white-circle.svg\" style=\"width: 34mm; margin-top: 3mm; margin-left: 3.5mm;\"/>" ) +
					td
					(
						"style=\"vertical-align: top;\"",
						div( "card-type-" + status, status == "member" ? "Партийный билет" : "Карта сторонника" ) +
						div
						(
							"embossement",
							div( "member-first-name", make_non_empty( transliterate( first_name, transliteration_variant ) ) ) +
							div( "member-last-name",  make_non_empty( transliterate( last_name,  transliteration_variant ) ) ) +
							div( "member-id", id )
						)
					)
				)
			)
		)

	return res;
}

function make_back( need_back, qr_id, page )
{
	var res =
		div
		(
			"card-back",
			div
			(
				"card-back-content",
				table
				(
					"width=\"100%\"",
					tr
					(
						td( "width=\"50%\"", "&nbsp;" ) +
						td( "width=\"50%\"", need_back ? divi( "vcard", qr_id ) : "&nbsp;" )
					) +
					tr
					(
						td( "&nbsp;" ) +
						td( need_back ? div( "url", page ) : "&nbsp;" )
					)
				)
			)
		);

	return res;
}

function vCard( name, email, phones, urls, addr, note )
{
	this.contents = null;
	this.name     = name;
	this.email    = email;
	this.phones   = phones instanceof Array ? phones : phones == null ? new Array() : new Array().push( phones );
	this.urls     = urls instanceof Array ? urls : urls == null ? new Array() : new Array().push( urls );
	this.addr     = addr;
	this.note     = note;
	return this;
}
		
vCard.prototype.generate = function()
{
	if( is_not_empty( this.contents ) )
		return this.contents;
	
	this.add_field( "BEGIN",   "VCARD"    );
	this.add_field( "VERSION", "4.0"      );
	this.add_field( "FN",      this.name  );
	this.add_field( "ADR",     this.addr  );
	this.add_field( "EMAIL",   this.email );
	this.add_field( "NOTE",    this.note  );
	for( var i = 0; i != this.phones.length; ++i ) this.add_field( "TEL", this.phones[ i ] );
	for( var i = 0; i != this.urls  .length; ++i ) this.add_field( "URL", this.urls  [ i ] );
	this.add_field( "END",     "VCARD", false );
	return this.contents;
};

vCard.prototype.add_field = function( field, value, need_lf )
{
	if( need_lf == null )
		need_lf = true;
	if( !is_empty( value ) )
		this.contents = ( is_empty( this.contents ) ? "" : this.contents ) + field + ":" + value.trim() + ( need_lf ? "\n" : "" );
	return this;
}

vCard.prototype.add_url = function( url )
{
	if( is_not_empty( url ) )
		this.urls.push( url );
	return this;
}

vCard.prototype.fill = function( contents )
{
	this.contents = contents;
	return this;
}

vCard.prototype.check = function()
{
	var t = this.generate();
	var pos = t.search( "\nFN:" );
	if( pos == -1 )
		return false;
	var fn = t.substr( pos + 4 );
	pos = fn.search( "\n" );
	if( pos == -1 )
		return false;
	fn = fn.substr( 0, pos ).trim();
	if( fn.length == 0 )
		return false;
	if( t.search( "BEGIN:VCARD\n" ) != 0 )
		return false;
	if( t.search( "\nEND:VCARD" ) != ( t.length - 10 ) )
		return false;
	return true;
}

function make_list( e1, e2, e3, e4, e5 )
{
	var list = new Array();
	if( is_not_empty( e1 ) ) list.push( e1 );
	if( is_not_empty( e2 ) ) list.push( e2 );
	if( is_not_empty( e3 ) ) list.push( e3 );
	if( is_not_empty( e4 ) ) list.push( e4 );
	if( is_not_empty( e5 ) ) list.push( e5 );
	return list;
}

function disperse( str )
{
	str = "" + str;
	var res = "<span class=\"dispersed\">";
	for( var i = 0; i != str.length; ++i )
	{
		if( ( i != 0 ) && ( ( i % 4 ) == 0 ) )
			res += "<span style=\"font-size: 2mm; color: black;\">&centerdot;</span>";
		res += str[ i ];
	}
	res += "</span>"
	return res;
}
		
function convert_to_pid( hex, min )
{
	var res = 0;
	var i = 0;
	while( res < min )
	{
		while( res < min )
		{
			res *= 16;
			if( i < hex.length )
				res += parseInt( hex[ i++ ], 16 );
			else
				res += 1;
		}
		res %= ( min * 10 );
	}
	return res;
}

function Card( division, id, page, year )
{
	if( !year )
		year = new Date().getFullYear();
	
	this.uid = ( ( division.region_code * 100 ) + ( year % 100 ) ) * 10000 + id;
	
	if( !page )
		page = this.uid;
	
	var fqn = division.subdomain + "." + division.domain;
	var dir = "/people/";
	this.text = fqn + "<br/>" + dir + page; // disperse( page_uid );
	this.url  = "https://" + fqn + dir + page;
	
	this.qr_content  = null;
	
	return this;
}

function Division( domain, subdomain, region_code )
{
	this.domain = domain;
	this.subdomain = subdomain;
	this.region_code = region_code;
	return this;
}

Division.prototype.make_card = function( local_person_id )
{
	return new Card( this, local_person_id );
}

function make_card( first_name, last_name, card, status, qr, transliteration_variant, face_container, back_container, append, registry )
{
	var qr_id = "qr_" + card.uid;
	status = status.toUpperCase();
	status = ( ( status == "MEMBER" ) || ( status == "M" ) || ( status == "ЧЛЕН ЛПР" ) || ( status == "ЧЛЕН" ) ) ? "member" : "supporter";
	
	if( back_container == null )
	{
		var data = table( tr( td( make_face( first_name, last_name, card.uid, status, transliteration_variant ) ) + td( make_back( qr, qr_id, card.text ) ) ) );// + hr();

		if( append )
		{
			var element = document.createElement( "div" );
			element.innerHTML = data;
			container.appendChild( element );
		}
		else
			container.innerHTML = data;
	}
	else
	{
		face_container.innerHTML = make_face( first_name, last_name, card.uid, status, transliteration_variant );
		back_container.innerHTML = make_back( qr, qr_id, card.text );
	}

	if( registry )
		registry.push( [ last_name, first_name, card.id, card.uid, card.uid ] ); // TODO: remove second card.uid
	
	if( qr )
	{
		var size = 100;
		new QRCode
		(
			document.getElementById( qr_id ),
			{
				width  : size,
				height : size,
				useSVG : true,
				correctLevel : 1,
				colorDark    : "#000000",
				colorLight   : "#ffffff",
			}
		).makeCode( qr );
	}
}
