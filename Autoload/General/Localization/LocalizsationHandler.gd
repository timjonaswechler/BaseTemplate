class_name LocalizationHandler

static func setLanguage(index: int) -> void:
	var language = TranslationServer.get_loaded_locales()[index]
	TranslationServer.set_locale(language)
	language = available_languages[findLanguage(language)]
	SettingsHandler.update_localization_section(GameSettings.CurrentLanguageSetting, language.iso_code)
	Log.info("Language set to: " + language.english_name)

static func findLanguage(iso_code: String) -> int:
	for i in LocalizationHandler.available_languages:
		if LocalizationHandler.available_languages[i].iso_code == iso_code:
			return i
	return -1

static func loadLanguages():
	var data = {}
	for dir in _findLocaleDirs("user://data"):
		for file in _findAllCSV(dir):
			Log.info("Load CSV: " + file)
			var csv_data = _importCSV(file)
			if csv_data:
				for lang in csv_data:
					# if ISO-Code is incorret (-1), language will not been loaded
					if findLanguage(lang) > -1:
						if data.has(lang):
							data[lang].merge(csv_data[lang])
						else:
							data[lang] = csv_data[lang]		
					else: 
						Log.warn("ISO-Code \"" + lang + "\" in " + file)

	# Remove empty languages from data
	var languages_to_remove = []
	for lang in data:
		if data[lang] == {}:
			languages_to_remove.append(lang)
		
		
	for lang in languages_to_remove:
		data.erase(lang)
	
	# load languages in TranslationServer
	for lang in data:
		var translation = Translation.new()
		translation.locale = lang
		for key in data[lang].keys():
			translation.add_message(key, data[lang][key])
		TranslationServer.add_translation(translation)
		
static func _importCSV(source_file):
	var delim = ","
		
	var file = FileAccess.open(source_file, FileAccess.READ)
	if not file:
		Log.err("Failed to open file: ", source_file)
		return

	var lines = []
	while not file.eof_reached():
		var line = file.get_csv_line(delim)
		if lines.size() > 0:
			var detected := []
			for field in line:
				detected.append(field)
			lines.append(detected)
		else:
			lines.append(line)

	file.close()
	
	# Remove trailing empty line
	if not lines.is_empty() and lines.back().size() == 1 and lines.back()[0] == "":
		lines.pop_back()

	if lines.is_empty():
		printerr("Can't find header in empty file")
		return ERR_PARSE_ERROR

	var data = {}
	for col in range(1, lines[0].size()):
		var lang = lines[0][col]
		data[lang] = {}
		for row in range(1, lines.size()):
			var key = lines[row][0]
			var value = lines[row][col]
			data[lang][key] = value
	return data
	
static func _findLocaleDirs(path):
	var locale_dirs = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			var full_path = path.path_join(file_name)
			
			if dir.current_is_dir():
				if file_name == "locale":
					locale_dirs.append(full_path)
				else:
					locale_dirs.append_array(_findLocaleDirs(full_path))
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	return locale_dirs
	
static func _findAllCSV(path):
	var csv_files = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			var full_path = path.path_join(file_name)
			
			if not dir.current_is_dir() and file_name.ends_with(".csv"):
				csv_files.append(full_path)
			
			file_name = dir.get_next()
		
		dir.list_dir_end()
	
	return csv_files

class Language:
	var code: String
	var iso_code: String
	var native_name: String
	var english_name: String
	
	func _init(_code: String, _iso_code: String, _native_name: String, _english_name: String) -> void:
		code = _code
		iso_code = _iso_code
		native_name = _native_name
		english_name = _english_name

enum Languages {
	Arabic,
	Bulgarian,
	#ChineseSimplified,
	#ChineseTraditional,
	Czech,
	Danish,
	Dutch,
	English,
	Finnish,
	French,
	German,
	Greek,
	Hindi,
	Hungarian,
	Indonesian,
	Italian,
	#Japanese,
	Korean,
	Latvian,
	NorwegianBokmal,
	Polish,
	Portuguese,
	PortugueseBrazilian,
	Russian,
	Romanian,
	Spanish,
	Swedish,
	Turkish,
	Ukrainian,


