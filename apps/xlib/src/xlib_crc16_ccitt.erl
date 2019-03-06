-module( xlib_crc16_ccitt ).
-author( "Mikhail Sharoglazov <sharoglazov@sibext.com>" ).
-version( "0.1" ). % Do NOT set -vsn attribute! It is used to detect code changes by MD5-hashing the module's AST.

-export( [ compute/2 ] ).

-include( "eunit" ).

% ITU Recommendation V.41 ("Code-Independent Error Control System") specifies an initial value of zero.
compute( Msg, v41 ) ->  compute( Msg, 0 );

% ITU Recommendations X.25 & T.30 use initial value of FFFFh.
compute( Msg, x25 ) ->  compute( Msg, 16#FFFF );
compute( Msg, t30 ) ->  compute( Msg, 16#FFFF );

% See also: http://srecord.sourceforge.net/crc16-ccitt.html

compute( <<>>, CRC ) ->
	
	CRC
;

compute( << Value : 8, Rest /binary >>, CRC ) ->
	
	Index = ( ( CRC bsr 8 ) bxor Value ) band 16#00FF,
	NewCRC = ( ( CRC bsl 8 ) bxor crc_table( Index ) ) band 16#FFFF,
	compute( Rest, NewCRC )
.


crc_table( 16#00 ) -> 16#0000;
crc_table( 16#01 ) -> 16#1021;
crc_table( 16#02 ) -> 16#2042;
crc_table( 16#03 ) -> 16#3063;
crc_table( 16#04 ) -> 16#4084;
crc_table( 16#05 ) -> 16#50A5;
crc_table( 16#06 ) -> 16#60C6;
crc_table( 16#07 ) -> 16#70E7;
crc_table( 16#08 ) -> 16#8108;
crc_table( 16#09 ) -> 16#9129;
crc_table( 16#0A ) -> 16#A14A;
crc_table( 16#0B ) -> 16#B16B;
crc_table( 16#0C ) -> 16#C18C;
crc_table( 16#0D ) -> 16#D1AD;
crc_table( 16#0E ) -> 16#E1CE;
crc_table( 16#0F ) -> 16#F1EF;
crc_table( 16#10 ) -> 16#1231;
crc_table( 16#11 ) -> 16#0210;
crc_table( 16#12 ) -> 16#3273;
crc_table( 16#13 ) -> 16#2252;
crc_table( 16#14 ) -> 16#52B5;
crc_table( 16#15 ) -> 16#4294;
crc_table( 16#16 ) -> 16#72F7;
crc_table( 16#17 ) -> 16#62D6;
crc_table( 16#18 ) -> 16#9339;
crc_table( 16#19 ) -> 16#8318;
crc_table( 16#1A ) -> 16#B37B;
crc_table( 16#1B ) -> 16#A35A;
crc_table( 16#1C ) -> 16#D3BD;
crc_table( 16#1D ) -> 16#C39C;
crc_table( 16#1E ) -> 16#F3FF;
crc_table( 16#1F ) -> 16#E3DE;
crc_table( 16#20 ) -> 16#2462;
crc_table( 16#21 ) -> 16#3443;
crc_table( 16#22 ) -> 16#0420;
crc_table( 16#23 ) -> 16#1401;
crc_table( 16#24 ) -> 16#64E6;
crc_table( 16#25 ) -> 16#74C7;
crc_table( 16#26 ) -> 16#44A4;
crc_table( 16#27 ) -> 16#5485;
crc_table( 16#28 ) -> 16#A56A;
crc_table( 16#29 ) -> 16#B54B;
crc_table( 16#2A ) -> 16#8528;
crc_table( 16#2B ) -> 16#9509;
crc_table( 16#2C ) -> 16#E5EE;
crc_table( 16#2D ) -> 16#F5CF;
crc_table( 16#2E ) -> 16#C5AC;
crc_table( 16#2F ) -> 16#D58D;
crc_table( 16#30 ) -> 16#3653;
crc_table( 16#31 ) -> 16#2672;
crc_table( 16#32 ) -> 16#1611;
crc_table( 16#33 ) -> 16#0630;
crc_table( 16#34 ) -> 16#76D7;
crc_table( 16#35 ) -> 16#66F6;
crc_table( 16#36 ) -> 16#5695;
crc_table( 16#37 ) -> 16#46B4;
crc_table( 16#38 ) -> 16#B75B;
crc_table( 16#39 ) -> 16#A77A;
crc_table( 16#3A ) -> 16#9719;
crc_table( 16#3B ) -> 16#8738;
crc_table( 16#3C ) -> 16#F7DF;
crc_table( 16#3D ) -> 16#E7FE;
crc_table( 16#3E ) -> 16#D79D;
crc_table( 16#3F ) -> 16#C7BC;
crc_table( 16#40 ) -> 16#48C4;
crc_table( 16#41 ) -> 16#58E5;
crc_table( 16#42 ) -> 16#6886;
crc_table( 16#43 ) -> 16#78A7;
crc_table( 16#44 ) -> 16#0840;
crc_table( 16#45 ) -> 16#1861;
crc_table( 16#46 ) -> 16#2802;
crc_table( 16#47 ) -> 16#3823;
crc_table( 16#48 ) -> 16#C9CC;
crc_table( 16#49 ) -> 16#D9ED;
crc_table( 16#4A ) -> 16#E98E;
crc_table( 16#4B ) -> 16#F9AF;
crc_table( 16#4C ) -> 16#8948;
crc_table( 16#4D ) -> 16#9969;
crc_table( 16#4E ) -> 16#A90A;
crc_table( 16#4F ) -> 16#B92B;
crc_table( 16#50 ) -> 16#5AF5;
crc_table( 16#51 ) -> 16#4AD4;
crc_table( 16#52 ) -> 16#7AB7;
crc_table( 16#53 ) -> 16#6A96;
crc_table( 16#54 ) -> 16#1A71;
crc_table( 16#55 ) -> 16#0A50;
crc_table( 16#56 ) -> 16#3A33;
crc_table( 16#57 ) -> 16#2A12;
crc_table( 16#58 ) -> 16#DBFD;
crc_table( 16#59 ) -> 16#CBDC;
crc_table( 16#5A ) -> 16#FBBF;
crc_table( 16#5B ) -> 16#EB9E;
crc_table( 16#5C ) -> 16#9B79;
crc_table( 16#5D ) -> 16#8B58;
crc_table( 16#5E ) -> 16#BB3B;
crc_table( 16#5F ) -> 16#AB1A;
crc_table( 16#60 ) -> 16#6CA6;
crc_table( 16#61 ) -> 16#7C87;
crc_table( 16#62 ) -> 16#4CE4;
crc_table( 16#63 ) -> 16#5CC5;
crc_table( 16#64 ) -> 16#2C22;
crc_table( 16#65 ) -> 16#3C03;
crc_table( 16#66 ) -> 16#0C60;
crc_table( 16#67 ) -> 16#1C41;
crc_table( 16#68 ) -> 16#EDAE;
crc_table( 16#69 ) -> 16#FD8F;
crc_table( 16#6A ) -> 16#CDEC;
crc_table( 16#6B ) -> 16#DDCD;
crc_table( 16#6C ) -> 16#AD2A;
crc_table( 16#6D ) -> 16#BD0B;
crc_table( 16#6E ) -> 16#8D68;
crc_table( 16#6F ) -> 16#9D49;
crc_table( 16#70 ) -> 16#7E97;
crc_table( 16#71 ) -> 16#6EB6;
crc_table( 16#72 ) -> 16#5ED5;
crc_table( 16#73 ) -> 16#4EF4;
crc_table( 16#74 ) -> 16#3E13;
crc_table( 16#75 ) -> 16#2E32;
crc_table( 16#76 ) -> 16#1E51;
crc_table( 16#77 ) -> 16#0E70;
crc_table( 16#78 ) -> 16#FF9F;
crc_table( 16#79 ) -> 16#EFBE;
crc_table( 16#7A ) -> 16#DFDD;
crc_table( 16#7B ) -> 16#CFFC;
crc_table( 16#7C ) -> 16#BF1B;
crc_table( 16#7D ) -> 16#AF3A;
crc_table( 16#7E ) -> 16#9F59;
crc_table( 16#7F ) -> 16#8F78;
crc_table( 16#80 ) -> 16#9188;
crc_table( 16#81 ) -> 16#81A9;
crc_table( 16#82 ) -> 16#B1CA;
crc_table( 16#83 ) -> 16#A1EB;
crc_table( 16#84 ) -> 16#D10C;
crc_table( 16#85 ) -> 16#C12D;
crc_table( 16#86 ) -> 16#F14E;
crc_table( 16#87 ) -> 16#E16F;
crc_table( 16#88 ) -> 16#1080;
crc_table( 16#89 ) -> 16#00A1;
crc_table( 16#8A ) -> 16#30C2;
crc_table( 16#8B ) -> 16#20E3;
crc_table( 16#8C ) -> 16#5004;
crc_table( 16#8D ) -> 16#4025;
crc_table( 16#8E ) -> 16#7046;
crc_table( 16#8F ) -> 16#6067;
crc_table( 16#90 ) -> 16#83B9;
crc_table( 16#91 ) -> 16#9398;
crc_table( 16#92 ) -> 16#A3FB;
crc_table( 16#93 ) -> 16#B3DA;
crc_table( 16#94 ) -> 16#C33D;
crc_table( 16#95 ) -> 16#D31C;
crc_table( 16#96 ) -> 16#E37F;
crc_table( 16#97 ) -> 16#F35E;
crc_table( 16#98 ) -> 16#02B1;
crc_table( 16#99 ) -> 16#1290;
crc_table( 16#9A ) -> 16#22F3;
crc_table( 16#9B ) -> 16#32D2;
crc_table( 16#9C ) -> 16#4235;
crc_table( 16#9D ) -> 16#5214;
crc_table( 16#9E ) -> 16#6277;
crc_table( 16#9F ) -> 16#7256;
crc_table( 16#A0 ) -> 16#B5EA;
crc_table( 16#A1 ) -> 16#A5CB;
crc_table( 16#A2 ) -> 16#95A8;
crc_table( 16#A3 ) -> 16#8589;
crc_table( 16#A4 ) -> 16#F56E;
crc_table( 16#A5 ) -> 16#E54F;
crc_table( 16#A6 ) -> 16#D52C;
crc_table( 16#A7 ) -> 16#C50D;
crc_table( 16#A8 ) -> 16#34E2;
crc_table( 16#A9 ) -> 16#24C3;
crc_table( 16#AA ) -> 16#14A0;
crc_table( 16#AB ) -> 16#0481;
crc_table( 16#AC ) -> 16#7466;
crc_table( 16#AD ) -> 16#6447;
crc_table( 16#AE ) -> 16#5424;
crc_table( 16#AF ) -> 16#4405;
crc_table( 16#B0 ) -> 16#A7DB;
crc_table( 16#B1 ) -> 16#B7FA;
crc_table( 16#B2 ) -> 16#8799;
crc_table( 16#B3 ) -> 16#97B8;
crc_table( 16#B4 ) -> 16#E75F;
crc_table( 16#B5 ) -> 16#F77E;
crc_table( 16#B6 ) -> 16#C71D;
crc_table( 16#B7 ) -> 16#D73C;
crc_table( 16#B8 ) -> 16#26D3;
crc_table( 16#B9 ) -> 16#36F2;
crc_table( 16#BA ) -> 16#0691;
crc_table( 16#BB ) -> 16#16B0;
crc_table( 16#BC ) -> 16#6657;
crc_table( 16#BD ) -> 16#7676;
crc_table( 16#BE ) -> 16#4615;
crc_table( 16#BF ) -> 16#5634;
crc_table( 16#C0 ) -> 16#D94C;
crc_table( 16#C1 ) -> 16#C96D;
crc_table( 16#C2 ) -> 16#F90E;
crc_table( 16#C3 ) -> 16#E92F;
crc_table( 16#C4 ) -> 16#99C8;
crc_table( 16#C5 ) -> 16#89E9;
crc_table( 16#C6 ) -> 16#B98A;
crc_table( 16#C7 ) -> 16#A9AB;
crc_table( 16#C8 ) -> 16#5844;
crc_table( 16#C9 ) -> 16#4865;
crc_table( 16#CA ) -> 16#7806;
crc_table( 16#CB ) -> 16#6827;
crc_table( 16#CC ) -> 16#18C0;
crc_table( 16#CD ) -> 16#08E1;
crc_table( 16#CE ) -> 16#3882;
crc_table( 16#CF ) -> 16#28A3;
crc_table( 16#D0 ) -> 16#CB7D;
crc_table( 16#D1 ) -> 16#DB5C;
crc_table( 16#D2 ) -> 16#EB3F;
crc_table( 16#D3 ) -> 16#FB1E;
crc_table( 16#D4 ) -> 16#8BF9;
crc_table( 16#D5 ) -> 16#9BD8;
crc_table( 16#D6 ) -> 16#ABBB;
crc_table( 16#D7 ) -> 16#BB9A;
crc_table( 16#D8 ) -> 16#4A75;
crc_table( 16#D9 ) -> 16#5A54;
crc_table( 16#DA ) -> 16#6A37;
crc_table( 16#DB ) -> 16#7A16;
crc_table( 16#DC ) -> 16#0AF1;
crc_table( 16#DD ) -> 16#1AD0;
crc_table( 16#DE ) -> 16#2AB3;
crc_table( 16#DF ) -> 16#3A92;
crc_table( 16#E0 ) -> 16#FD2E;
crc_table( 16#E1 ) -> 16#ED0F;
crc_table( 16#E2 ) -> 16#DD6C;
crc_table( 16#E3 ) -> 16#CD4D;
crc_table( 16#E4 ) -> 16#BDAA;
crc_table( 16#E5 ) -> 16#AD8B;
crc_table( 16#E6 ) -> 16#9DE8;
crc_table( 16#E7 ) -> 16#8DC9;
crc_table( 16#E8 ) -> 16#7C26;
crc_table( 16#E9 ) -> 16#6C07;
crc_table( 16#EA ) -> 16#5C64;
crc_table( 16#EB ) -> 16#4C45;
crc_table( 16#EC ) -> 16#3CA2;
crc_table( 16#ED ) -> 16#2C83;
crc_table( 16#EE ) -> 16#1CE0;
crc_table( 16#EF ) -> 16#0CC1;
crc_table( 16#F0 ) -> 16#EF1F;
crc_table( 16#F1 ) -> 16#FF3E;
crc_table( 16#F2 ) -> 16#CF5D;
crc_table( 16#F3 ) -> 16#DF7C;
crc_table( 16#F4 ) -> 16#AF9B;
crc_table( 16#F5 ) -> 16#BFBA;
crc_table( 16#F6 ) -> 16#8FD9;
crc_table( 16#F7 ) -> 16#9FF8;
crc_table( 16#F8 ) -> 16#6E17;
crc_table( 16#F9 ) -> 16#7E36;
crc_table( 16#FA ) -> 16#4E55;
crc_table( 16#FB ) -> 16#5E74;
crc_table( 16#FC ) -> 16#2E93;
crc_table( 16#FD ) -> 16#3EB2;
crc_table( 16#FE ) -> 16#0ED1;
crc_table( 16#FF ) -> 16#1EF0.

% EOF
