extends Node

var data = {}

func _ready():
	# Get properties of Node and Node3D
	var node_properties = get_class_properties("Node")
	var node3d_properties = get_class_properties("Node3D")
	
	for class_object in ClassDB.get_inheriters_from_class("Node3D"):
		if ClassDB.can_instantiate(class_object):
			var node = ClassFactory.create(class_object) as Node3D
			
			# Initialize the class entry with an empty dictionary
			data[class_object] = {}
			
			# Iterate over the properties of the node
			for property in node.get_property_list():
				var property_name = property["name"]
				
				# Skip properties inherited from Node or Node3D
				if property_name in node_properties or property_name in node3d_properties:
					continue
				
				# Add the property if it's specific to the class
				data[class_object][property_name] = {}
				
				# Copy all keys and their corresponding values
				for key in property.keys():
					data[class_object][property_name][key] = property[key]
	
	# Convert the dictionary to a JSON string and store it
	BlessUtility.store_json(data, "res://engine_defintion.json")
# Function to get a list of properties for a given class name
func get_class_properties(class_object: String) -> Array:
	var node = ClassFactory.create(class_object)
	var properties = []
	for property in node.get_property_list():
		properties.append(property["name"])
	return properties