	#Esperanto,
	#Vietnamese,
	#Persian,
	#Thai,
	#Malayalam,
	#Telugu,
	#Tamil,
	#Marathi,
	#Gujarati,
	#Kannada,
	#Bengali,
	#Punjabi,
	#Urdu,
	#Odia,
	#Assamese,
	#Malay,
	#Tagalog,
	#Filipino,
	#Serbian,
	#Croatian,
	#Bosnian,
	#Slovenian,
	#Albanian,
	#Macedonian,
	#Montenegrin,
	#Georgian,
	#Armenian,
	#Kazakh,
	#Uzbek,
	#Kyrgyz,
	#Turkmen,
	#Azerbaijani,
	#Belarusian,
	#Moldovan,
	#Lithuanian,
	#Estonian,
	#Swahili,
	#Yoruba,
	#Igbo,
	#Zulu,
	#Xhosa,
	#Afrikaans,
	#Amharic,
	#Tigrinya,
	#Oromo,
	#Somali,
	#Hausa,
	#Fulfulde,
	#Kanuri,
	#Mandinka,
	#Wolof,
	#Serer,
	#Shona,
	#Ndebele,
	#Sesotho,
	#Setswana,
	#Sepedi,
	#Tswana,
	#Venda,
	#Tsonga,
	#Herero,
	#Nama,
	#Damara,
	#Lingala,
	#Kikongo,
	#Kongo,
	#Mbundu,
	#Kimbundu,
	#Tumbuka,
	#Chichewa,
	#Bemba,
	#Nyanja,
}

