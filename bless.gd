@tool  # Important to make it work in the editor
class_name Bless

static func export_profile_to_json(profile_path: String, output_path: String) -> void:
	print("Starting export...") # Debug print
	var profile = load(profile_path) as Resource
	if not profile:
		push_error("Failed to load profile from: " + profile_path)
		return
		
	print("Profile loaded successfully") # Debug print
	var project_root = BlessUtility.get_project_path_absolute()
	
	# Create dictionary from profile data with full file paths
	var profile_data = {
		"game": profile.game,
		"game_engine": profile.game_engine,
		"classes": profile.classes,
		"scenes": profile.scenes,
		"audio_music": [],
		"audio_sfx": [],
		"textures": [],
		"materials": []
	}
	
	# Get all files from the music directories
	for dir in profile.audio_music:
		var files = BlessUtility.get_files_in_directory(dir, profile.audio_types)
		profile_data.audio_music.append_array(files.map(func(p): 
			return BlessUtility.convert_to_absolute_path(p, project_root)
		))
	
	# Get all files from the sfx directories
	for dir in profile.audio_sfx:
		var files = BlessUtility.get_files_in_directory(dir, profile.audio_types)
		profile_data.audio_sfx.append_array(files.map(func(p): 
			return BlessUtility.convert_to_absolute_path(p, project_root)
		))
	
	# Get all files from the texture directories
	for dir in profile.textures:
		var files = BlessUtility.get_files_in_directory(dir, profile.texture_types)
		profile_data.textures.append_array(files.map(func(p): 
			return BlessUtility.convert_to_absolute_path(p, project_root)
		))
	
	# Get all files from the material directories
	for dir in profile.materials:
		var files = BlessUtility.get_files_in_directory(dir, profile.material_types)
		profile_data.materials.append_array(files.map(func(p): 
			return BlessUtility.convert_to_absolute_path(p, project_root)
		))
	
	print("Storing JSON to: " + output_path) # Debug print
	# Store the dictionary as JSON
	BlessUtility.store_json(profile_data, output_path)
	print("Export completed!") # Debug print