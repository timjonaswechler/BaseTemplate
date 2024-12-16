# https://devhints.io/
#  -> https://github.com/rstacruz/cheatsheets/blob/83e30b2c0e53b373424d1f0039f97e6a3746deb9/semver.md?plain=1#L4
# https://semver.org/

class_name SemanticVersion

#| 'MAJOR' | incompatible API changes |
#| 'MINOR' | add functionality (backwards - compatible) |
#| 'PATCH' | bug fixes (backwards - compatible) |

var major: int = 0
var minor: int = 0
var patch: int = 0
var status: String = "" # prerelease
var build: String = ""


func _init(version) -> void:
	if version is not SemanticVersion:
		parse(_clean(version))

func parse(version) -> SemanticVersion:
	if version is SemanticVersion:
		return version
	if version is String:
		## Source: https://regex101.com/r/Ly7O1x/3/
		var regex: RegEx = RegEx.new()
		regex.compile("^(?P<major>0|[1-9]\\d*)\\.(?P<minor>0|[1-9]\\d*)\\.(?P<patch>0|[1-9]\\d*)(?:-(?P<prerelease>(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*)(?:\\.(?:0|[1-9]\\d*|\\d*[a-zA-Z-][0-9a-zA-Z-]*))*))?(?:\\+(?P<buildmetadata>[0-9a-zA-Z-]+(?:\\.[0-9a-zA-Z-]+)*))?$")
		var matches = regex.search(version)
		if matches:
			# Major
			major = matches.strings[1].to_int()
			minor = matches.strings[2].to_int()
			patch = matches.strings[3].to_int()
			status = matches.strings[4]
			build = matches.strings[5]

			return self
		else:
			Log.warn("The Regex (https://regex101.com/r/Ly7O1x/3/) does not match with your version. Your version was: " + version)
			return null
	else:
		Log.warn("The parsed Version: " + version + " is not a type of SemanticVersion or String")
		return null

func is_compatible_with(dependencies: String) -> bool:
	# Handle special cases
	if dependencies == '*' or dependencies == 'x':
		return true

	# Handle caret ranges (^)
	if dependencies.begins_with("^"):
		return _check_caret_range(dependencies)

	# Handle tilde ranges (~)
	if dependencies.begins_with("~"):
		return _check_tilde_range(dependencies)

	# Handle hyphenated ranges
	if dependencies.count('-') == 1:
		return _check_hyphenated_range(dependencies)

	# Handle OR conditions
	if dependencies.count('||') >= 1:
		return _check_or_conditions(dependencies)

	# Handle single comparisons
	return check_dependencies(dependencies)

func _check_caret_range(dependencies: String) -> bool:
	var clean_dep = _clean_dependencies(dependencies.trim_prefix("^"))
	var start = SemanticVersion.new(clean_dep)
	var end_exclusiv = SemanticVersion.new(clean_dep)
	
	if end_exclusiv.major > 0:
		end_exclusiv.inc("major")
	elif end_exclusiv.minor > 0:
		end_exclusiv.inc("minor")
	else:
		end_exclusiv.inc("patch")
	
	return greater_equal_then(start) and lower_then(end_exclusiv)

func _check_tilde_range(dependencies: String) -> bool:
	var clean_dep = _clean_dependencies(dependencies.trim_prefix("~"))
	var start = SemanticVersion.new(clean_dep)
	var end_exclusiv = SemanticVersion.new(clean_dep)
	end_exclusiv.inc("minor")
	
	return greater_equal_then(start) and lower_then(end_exclusiv)

func _check_hyphenated_range(dependencies: String) -> bool:
	var parts = dependencies.split('-')
	var start = SemanticVersion.new(_clean_dependencies(parts[0]))
	var end = SemanticVersion.new(_clean_dependencies(parts[1]))
	
	return greater_equal_then(start) and lower_equal_then(end)

func _check_or_conditions(dependencies: String) -> bool:
	for part in dependencies.split('||'):
		if equal(SemanticVersion.new(_clean_dependencies(part))):
			return true
	return false

