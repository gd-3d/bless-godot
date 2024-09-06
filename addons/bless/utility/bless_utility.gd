class_name BlessUtility

static func store_json(data : Dictionary, path : String):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data, "\t", false, true)) ## what is full_precision?


static func get_project_path_absolute():
	return ProjectSettings.globalize_path("res://")
