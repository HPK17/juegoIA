extends StaticBody2D

@export var label : Label
@export var new_scene : String = "res://scenes/ui_quiz.tscn"
@export var player : PlayerController

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false
	$Ui_quiz.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is PlayerController) :
		print("Guapeton")
		label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body is PlayerController):
		print("Jugador fuera")
		label.visible = false
		$Ui_quiz.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_interract") :
		if player:
			player.guardar_pos()
		_cambiar_escena()
		print("Interacuando")

func _cambiar_escena() -> void:
		if ResourceLoader.exists(new_scene):
			get_tree().change_scene_to_file(new_scene)
		else:
			print("efe")
