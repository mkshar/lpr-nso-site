var app;

function display( id, style ) { $( id ).style.display = style; }
function set_enabled( name, value ) { $( name ).disabled = !value; }

function get_enabled_color( tag )
{
	if( tag == "INPUT" || tag == "TEXTAREA" || tag == "BUTTON" ) return [ "black", "white" ];
	return [ "black", "#FFFF80" ];
}
function set_children_enabled( node, enabled, path )
{
	if( typeof node == "string" )
	{
		if( path == null )
			path = node;
		node = $(node);
	}
	var c = node.children;
	var tag = node.nodeName;
	
	node.disabled = !enabled;
	if( tag != "BUTTON" )
	{
		var color = get_enabled_color( tag );
		node.style.color           = enabled ? color[ 0 ] : "gray";
		node.style.backgroundColor = enabled ? color[ 1 ] : "lightgray";
	
		var i;
		for( i = 0; i != c.length; ++i )
			set_children_enabled( c[ i ], enabled );
	}
}

function get_planes()
{
	return document.getElementsByClassName( "webapp-plane" );
}

function find_plane( id )
{
	var planes = get_planes();
	
	var i;
	for( i = 0; i != planes.length; ++i )
	{
		if( planes[ i ].id == id )
			return planes[ i ];
	}
	return null;
}

function hash_guard()
{	
	if( window.location.hash != app.hash )
	{
		var id = window.location.hash.substr( 1 );
		if( window.location.hash == "" )
			id = "init";
		var plane = find_plane( id );
		if( plane != null )
			app.show_plane( id, false );
	}

	setTimeout( hash_guard, 250 );
}

function WebApp( version, confirm_exit )
{
	app = this;
	this.version = version;
	
	var i;
	
	var version_elements = document.getElementsByClassName( "webapp-version-id" );
	for( i = 0; i != version_elements.length; ++i )
		version_elements[ i ].innerHTML = version;
	
	const version_tag = "$(VERSION)";
	i = document.title.indexOf( version_tag );
	if( i != -1 )
		document.title = document.title.substr( 0, i ) + version + document.title.substr( i + version_tag.length );
	
	var planes = get_planes();
	for( i = 0; i != planes.length; ++i )
	{
		var id = planes[ i ].id;
		if( id == "init" )
			this.initial_plane = id;
	}
	
	this.active_plane = this.initial_plane;
	this.show_plane( this.initial_plane, false );
	
	hash_guard();
	
	if( confirm_exit )
	{
		window.onbeforeunload = function()
		{
			return "Вы хотите покинуть страницу? Введённые данные могут быть потеряны.";
		};
	}
	
	return this;
}

WebApp.prototype.show_plane = function( plane, update_history )
{
	$( this.active_plane ).style.display = "none";
	this.active_plane = plane;
	
	if( update_history != false )
		window.location.hash = plane;
	this.hash = window.location.hash;
	
	$( this.active_plane ).style.display = "block";
	window.scrollTo( 0, 0 );

	return this;
}

function back()
{
	window.history.back();
}
function save()
{
	app.show_plane( "save" );
}
function load()
{
	app.show_plane( "load" );
}

var g_division = new Division( "libertarian-party.ru", "nso", 54 );
var g_year = new Date().getFullYear();
var g_card_id = 9999;
var g_card_registered = false;
var g_format_version = "0.3";
var g_application_version = "0.2.0";

function bootstrap()
{
	new WebApp( g_application_version );
	select_card_type();
	update_emitent_data();
}

function update_emitent_data()
{
	var card_id_prefixed = "0000" + g_card_id;
	card_id_prefixed = card_id_prefixed.substr( card_id_prefixed.length - 4 );
	$( "emitent-domain" ).innerHTML = g_division.subdomain;
	$( "emitent-code"   ).innerHTML = g_division.region_code;
	$( "card-year"      ).innerHTML = g_year;
	$( "card-serial"    ).innerHTML = card_id_prefixed;
	$( "card-status"    ).innerHTML = g_card_registered ? "зарегистрированный" : "макетный";
	$( "card-status"    ).style.color = g_card_registered ? "white" : "red";
	// select by empty/url/vcard
}