static var available_languages: Dictionary = {
	## Common languages
	Languages.Arabic: Language.new("ar", "ar_EG", "العربية", "Arabic"),
	Languages.Bulgarian: Language.new("bg", "bg_BG", "Български", "Bulgarian"),
	#Languages.ChineseSimplified: Language.new("zh_CN", "zh_CN", "简体中文", "Chinese Simplified"),
	#Languages.ChineseTraditional: Language.new("zh_TW", "zh_TW", "繁體中文", "Chinese Traditional"),
	Languages.Czech: Language.new("cs", "cs_CZ", "Czech", "Czech"),
	Languages.Danish: Language.new("da", "da_DK", "Dansk", "Danish"),
	Languages.Dutch: Language.new("nl", "nl_NL", "Nederlands", "Dutch"),
	Languages.English: Language.new("en", "en_US", "English", "English"),
	Languages.Finnish: Language.new("fi", "fi_FI", "Suomi", "Finnish"),
	Languages.French: Language.new("fr", "fr_FR", "Français", "French"),
	Languages.German: Language.new("de", "de_DE", "Deutsch", "German"),
	Languages.Greek: Language.new("el", "el_GR", "Ελληνικά", "Greek"),
	Languages.Hindi: Language.new("hi", "hi_IN", "हिंदी", "Hindi"),
	Languages.Hungarian: Language.new("hu", "hu_HU", "Magyar", "Hungarian"),
	Languages.Indonesian: Language.new("id", "id_ID", "Indonesian", "Indonesian"),
	Languages.Italian: Language.new("it", "it_IT", "Italiano", "Italian"),
	#Languages.Japanese: Language.new("ja", "ja_JP", "日本語", "Japanese"),
	Languages.Korean: Language.new("ko", "ko_KR", "한국어", "Korean"),
	Languages.Latvian: Language.new("lv", "lv_LV", "Latvian", "Latvian"),
	Languages.NorwegianBokmal: Language.new("nb", "nb_NO", "Norsk Bokmål", "Norwegian Bokmål"),
	Languages.Polish: Language.new("pl", "pl_PL", "Polski", "Polish"),
	Languages.Portuguese: Language.new("pt", "pt_PT", "Português", "Portuguese"),
	Languages.PortugueseBrazilian: Language.new("pt_BR", "pt_BR", "Português Brasileiro", "Brazilian Portuguese"),
	Languages.Russian: Language.new("ru", "ru_RU", "Русский", "Russian"),
	Languages.Romanian: Language.new("ro", "ro_RO", "Română", "Romanian"),
	Languages.Spanish: Language.new("es", "es_ES", "Español", "Spanish"),
	Languages.Swedish: Language.new("sv", "sv_SE", "Svenska", "Swedish"),
	Languages.Turkish: Language.new("tr", "tr_TR", "Türkçe", "Turkish"),
	Languages.Ukrainian: Language.new("uk", "uk_UA", "Українська", "Ukrainian"),
	
	
	## Not so common languages
	#Languages.Esperanto: Language.new("eo", "eo_UY", "Esperanto", "Esperanto"),
	#Languages.Vietnamese: Language.new("vi", "vi_VN", "Tiếng Việt", "Vietnamese"),
	#Languages.Persian: Language.new("fa", "fa_IR", "فارسی", "Persian"),
	#Languages.Thai: Language.new("th", "th_TH", "ภาษาไทย", "Thai"),
	#Languages.Malayalam: Language.new("ml", "ml_IN", "മലയാളം", "Malayalam"),
	#Languages.Telugu: Language.new("te", "te_IN", "తెలుగు", "Telugu"),
	#Languages.Tamil: Language.new("ta", "ta_IN", "தமிழ்", "Tamil"),
	#Languages.Marathi: Language.new("mr", "mr_IN", "मराठी", "Marathi"),
	#Languages.Gujarati: Language.new("gu", "gu_IN", "ગુજરાતી", "Gujarati"),
	#Languages.Kannada: Language.new("kn", "kn_IN", "ಕನ್ನಡ", "Kannada"),
	#Languages.Bengali: Language.new("bn", "bn_BD", "বাংলা", "Bengali"),
	#Languages.Punjabi: Language.new("pa", "pa_IN", "ਪੰਜਾਬੀ", "Punjabi"),
	#Languages.Urdu: Language.new("ur", "ur_PK", "اردو", "Urdu"),
	#Languages.Odia: Language.new("or", "or_IN", "ଓଡ଼ିଆ", "Odia"),
	#Languages.Assamese: Language.new("as", "as_IN", "অসমীয়া", "Assamese"),
	#Languages.Malay: Language.new("ms", "ms_MY", "Bahasa Melayu", "Malay"),
	#Languages.Tagalog: Language.new("tl", "tl_PH", "Tagalog", "Tagalog"),
	#Languages.Filipino: Language.new("fil", "fil_PH", "Filipino", "Filipino"),
	#Languages.Serbian: Language.new("sr", "sr_RS", "Српски", "Serbian"),
	#Languages.Croatian: Language.new("hr", "hr_HR", "Hrvatski", "Croatian"),
	#Languages.Bosnian: Language.new("bs", "bs_BA", "Bosanski", "Bosnian"),
	#Languages.Slovenian: Language.new("sl", "sl_SI", "Slovenščina", "Slovenian"),
	#Languages.Albanian: Language.new("sq", "sq_AL", "Shqip", "Albanian"),
	#Languages.Macedonian: Language.new("mk", "mk_MK", "Македонски", "Macedonian"),
	#Languages.Montenegrin: Language.new("mn", "mn_ME", "Црногорски", "Montenegrin"),
	#Languages.Georgian: Language.new("ka", "ka_GE", "ქართული", "Georgian"),
	#Languages.Armenian: Language.new("hy", "hy_AM", "Հայերեն", "Armenian"),
	#Languages.Kazakh: Language.new("kk", "kk_KZ", "Қазақша", "Kazakh"),
	#Languages.Uzbek: Language.new("uz", "uz_UZ", "Oʻzbekcha", "Uzbek"),
	#Languages.Kyrgyz: Language.new("ky", "ky_KG", "Кыргызча", "Kyrgyz"),
	#Languages.Turkmen: Language.new("tk", "tk_TM", "Türkmençe", "Turkmen"),
	#Languages.Azerbaijani: Language.new("az", "az_AZ", "Azərbaycanca", "Azerbaijani"),
	#Languages.Belarusian: Language.new("be", "be_BY", "Беларуская", "Belarusian"),
	#Languages.Moldovan: Language.new("mo", "mo_MD", "Moldovenească", "Moldovan"),
	#Languages.Lithuanian: Language.new("lt", "lt_LT", "Lietuvių", "Lithuanian"),
	#Languages.Estonian: Language.new("et", "et_EE", "Eesti keel", "Estonian"),
	#Languages.Swahili: Language.new("sw", "sw_TZ", "Kiswahili", "Swahili"),
	#Languages.Yoruba: Language.new("yo", "yo_NG", "Yorùbá", "Yoruba"),
	#Languages.Igbo: Language.new("ig", "ig_NG", "Igbo", "Igbo"),
	#Languages.Zulu: Language.new("zu", "zu_ZA", "IsiZulu", "Zulu"),
	#Languages.Xhosa: Language.new("xh", "xh_ZA", "IsiXhosa", "Xhosa"),
	#Languages.Afrikaans: Language.new("af", "af_ZA", "Afrikaans", "Afrikaans"),
	#Languages.Amharic: Language.new("am", "am_ET", "አማርኛ", "Amharic"),
	#Languages.Tigrinya: Language.new("ti", "ti_ER", "ትግርኛ", "Tigrinya"),
	#Languages.Oromo: Language.new("om", "om_ET", "Afaan Oromoo", "Oromo"),
	#Languages.Somali: Language.new("so", "so_SO", "Soomaali", "Somali"),
	#Languages.Hausa: Language.new("ha", "ha_NG", "Hausa", "Hausa"),
	#Languages.Fulfulde: Language.new("ff", "ff_CM", "Fulfulde", "Fulfulde"),
	#Languages.Kanuri: Language.new("kr", "kr_NG", "Kanuri", "Kanuri"),
	#Languages.Mandinka: Language.new("mnk", "mnk_GM", "Mandinka", "Mandinka"),
	#Languages.Wolof: Language.new("wo", "wo_SN", "Wolof", "Wolof"),
	#Languages.Serer: Language.new("sr", "sr_SN", "Serer", "Serer"),
	#Languages.Shona: Language.new("sh", "sh_ZW", "Shona", "Shona"),
	#Languages.Ndebele: Language.new("nd", "nd_ZW", "Ndebele", "Ndebele"),
	#Languages.Sesotho: Language.new("st", "st_ZA", "Sesotho", "Sesotho"),
	#Languages.Setswana: Language.new("tn", "tn_ZA", "Setswana", "Setswana"),
	#Languages.Sepedi: Language.new("nso", "nso_ZA", "Sepedi", "Sepedi"),
	#Languages.Tswana: Language.new("ts", "ts_ZA", "Tswana", "Tswana"),
	#Languages.Venda: Language.new("ve", "ve_ZA", "Venda", "Venda"),
	#Languages.Tsonga: Language.new("ts", "ts_ZA", "Tsonga", "Tsonga"),
	#Languages.Lingala: Language.new("ln", "ln_CD", "Lingala", "Lingala"),
	#Languages.Kikongo: Language.new("kg", "kg_CD", "Kikongo", "Kikongo"),
	#Languages.Kongo: Language.new("kon", "kon_CD", "Kongo", "Kongo"),
	#Languages.Mbundu: Language.new("umb", "umb_AO", "Umbundu", "Mbundu"),
	#Languages.Kimbundu: Language.new("kmb", "kmb_AO", "Kimbundu", "Kimbundu"),
	#Languages.Tumbuka: Language.new("tum", "tum_MW", "Tumbuka", "Tumbuka"),
	#Languages.Chichewa: Language.new("ny", "ny_MW", "Chichewa", "Chichewa"),
	#Languages.Bemba: Language.new("bem", "bem_ZM", "Bemba", "Bemba"),
	#Languages.Nyanja: Language.new("nyn", "nyn_MW", "Nyanja", "Nyanja"),
	#Languages.Herero: Language.new("hz", "hz_NA", "Otjiherero", "Herero"),
	#Languages.Nama: Language.new("na", "na_NA", "Nama", "Nama"),
	#Languages.Damara: Language.new("da", "da_NA", "Damara", "Damara")
}

