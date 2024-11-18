class_name BlessUtility

static func get_files_in_directory(path: String, extensions: Array[String] = []) -> Array[String]:
	var files: Array[String] = []
	var dir = DirAccess.open(path)
	
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		
		while file_name != "":
			if dir.current_is_dir():
				# Recursively search subdirectories
				var sub_path = path.path_join(file_name)
				files.append_array(get_files_in_directory(sub_path, extensions))
			else:
				# Check if file matches any of the desired extensions
				var file_path = path.path_join(file_name)
				if extensions.is_empty() or extensions.has(file_path.get_extension()):
					files.append(file_path)
			
			file_name = dir.get_next()
			
		dir.list_dir_end()
	
	return files

static func store_json(data : Dictionary, path : String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t", false, true)) ## what is full_precision?

static func get_project_path_absolute():
	return ProjectSettings.globalize_path("res://")

static func convert_to_absolute_path(resource_path: String, project_root: String) -> String:
	if resource_path.begins_with("res://"):
		return project_root.path_join(resource_path.substr(6))
	return resource_path
