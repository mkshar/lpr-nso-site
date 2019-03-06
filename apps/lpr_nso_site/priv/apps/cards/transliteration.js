function transliterate( str, variant )
{
	if( variant == "passport" )
		return str
			.toUpperCase()
			.replace( /А/g, "A"    ) // 01
			.replace( /Б/g, "B"    ) // 02
			.replace( /В/g, "V"    ) // 03
			.replace( /Г/g, "G"    ) // 04
			.replace( /Д/g, "D"    ) // 05
			.replace( /Е/g, "E"    ) // 06
			.replace( /Ё/g, "E"    ) // 07
			.replace( /Ж/g, "ZH"   ) // 08
			.replace( /З/g, "Z"    ) // 09
			.replace( /И/g, "I"    ) // 10
			.replace( /Й/g, "I"    ) // 11
			.replace( /К/g, "K"    ) // 12
			.replace( /Л/g, "L"    ) // 13
			.replace( /М/g, "M"    ) // 14
			.replace( /Н/g, "N"    ) // 15
			.replace( /О/g, "O"    ) // 16
			.replace( /П/g, "P"    ) // 17
			.replace( /Р/g, "R"    ) // 18
			.replace( /С/g, "S"    ) // 19
			.replace( /Т/g, "T"    ) // 20
			.replace( /У/g, "U"    ) // 21
			.replace( /Ф/g, "F"    ) // 22
			.replace( /Х/g, "KH"   ) // 23
			.replace( /Ц/g, "TS"   ) // 24
			.replace( /Ч/g, "CH"   ) // 25
			.replace( /Ш/g, "SH"   ) // 26
			.replace( /Щ/g, "SHCH" ) // 27
			.replace( /Ъ/g, "IE"   ) // 28
			.replace( /Ы/g, "Y"    ) // 29
			.replace( /Ь/g, ""     ) // 30
			.replace( /Э/g, "E"    ) // 31
			.replace( /Ю/g, "IU"   ) // 32
			.replace( /Я/g, "IA"   ) // 33
		;
	// if( variant == "bank" )
		return str
			.toUpperCase()
			.replace( /А/g, "A"    ) // 01
			.replace( /Б/g, "B"    ) // 02
			.replace( /В/g, "V"    ) // 03
			.replace( /Г/g, "G"    ) // 04
			.replace( /Д/g, "D"    ) // 05
			.replace( /Е/g, "E"    ) // 06
			.replace( /Ё/g, "E"    ) // 07
			.replace( /Ж/g, "ZH"   ) // 08
			.replace( /З/g, "Z"    ) // 09
			.replace( /И/g, "I"    ) // 10
			.replace( /Й/g, "Y"    ) // 11
			.replace( /К/g, "K"    ) // 12
			.replace( /Л/g, "L"    ) // 13
			.replace( /М/g, "M"    ) // 14
			.replace( /Н/g, "N"    ) // 15
			.replace( /О/g, "O"    ) // 16
			.replace( /П/g, "P"    ) // 17
			.replace( /Р/g, "R"    ) // 18
			.replace( /С/g, "S"    ) // 19
			.replace( /Т/g, "T"    ) // 20
			.replace( /У/g, "U"    ) // 21
			.replace( /Ф/g, "F"    ) // 22
			.replace( /Х/g, "KH"   ) // 23
			.replace( /Ц/g, "TS"   ) // 24
			.replace( /Ч/g, "CH"   ) // 25
			.replace( /Ш/g, "SH"   ) // 26
			.replace( /Щ/g, "SHCH" ) // 27
			.replace( /Ъ/g, ""     ) // 28
			.replace( /Ы/g, "Y"    ) // 29
			.replace( /Ь/g, ""     ) // 30
			.replace( /Э/g, "E"    ) // 31
			.replace( /Ю/g, "YU"   ) // 32
			.replace( /Я/g, "YA"   ) // 33
		;
		}