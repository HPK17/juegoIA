extends Node2D

@export var tutorial : Label
@export var audio : AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	audio.play()
	hideTuto()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event.is_action_pressed("rage_quit"):  # "ui_cancel" es ESC en Godot por defecto
		get_tree().quit()

func hideTuto() -> void:
	await get_tree().create_timer(4.0).timeout
	tutorial.visible = false