function clear_loader()
{
	$( "card_data_loader" ).value = "";
}
function vcard_set_addr( addr )
{
	$( "vcard_addr" ).value = addr;
}

function check_input_non_empty( id )
{
	var empty = is_empty( $( id ).value );
	$( id ).style.backgroundColor = empty ? "red" : "white";
	return !empty;
}

function is_checked( id )
{
	return $( id ).checked;
}

function set_block_visible( id, visible )
{
	$( id ).style.display = visible ? "block" : "none";
}
function set_inline_block_visible( id, visible )
{
	$( id ).style.display = visible ? "inline-block" : "none";
}
function set_inline_visible( id, visible )
{
	$( id ).style.display = visible ? "inline" : "none";
}

function get_selector_value( name )
{
	var elements = document.getElementsByName( name );
	var i;
	for( var i = 0; i != elements.length; ++i )
	{
		if( elements[ i ].checked )
		{
			return elements[ i ].value;
		}
	}
	return null;
}


function update_first_name()
{
	copy_name();
	check_input();
}

function update_last_name()
{
	copy_name();
	check_input();
}

function select_card_type()
{
	var type = get_selector_value( "card_type" );
	set_block_visible( "vcard_data", type == "vcard" );
	set_block_visible( "url_data",   type != "empty" );
	select_url_type(); 
	select_vcard_type();
}

function select_url_type()
{
	var type = get_selector_value( "url_type" );
	set_block_visible( "url_page_data", type == "user_defined" );
	check_url();
}

function get_url()
{
	if( get_selector_value( "card_type" ) == "empty" )
		return null;
	if( get_selector_value( "url_type" ) == "by_card_id" )
		return null;
	return $( "url_page" ).value;
}

function update_url()
{
	update_vcard();
}

function check_url()
{
	if( get_selector_value( "card_type" ) == "empty" )
		return true;
	if( get_selector_value( "url_type" ) == "by_card_id" )
		return true;
	
	var addr = $( "url_page" ).value;
	var valid = true;
	
	const separators = ".-_";
	const numeric = "0123456789";
	const alphabet = "abcdefghijklmnopqrstuvwxyz"
	
	if( !addr.length )
		valid = false;
	else if( is_in_set( addr[0], separators ) || is_in_set( addr[ addr.length - 1 ], separators ) )
		valid = false;
	else if( !is_in_set( addr, numeric + alphabet + alphabet.toUpperCase() + separators ) )
		valid = false;

	$( "url_page" ).style.backgroundColor = valid ? "white" : "red";
	return valid;
}

function select_vcard_type()
{
	var type = get_selector_value( "vcard_type" );
	set_block_visible( "vcard_auto_switches", type == "by_template"  );
	set_block_visible( "vcard_fields",        type == "by_template"  );
	set_block_visible( "vcard_raw",           type == "user_defined" );
	
	change_vcard_auto_add_url();
	change_vcard_auto_copy_name();
}

function change_vcard_auto_add_url()
{
	update_vcard();
}
function change_vcard_auto_copy_name()
{	
	var do_copy = is_checked( "vcard_auto_copy_name" );
	$( "vcard_fn" ).readOnly = do_copy;
	set_inline_block_visible( "vcard_fn_hint", do_copy );
	$( "vcard_fn" ).style.backgroundColor = do_copy ? "silver" : "white";
	
	copy_name();
	update_vcard(); 
}
function update_vcard_fn()
{
	update_vcard();
}
function update_vcard()
{	
	if( is_checked( "vcard_auto_add_url" ) )
	{
		var vcard = new vCard
		(
			$( "vcard_fn" ).value,
			$( "vcard_email" ).value,
			make_list( $( "vcard_tel_1" ).value, $( "vcard_tel_2" ).value ),
			make_list( $( "vcard_url_1" ).value, $( "vcard_url_2" ).value ),
			$( "vcard_addr" ).value,
			$( "vcard_note" ).value
		);
	
		var card = new Card( g_division, g_card_id, get_url(), g_year );
		vcard.add_url( card.url );
		
		$( "vcard_raw_data" ).value = vcard.generate();
	}
	
	check_input();
}

function vcard_set_addr( addr )
{
	$( "vcard_addr" ).value = addr;
	update_vcard();
}

