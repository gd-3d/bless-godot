extends Node3D
class_name Chicken

@export_category("entity stuff")
@export var target : Node3D
@export var speed :float= 20.0
@export var eggs : int = 20


@export_group("internal vars")
var _something := 0
var _words = "hello world"
