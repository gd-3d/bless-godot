@tool
extends Control

@onready var profile_path: LineEdit = $VBoxContainer/ProfilePath
@onready var output_path: LineEdit = $VBoxContainer/OutputPath

func _on_generate_pressed() -> void:
	if profile_path.text.is_empty() or output_path.text.is_empty():
		push_error("Profile path and output path must be specified")
		return
		
	Bless.export_profile_to_json(profile_path.text, output_path.text)
