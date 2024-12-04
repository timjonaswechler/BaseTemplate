## A class representing Semantic Versioning 2.0.0 compliant version numbers.
## Format: MAJOR.MINOR.PATCH[-PRERELEASE][+BUILD]
## 
## Examples:
## - 1.0.0
## - 1.0.0-alpha
## - 1.0.0-alpha.1 
## - 1.0.0-alpha.beta
## - 1.0.0+001
## - 1.0.0-alpha+001
##
## Rules:
## - MAJOR version when you make incompatible API changes
## - MINOR version when you add functionality in a backwards compatible manner
## - PATCH version when you make backwards compatible bug fixes
## - Pre-release and build metadata available as extensions to the MAJOR.MINOR.PATCH format
class_name SemanticVersion
extends RefCounted

## @property major The major version number
## @property minor The minor version number  
## @property patch The patch version number
## @property pre_release The pre-release version string (e.g. "alpha.1")
## @property build The build metadata string
var major: int = 0
var minor: int = 0
var patch: int = 0
var pre_release: String = ""
var build: String = ""

## Creates a new SemanticVersion instance
## @param version_string The version string to parse (default: "0.0.0")
func _init(version_string: String = "0.0.0") -> void:
    parse_version(version_string)
    
## Parses a version string into its components
## @param version_string The version string to parse
func parse_version(version_string: String) -> void:
    var parts = version_string.split("+")
    var version_and_pre = parts[0].split("-")
    
    # Parse core version
    var core_version = version_and_pre[0].split(".")
    if core_version.size() >= 3:
        major = core_version[0].to_int()
        minor = core_version[1].to_int()
        patch = core_version[2].to_int()
    
    # Parse pre-release if exists
    if version_and_pre.size() > 1:
        pre_release = version_and_pre[1]
    
    # Parse build if exists
    if parts.size() > 1:
        build = parts[1]

## Checks if the version is valid according to Semantic Versioning 2.0.0 rules
## @return true if valid, false otherwise
func is_valid() -> bool:
    if major < 0 or minor < 0 or patch < 0:
        return false
    
    if not pre_release.is_empty():
        var pre_parts = pre_release.split(".")
        for part in pre_parts:
            if part.is_empty():
                return false
            if not _is_valid_identifier(part):
                return false
    
    if not build.is_empty():
        var build_parts = build.split(".")
        for part in build_parts:
            if part.is_empty():
                return false
            if not _is_valid_identifier(part):
                return false
    
    return true

## Validates if an identifier is valid according to SemVer rules
## @param identifier The identifier string to validate
## @return true if valid, false otherwise 
func _is_valid_identifier(identifier: String) -> bool:
    if identifier.is_empty():
        return false
    
    var is_numeric = true
    for c in identifier:
        if not c.is_valid_int():
            is_numeric = false
            if not (c.is_valid_int() or c.is_valid_identifier() or c == '-'):
                return false
    
    if is_numeric and identifier.length() > 1 and identifier[0] == '0':
        return false
    
    return true

## Converts the version to its string representation
## @return The full version string
func to_string() -> String:
    var result = "%d.%d.%d" % [major, minor, patch]
    
    if not pre_release.is_empty():
        result += "-%s" % pre_release
    
    if not build.is_empty():
        result += "+%s" % build
    
    return result

## Compares this version with another version
## @param other The version to compare with
## @return Positive if this version is greater, negative if less, 0 if equal
func compare_to(other: SemanticVersion) -> int:
    if major != other.major:
        return major - other.major
    if minor != other.minor:
        return minor - other.minor
    if patch != other.patch:
        return patch - other.patch
    
    # Pre-release versions have lower precedence
    if pre_release.is_empty() and not other.pre_release.is_empty():
        return 1
    if not pre_release.is_empty() and other.pre_release.is_empty():
        return -1
    
    return 0