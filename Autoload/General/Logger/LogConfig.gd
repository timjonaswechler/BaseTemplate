extends Node

class_name LogConfig

static func get_arguments() -> Dictionary:
	var arguments = {}
	var key = ""
	
	for argument in OS.get_cmdline_args():
			var k = _parse_argument_key(argument)
			if k != "":
				key = k
				arguments[k] = ""
			elif key != "":
				arguments[key] = argument
				key == ""
			if argument.contains("="):
				var key_value = argument.split("=")
				arguments[key] = key_value[1]
				key == ""
	return arguments

static func _parse_argument_key(argument:String) -> String:
	var prefixes = ["+","--","-"]
	for prefix in prefixes:
		if argument.begins_with(prefix):
			if argument.contains("="):
				return argument.split("=")[0].lstrip(prefix)
			return argument.lstrip(prefix)
	return ""

static func get_steam_flag_name(_name:String,prefix:String="") -> String:
	return (prefix + _name).to_lower().replace("-","_")
	
static func get_flag_name(_name:String,prefix:String="") -> String:
	return (prefix + _name).to_lower().replace("_","-")

static func get_env_name(_name:String,prefix:String="") -> String:
	return (prefix + _name).to_upper().replace("-","_")

static func get_var(_name,default=""):
	var env_var_name = get_env_name(_name)
	var flag_name = get_flag_name(_name)
	var config_value = OS.get_environment(env_var_name)
	var steam_name = get_steam_flag_name(_name)
	
	var args = get_arguments()
	if args.has(flag_name):
		return args[flag_name]
	if args.has(steam_name):
		return args[steam_name]
	if config_value != "":
		return config_value
	return default

static func get_int(_name,default=0) -> int:
	return int(get_var(_name,default))
	
static func get_bool(_name,default=false) -> bool:
	var v = get_var(_name,default).to_lower()
	match v:
		"yes","true","t","1":
			return true
		_:
			return false
	#return false

static func get_custom_var(_name,type,default=null):
	match type:
		TYPE_ARRAY:
			return get_var(_name,default).split(",")
		TYPE_BOOL:
			return get_bool(_name,default)
		TYPE_DICTIONARY:
			return JSON.parse_string(get_var(_name,default))
		TYPE_INT:
			return get_int(_name,default)
		TYPE_MAX:
			pass
		TYPE_NIL:
			return default
		TYPE_RECT2:
			pass
		TYPE_RID:
			pass
		TYPE_STRING:
			return get_var(_name,default)
		TYPE_TRANSFORM2D:
			pass
		TYPE_VECTOR2:
			pass
		TYPE_VECTOR3:
			pass
	return default