#region Language shorcuts
static func english() -> Language:
	return available_languages[Languages.English]
	
static func french() -> Language:
	return available_languages[Languages.French]
	
static func czech() -> Language:
	return available_languages[Languages.Czech]
	
static func danish() -> Language:
	return available_languages[Languages.Danish]
	
static func dutch() -> Language:
	return available_languages[Languages.Dutch]
	
static func german() -> Language:
	return available_languages[Languages.German]
	
static func greek() -> Language:
	return available_languages[Languages.Greek]
	
static func spanish() -> Language:
	return available_languages[Languages.Spanish]
	
static func indonesian() -> Language:
	return available_languages[Languages.Indonesian]
	
static func italian() -> Language:
	return available_languages[Languages.Italian]
	
static func latvian() -> Language:
	return available_languages[Languages.Latvian]
	
static func polish() -> Language:
	return available_languages[Languages.Polish]
	
static func portuguese_brazilian() -> Language:
	return available_languages[Languages.PortugueseBrazilian]

static func portuguese() -> Language:
	return available_languages[Languages.Portuguese]
	
static func russian() -> Language:
	return available_languages[Languages.Russian]
	
#static func chinese_simplified() -> Language:
	#return available_languages[Languages.ChineseSimplified]
	#
#static func chinese_traditional() -> Language:
	#return available_languages[Languages.ChineseTraditional]
	