function copy_name()
{
	if( is_checked( "vcard_auto_copy_name" ) )
		$( "vcard_fn" ).value = $( "first_name" ).value + " " + $( "last_name" ).value;
}

function check_input()
{
	var valid = true;
	valid = check_url() ? valid : false;
	valid = check_input_non_empty( "first_name" ) ? valid : false;
	valid = check_input_non_empty(  "last_name" ) ? valid : false;
	if( is_checked( "vcard" ) )
	{
		if( is_checked( "vcard_by_template" ) && !is_checked( "vcard_auto_copy_name" ) )
			valid = check_input_non_empty( "vcard_fn" ) ? valid : false;
		else
		{
			vcard = new vCard().fill( $( "vcard_raw_data" ).value );
			valid = vcard.check();
			$( "vcard_raw_data" ).style.backgroundColor = !valid ? "red" : "white";
		}
	}
	
	set_inline_block_visible( "show_card", valid );
	set_inline_block_visible( "editor_warning", !valid );
}

function view()
{
	var first_name = $value( "first_name" );
	var last_name  = $value( "last_name"  );
	
	var name = last_name + " " + first_name;
	var transliteration = get_selector_value( "transliteration" );
	var status          = get_selector_value( "status" );
	var card_type       = get_selector_value( "card_type" );

	var card = new Card( g_division, g_card_id, get_url(), g_year, g_photo, g_photo_mime_type );
	var qr;
	
	if( card_type == "url" )
	{
		qr = card.url;
	}
	else if( card_type == "vcard" )
	{
		var vcard;
		vcard_type = get_selector_value( "vcard_type" );
		
		if( vcard_type == "by_template" )
		{
			var vcard = new vCard
			(
				is_checked( "vcard_auto_copy_name" ) ?
					( first_name + " " + last_name ) :
					$( "vcard_fn" ).value,
				$( "vcard_email" ).value,
				make_list( $( "vcard_tel_1" ).value, $( "vcard_tel_2" ).value ),
				make_list( $( "vcard_url_1" ).value, $( "vcard_url_2" ).value ),
				$( "vcard_addr" ).value,
				$( "vcard_note" ).value
			);
			
			if( is_checked( "vcard_auto_add_url" ) )
				vcard.add_url( card.url );
		}
		else // if( vcard_type == "user_defined" )
		{
			vcard = new vCard().fill( $( "vcard_raw_data" ).value );
		}
		qr = vcard.generate();
	}
	
	make_card( first_name, last_name, card, status, qr, transliteration, $( "card-face" ), $( "card-back" ), $( "card-back-negative" ), false, null );
	
	app.show_plane( "view" );
}

function save()
{
	var obj =
	{
		division:
		{
			domain    : g_division.domain,
			subdomain : g_division.subdomain,
			region    : g_division.region_code
		},
		main:
		{
			year       : g_year,
			id         : g_card_id,
			registered : g_card_registered,
			first_name : $value( "first_name" ),
			last_name  : $value( "last_name"  ),
			status     : get_selector_value( "status" )
		},
		options:
		{
			transliteration : get_selector_value( "transliteration" ),
			type            : get_selector_value( "card_type" ),
			url:
			{
				user_defined : get_selector_value( "url_type" ) == "user_defined",
				page         : $( "url_page" ).value
			}
		},
		vcard:
		{
			use_template : get_selector_value( "vcard_type" ) == "by_template",
			template:
			{
				options:
				{
					add_url   : is_checked( "vcard_auto_add_url" ),
					copy_name : is_checked( "vcard_auto_copy_name" )
				},
				fields:
				{
					fn    : $( "vcard_fn" ).value,
					addr  : $( "vcard_addr" ).value,
					email : $( "vcard_email" ).value,
					url_1 : $( "vcard_url_1" ).value,
					url_2 : $( "vcard_url_2" ).value,
					tel_1 : $( "vcard_tel_1" ).value,
					tel_2 : $( "vcard_tel_2" ).value,
					note  : $( "vcard_note" ).value
				}
			},
			raw: ( get_selector_value( "vcard_type" ) == "by_template" ) ? "" : $( "vcard_raw_data" ).value
		}
	};
	
	const encoding = "Base64";
	const generator = "nsk-shar-js/0.4";
	$( "card_data_saver" ).value = encode( obj, encoding, g_format_version, generator, g_photo, g_photo_mime_type );
	
	app.show_plane( "save" );
}

