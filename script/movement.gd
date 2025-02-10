class_name PlayerController
extends CharacterBody2D

@export var speed = 400;

func _ready() -> void:
	restaurar_pos()

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
func guardar_pos():
	Global.player_pos = global_position

func restaurar_pos():
	if Global.player_pos != Vector2.ZERO:
		global_position = Global.player_pos
	

func _physics_process(delta):
	get_input()
	move_and_slide()
