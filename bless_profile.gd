class_name BlessProfile
extends Resource 

@export_category("Game")
@export var game = ""
@export var game_engine = "Godot Engine"
#@export var game_version = Engine.get_version_info()

@export_category("Game Objects")
@export var classes : Array[GDScript] # or Script
@export var scenes : Array[PackedScene] # or Script

@export_category("Resource Directories")
@export_group("Audio")
@export_dir var audio_music: Array[String]
@export_dir var audio_sfx: Array[String]
@export var audio_types : Array[String] = ["mp3", "wav", "ogg"]
@export_group("Textures")
@export_dir var textures: Array[String]
@export var texture_types : Array[String] = ["png", "jpg", "jpeg", "bmp", "tga", "webp"]
@export_group("Materials")
@export_dir var materials: Array[String]
@export var material_types : Array[String] = ["tres"]