static func norwegian_bokmal() -> Language:
	return available_languages[Languages.NorwegianBokmal]
	
static func hungarian() -> Language:
	return available_languages[Languages.Hungarian]
	
static func romanian() -> Language:
	return available_languages[Languages.Romanian]
	
static func korean() -> Language:
	return available_languages[Languages.Korean]
	
static func turkish() -> Language:
	return available_languages[Languages.Turkish]
	
#static func japanese() -> Language:
	#return available_languages[Languages.Japanese]
	
static func ukrainian() -> Language:
	return available_languages[Languages.Ukrainian]
	
static func bulgarian() -> Language:
	return available_languages[Languages.Bulgarian]

static func finnish() -> Language:
	return available_languages[Languages.Finnish]

static func swedish() -> Language:
	return available_languages[Languages.Swedish]

static func hindi() -> Language:
	return available_languages[Languages.Hindi]

static func arabic() -> Language:
	return available_languages[Languages.Arabic]

#static func esperanto() -> Language:
	#return available_languages[Languages.Esperanto]
	#
#static func vietnamese() -> Language:
	#return available_languages[Languages.Vietnamese]
#
#static func persian() -> Language:
	#return available_languages[Languages.Persian]
#
#static func thai() -> Language:
	#return available_languages[Languages.Thai]
#
#static func malayalam() -> Language:
	#return available_languages[Languages.Malayalam]
#
#static func telugu() -> Language:
	#return available_languages[Languages.Telugu]
#
#static func tamil() -> Language:
	#return available_languages[Languages.Tamil]
#
#static func marathi() -> Language:
	#return available_languages[Languages.Marathi]
#
#static func gujarati() -> Language:
	#return available_languages[Languages.Gujarati]
#
#static func kannada() -> Language:
	#return available_languages[Languages.Kannada]
#
#static func bengali() -> Language:
	#return available_languages[Languages.Bengali]
#
#static func punjabi() -> Language:
	#return available_languages[Languages.Punjabi]
#
#static func urdu() -> Language:
	#return available_languages[Languages.Urdu]
#
#static func odia() -> Language:
	#return available_languages[Languages.Odia]
#
#static func assamese() -> Language:
	#return available_languages[Languages.Assamese]
#
#static func malay() -> Language:
	#return available_languages[Languages.Malay]
#
#static func tagalog() -> Language:
	#return available_languages[Languages.Tagalog]
#
#static func filipino() -> Language:
	#return available_languages[Languages.Filipino]
#
#static func serbian() -> Language:
	#return available_languages[Languages.Serbian]
#
#static func croatian() -> Language:
	#return available_languages[Languages.Croatian]
#
#static func bosnian() -> Language:
	#return available_languages[Languages.Bosnian]
#
#static func slovenian() -> Language:
	#return available_languages[Languages.Slovenian]
#
#static func albanian() -> Language:
	#return available_languages[Languages.Albanian]
