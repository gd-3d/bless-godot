@tool  # Important to make it work in the editor
class_name Bless

const PROPERTY_USAGE_DEFAULT = 1

static func analyze_script_properties(script: GDScript) -> Dictionary:
	print("Analyzing script: ", script.get_global_name())  # Debug print
	
	var script_data = {
		"name": script.get_global_name(),
		"is_tool": script.is_tool(),
		"is_base_script": script.get_base_script() == null,
		"properties": []
	}
	
	# Get properties directly from script
	var property_list = script.get_script_property_list()
	print("Direct property list length: ", property_list.size())  # Debug print
	
	for property in property_list:
		var usage = property.usage
		print("Property: ", property.name, " Usage: ", usage)  # Debug print
		
		# Check for exported properties (usage will be 4102 for exported properties)
		if usage == 4102:  # This is the exact value for exported properties
			var property_name = property.name
			var property_hint = property.hint_string
			var property_type = type_string(property.type)  # Use the property's type directly
			
			print("Adding exported property: ", property_name, " Type: ", property_type)  # Debug print
			
			# For default values, we'll use null since we can't get the actual defaults without instantiation
			script_data.properties.append({
				"name": property_name,
				"type": property_type,
				"hint": property_hint,
				"default": null
			})
	
	print("Final properties count: ", script_data.properties.size())  # Debug print
	return script_data

static func read_scripts_from_profile(profile: BlessProfile) -> Dictionary:
	var classes = {}
	
	for script in profile.classes:
		if script:
			var script_data = analyze_script_properties(script)
			var cls_name = script.get_global_name()
			print("Processing class: ", cls_name)  # Debug print
			print("Found properties: ", script_data.properties.size())  # Debug print
			classes[cls_name] = script_data
	
	return classes

static func export_profile_to_json(profile_path: String, output_path: String) -> void:
	print("Starting export...") # Debug print
	var profile = load(profile_path) as BlessProfile
	if not profile:
		push_error("Failed to load profile from: " + profile_path)
		return
		
	print("Profile loaded successfully") # Debug print
	var project_root = BlessUtility.get_project_path_absolute()
	
	# Create dictionary from profile data with full file paths
	var profile_data = {
		"game": profile.game,
		"game_engine": profile.game_engine,
		"classes": read_scripts_from_profile(profile),
		"scenes": profile.scenes,
		"audio_music": [],
		"audio_sfx": [],
		"textures": [],
		"materials": []
	}
	
	# Get all files from the music directories
	for dir in profile.audio_music:
		var files = BlessUtility.get_files_in_directory(dir, profile.audio_types)
		profile_data.audio_music.append_array(files.map(func(x): return BlessUtility.convert_to_absolute_path(x, project_root)))
	
	# Get all files from the sfx directories
	for dir in profile.audio_sfx:
		var files = BlessUtility.get_files_in_directory(dir, profile.audio_types)
		profile_data.audio_sfx.append_array(files.map(func(x): return BlessUtility.convert_to_absolute_path(x, project_root)))
	
	# Get all files from the texture directories
	for dir in profile.textures:
		var files = BlessUtility.get_files_in_directory(dir, profile.texture_types)
		profile_data.textures.append_array(files.map(func(x): return BlessUtility.convert_to_absolute_path(x, project_root)))
	
	# Get all files from the material directories
	for dir in profile.materials:
		var files = BlessUtility.get_files_in_directory(dir, profile.material_types)
		profile_data.materials.append_array(files.map(func(x): return BlessUtility.convert_to_absolute_path(x, project_root)))
	
	print("Storing JSON to: " + output_path) # Debug print
	# Store the dictionary as JSON
	BlessUtility.store_json(profile_data, output_path)
	print("Export completed!") # Debug print
