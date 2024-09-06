@tool
extends EditorPlugin
class_name BlessPlugin

static func create_project_uuid():
	var path_hash = RandomNumberGenerator.new()
	path_hash.seed = hash(BlessUtility.get_project_path_absolute())
	
	var uuid = UUID.new(path_hash)
	# example_uuid = "049b1743-eaf9-419d-aa7e-e23864dfdc4e"
	ProjectSettings.set("bless/project_uuid", uuid.as_string())
	var property_info = {
		"name": "bless/project_uuid",
		"type": TYPE_STRING,
	}

	ProjectSettings.add_property_info(property_info)
	ProjectSettings.save()

func add_permanent_project_uuid():
	if ProjectSettings.has_setting("bless/project_uuid"):
		## if we have a UUID already, don't make a new one.
		pass
	else:
		create_project_uuid()


func _enter_tree():
	add_permanent_project_uuid()


func _exit_tree():
	# Clean-up of the plugin goes here.
	## we dont clean up the path hash/ UUID... try and keep hold of it!
	pass
