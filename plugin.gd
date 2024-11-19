@tool
extends EditorPlugin

var dock: Control

func _enter_tree() -> void:
	# Create the dock
	dock = preload("res://addons/bless-godot/dock/bless_dock.tscn").instantiate()
	# Add the dock to the editor
	add_control_to_dock(DOCK_SLOT_RIGHT_UL, dock)

func _exit_tree() -> void:
	# Clean-up of the plugin goes here
	remove_control_from_docks(dock)
	dock.free()
