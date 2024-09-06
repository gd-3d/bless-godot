class_name BlessProfile
extends Resource 

@export_category("Game")
@export var game = ""
@export var game_engine = "Godot Engine"
#@export var game_version = Engine.get_version_info()

@export_category("Objects")
@export var scripts : Array[GDScript] # or Script
@export var scenes : Array[PackedScene] # or Script

# hmmm
#@onready var game_path = OS.get_executable_path().get_base_dir()
