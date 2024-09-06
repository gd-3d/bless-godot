## invoke from the terminal only.
#& "C:\dev\godot\godot.exe" --headless -s bless.gd export
## this exports a new definition file for the game + project

class_name Bless
extends SceneTree
var profile = preload("res://addons/bless/game_profile.tres") as BlessProfile
## does this still do anything with SceneTree ?

## TODO fix later.
const test_path = "res://addons/bless/export/game_definition.json"


var project_dir
var logger = Logger.new()




func _init():
	project_dir = DirAccess.open("res://")


var export = false

func _initialize():
	var args = OS.get_cmdline_args()
	# Trim unwanted args passed to godot executable
	## NOTE: "--key" or "-key" will always be consumed by godot executable, see https://github.com/godotengine/godot/issues/8721
	## idk what this is, but its in gd-plug. (thanks for the logger too!)
	for arg in Array(args):
		args.remove_at(0)
		if "bless.gd" in arg:
			break
	
	## godot.exe --headless -s bless.gd export << parse arguments
	for arg in args:
		var key = arg.to_lower()
		match key:
			"export":
				export = true
			#"other_arg":
				#something = true
			_:
				logger.indent()
				logger.info("incorrect")
				
		
	if export:
		logger.indent()
		logger.info("exporting...")
		logger.indent()
		
		var game_definition = {}
		
		#probably use ProjectSettings.get_setting("application/config/PROP")
		game_definition["game"] = {
			"name" : profile.game,
			"project_id" : ProjectSettings.get("bless/project_uuid"),
			"version" : ProjectSettings.get_setting("application/config/version"),
			"engine" : profile.game_engine, # i mean.. its Godot here. lol
			"engine_version" : Engine.get_version_info()["build"]
		}
		game_definition["classes"] = read_scripts_from_profile()
		#game_definition["scenes"] = read_scenes_from_profile()
		#game_definition["scripts"] = read_scenes_from_profile()
			
		BlessUtility.store_json(game_definition, test_path)



func map_custom_classes():
	var class_map = []
	for classification in ProjectSettings.get_global_class_list():
		class_map.append(classification)

func read_scripts_from_profile():
	var classes = {}

	for script_file in profile.scripts:
		var is_base_script = false
		if script_file.get_base_script() == null:
			is_base_script = true
		
		var is_tool = false
		if script_file.is_tool():
			is_tool = true
		
		get_class()
		var class_refrence = script_file.get_global_name()

		# Check if this class reference already exists in the classes dictionary
		if not classes.has(class_refrence):
			classes[class_refrence] = []

		# ok time to switch on the class factory and generate some code
		# MUST do this to get the default_value. 
		# already cursed so far so lets take it up a notch
		var fabricated_class = ClassFactory.create(class_refrence)
		
		for property in script_file.get_script_property_list():
			var property_name = property.name
			var property_hint = property.hint_string
			
			var default_value = fabricated_class.get(property_name)
			
			## TODO get the variables type in a string..
			var property_type = type_string(typeof(default_value))
			
			var usage = property.usage
			
			# thanks @Huh
			if usage & PROPERTY_USAGE_DEFAULT == PROPERTY_USAGE_DEFAULT:
				classes[class_refrence].append({
					"name": property_name,
					"type": property_type,
					"hint": property_hint,
					"default": default_value,
					
				})
				
				## or



	logger.info(ProjectSettings.globalize_path("res://"))
	logger.indent()
	logger.info("export completed.")
	return classes
