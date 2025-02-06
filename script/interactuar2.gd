extends StaticBody2D

@export var label : Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if (body is PlayerController) :
		print("Guapeton")
		label.visible = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if (body is PlayerController):
		print("Jugador fuera")
		label.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_interract") :
		print("Interacuando")