func check_dependencies(dependencies: String) -> bool:
	dependencies = _clean_dependencies(dependencies)
	var regex: RegEx = RegEx.new()
	# Kompiliere Regex für Vergleichsoperatoren und Versionen
	regex.compile("\\s*(=|<|>|>=|<=)\\s*\\d+(?:\\.\\d+)?(?:\\.\\d+)?")
	var parts = regex.search_all(dependencies)
	
	# Wenn keine gültigen Vergleichsoperatoren gefunden wurden
	if parts.is_empty():
		return false
	
	# Prüfe alle gefundenen Bedingungen
	for part in parts:
		var cleaned_part = part.strings[0].replace(part.strings[1], '')
		var version = SemanticVersion.new(_clean_dependencies(cleaned_part))
		
		var condition_met = false
		match part.strings[1]:
			&">=": condition_met = greater_equal_then(version)
			&"<=": condition_met = lower_equal_then(version)
			&">": condition_met = greater_then(version)
			&"<": condition_met = lower_then(version)
			&"=": condition_met = equal(version)
			
		if not condition_met:
			return false
	
	return true
		
func inc(part: String):
	match part.to_lower():
		&"major":
			major += 1
			minor = 0
			patch = 0
		&"minor":
			minor += 1
			patch = 0
		&"patch":
			patch += 1
		_:
			push_error("Invalid version part: " + part)
	
func greater_equal_then(other: SemanticVersion) -> bool:
	if major > other.major:
		return true
	if major < other.major:
		return false
	# major ist gleich, prüfe minor
	if minor > other.minor:
		return true
	if minor < other.minor:
		return false
	# minor ist auch gleich, prüfe patch
	return patch >= other.patch

func greater_then(other: SemanticVersion) -> bool:
	if major > other.major:
		return true
	if major < other.major:
		return false
	# major ist gleich, prüfe minor
	if minor > other.minor:
		return true
	if minor < other.minor:
		return false
	# minor ist auch gleich, prüfe patch
	return patch > other.patch
				
func lower_equal_then(other: SemanticVersion) -> bool:
	if major < other.major:
		return true
	if major > other.major:
		return false
	# major ist gleich, prüfe minor
	if minor < other.minor:
		return true
	if minor > other.minor:
		return false
	# minor ist auch gleich, prüfe patch
	return patch <= other.patch

func lower_then(other: SemanticVersion) -> bool:
	if major < other.major:
		return true
	if major > other.major:
		return false
	# major ist gleich, prüfe minor
	if minor < other.minor:
		return true
	if minor > other.minor:
		return false
	# minor ist auch gleich, prüfe patch
	return patch < other.patch

func equal(other: SemanticVersion) -> bool:
	Log.info("Verion %s.%s.%s is = to %s.%s.%s %s" % [major, minor, patch, other.major, other.minor, other.patch, (major == other.major and minor == other.minor and patch == other.patch)])
	return major == other.major and minor == other.minor and patch == other.patch

func _clean_dependencies(dependencies: String) -> String:
	var regex: RegEx = RegEx.new()
	dependencies = dependencies.replace(' ', '')
	dependencies = dependencies.replace('x', '0')
	dependencies = dependencies.replace('*', '0')
	if dependencies.count('.') == 0:
		dependencies += '.0.0'
	elif dependencies.count('.') == 1:
		regex.compile('[0-9]$')
		var match = regex.search(dependencies)
		if match:
			dependencies += '.0'
		else:
			dependencies += '0.0'
	elif dependencies.count('.') == 2:
		regex.compile('[0-9]$')
		var match = regex.search(dependencies)
		if not match:
			dependencies += '0'
		
	return dependencies

func _clean(versionString) -> String:
	var regex: RegEx = RegEx.new()
	regex.compile("^[a-zA-Z\\s]+")
	var match = regex.search(versionString)
	if match:
		return versionString.replace(match.strings[0], '')
	return versionString