#
#static func macedonian() -> Language:
	#return available_languages[Languages.Macedonian]
#
#static func montenegrin() -> Language:
	#return available_languages[Languages.Montenegrin]
#
#static func georgian() -> Language:
	#return available_languages[Languages.Georgian]
#
#static func armenian() -> Language:
	#return available_languages[Languages.Armenian]
#
#static func kazakh() -> Language:
	#return available_languages[Languages.Kazakh]
#
#static func uzbek() -> Language:
	#return available_languages[Languages.Uzbek]
#
#static func kyrgyz() -> Language:
	#return available_languages[Languages.Kyrgyz]
#
#static func turkmen() -> Language:
	#return available_languages[Languages.Turkmen]
#
#static func azerbaijani() -> Language:
	#return available_languages[Languages.Azerbaijani]
#
#static func belarusian() -> Language:
	#return available_languages[Languages.Belarusian]
#
#static func moldovan() -> Language:
	#return available_languages[Languages.Moldovan]
#
#static func lithuanian() -> Language:
	#return available_languages[Languages.Lithuanian]
#
#static func estonian() -> Language:
	#return available_languages[Languages.Estonian]
#
#static func swahili() -> Language:
	#return available_languages[Languages.Swahili]
#
#static func yoruba() -> Language:
	#return available_languages[Languages.Yoruba]
#
#static func igbo() -> Language:
	#return available_languages[Languages.Igbo]
#
#static func zulu() -> Language:
	#return available_languages[Languages.Zulu]
#
#static func xhosa() -> Language:
	#return available_languages[Languages.Xhosa]
#
#static func afrikaans() -> Language:
	#return available_languages[Languages.Afrikaans]
#
#static func amharic() -> Language:
	#return available_languages[Languages.Amharic]
#
#static func tigrinya() -> Language:
	#return available_languages[Languages.Tigrinya]
#
#static func oromo() -> Language:
	#return available_languages[Languages.Oromo]
#
#static func somali() -> Language:
	#return available_languages[Languages.Somali]
#
#static func hausa() -> Language:
	#return available_languages[Languages.Hausa]
#
#static func fulfulde() -> Language:
	#return available_languages[Languages.Fulfulde]
#
#static func kanuri() -> Language:
	#return available_languages[Languages.Kanuri]
#
#static func mandinka() -> Language:
	#return available_languages[Languages.Mandinka]
#
#static func wolof() -> Language:
	#return available_languages[Languages.Wolof]
#
#static func serer() -> Language:
	#return available_languages[Languages.Serer]
#
#static func shona() -> Language:
	#return available_languages[Languages.Shona]
#
#static func ndebele() -> Language:
	#return available_languages[Languages.Ndebele]
#
#static func sesotho() -> Language:
	#return available_languages[Languages.Sesotho]
#
#static func setswana() -> Language:
	#return available_languages[Languages.Setswana]
#
#static func sepedi() -> Language:
	#return available_languages[Languages.Sepedi]
#
#static func tswana() -> Language:
	#return available_languages[Languages.Tswana]
#
#static func venda() -> Language:
	#return available_languages[Languages.Venda]
#
#static func tsonga() -> Language:
	#return available_languages[Languages.Tsonga]
#
#static func herero() -> Language:
	#return available_languages[Languages.Herero]
#
#static func nama() -> Language:
	#return available_languages[Languages.Nama]
#
#static func damara() -> Language:
	#return available_languages[Languages.Damara]
#
#static func kikongo() -> Language:
	#return available_languages[Languages.Kikongo]
#
#static func kongo() -> Language:
	#return available_languages[Languages.Kongo]
#
#static func mbundu() -> Language:
	#return available_languages[Languages.Mbundu]
#
#static func kimbundu() -> Language:
	#return available_languages[Languages.Kimbundu]
#
#static func tumbuka() -> Language:
	#return available_languages[Languages.Tumbuka]
#
#static func chichewa() -> Language:
	#return available_languages[Languages.Chichewa]
#
#static func bemba() -> Language:
	#return available_languages[Languages.Bemba]
#
#static func nyanja() -> Language:
	#return available_languages[Languages.Nyanja]

#endregion