function copy()
{
	$( "card_data_saver" ).select();
	var res = document.execCommand( "copy" );
	alert( res ? "Скопировано в буфер обмена." : "Не удалось скопировать в буфер обмена.\nПожалуйста, скопируйте вручную." );
}

function read()
{
	var s = decode( $( "card_data_loader" ).value );
	if( !s )
		return null;
	var o = JSON.parse( s );
	if( !o )
		return null;
	
	// clean-up:
	$( "first_name" ).value = "";
	$( "last_name"  ).value = "";
	
	$( "url_by_card_id" ).checked = true;
	$( "url_page" ).value = "";

	$( "vcard_fn"    ).value = "";
	$( "vcard_addr"  ).value = "";
	$( "vcard_email" ).value = "";
	$( "vcard_tel_1" ).value = "";
	$( "vcard_tel_2" ).value = "";
	$( "vcard_url_1" ).value = "";
	$( "vcard_url_2" ).value = "";
	$( "vcard_note"  ).value = "";
	$( "vcard_data"  ).value = "";
	
	var envelop = o.envelop;
	
	if( envelop.version != g_format_version )
	{
		show_loading_error( "Неподдерживаемая версия контейнера: " + envelop.version + "." );
	}

	var contents = o.contents;
	
	var division = contents.division;
	g_division = new Division( division.domain, division.subdomain, division.region );
	
	var main = contents.main;
	g_year            = if_null( main.year, new Date().getFullYear() );
	g_card_id         = main.id;
	g_card_registered = main.registered;
	$( "first_name" ).value = main.first_name;
	$( "last_name"  ).value = main.last_name;
	$( main.status ).checked = true;
	
	var options = contents.options;
	$( options.transliteration ).checked = true;
	$( options.type            ).checked = true;
	
	var url = options.url;
	if( url )
	{
		$( "url_" + ( url.user_defined ? "user_defined" : "by_card_id" ) ).checked = true;
		$( "url_page" ).value = url.page;
	}
	
	var vcard = contents.vcard;
	if( vcard )
	{
		$( "vcard_" + ( vcard.use_template ? "by_template" : "user_defined" ) ).checked = true;
	
		var template = vcard.template;
	
		var options = template.options;
		$( "vcard_auto_add_url"     ).checked = options.add_url;
		$( "vcard_auto_copy_name"   ).checked = options.copy_name;
				
		var fields = template.fields;
		$( "vcard_fn"    ).value = fields.fn;
		$( "vcard_addr"  ).value = fields.addr;
		$( "vcard_email" ).value = fields.email;
		$( "vcard_tel_1" ).value = fields.tel_1;
		$( "vcard_tel_2" ).value = fields.tel_2;
		$( "vcard_url_1" ).value = fields.url_1;
		$( "vcard_url_2" ).value = fields.url_2;
		$( "vcard_note"  ).value = fields.note;
		$( "vcard_data"  ).value = vcard.raw;
	}
	
	select_card_type();
	update_emitent_data();
	
	alert( "Информация о карте успешно загружена." );
	
	app.show_plane( "edit" );
}

function uint8_to_string( uint8_array ){
	const chunk_size = 0x8000;
	var res = [];
	for( var i = 0; i < uint8_array.length; i+= chunk_size )
		res.push( String.fromCharCode.apply( null, uint8_array.subarray( i, i + chunk_size ) ) );
	return res.join( "" );
}

var g_photo;
var g_photo_mime_type;
function load_photo()
{
	var files = $('photo').files;
	if( files.length < 1 )
		return;
	
	var file = files[ 0 ];
	
	var reader = new FileReader();
	reader.addEventListener
	(
		"loadend", function()
		{
			var buffer = reader.result;
			var view = new Uint8Array( buffer );
			//log( "view.length = " + view.length );
			//log( view );
			//log( btoa( uint8_to_string( view ) ) );
			g_photo_mime_type = file.type;
			g_photo = btoa( uint8_to_string( view ) )
		}
	);
	reader.readAsArrayBuffer( file );
}
