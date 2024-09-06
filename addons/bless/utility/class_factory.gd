# by CptChuckles

## converts string into class object
class_name ClassFactory extends RefCounted

static var _factories := {}

static var _source_template := """
extends RefCounted
func create_instance() -> {class}:
	return {class}.new()
"""

## use this to create dynamic classes.
static func create(new_class: String):
	if new_class in _factories:
		return _factories[new_class].create_instance()

	var factory_gd = GDScript.new()
	factory_gd.source_code = _source_template.format({"class": new_class})
	var compile_result = factory_gd.reload()
	assert(compile_result == OK, factory_gd.source_code)

	var factory := RefCounted.new()
	factory.set_script(factory_gd)

	_factories[new_class] = factory

	return factory.create_instance()
