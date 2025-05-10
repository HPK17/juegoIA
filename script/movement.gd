class_name PlayerController
extends CharacterBody2D

@export var speed: float = 400
@export var animation: AnimationPlayer
@export var characterSprite: Sprite2D

func _ready() -> void:
	animation.play("idle")
	restaurar_pos()

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	
	# ✅ Solo cambiar la animación si hay movimiento
	if input_direction != Vector2.ZERO:
		if animation.current_animation != "walk_right":  # Evita reiniciar la animación cada frame
			animation.play("walk_right")

		# ✅ Voltear el personaje según la dirección
		if input_direction.x > 0:
			characterSprite.flip_h = false  # Derecha
		elif input_direction.x < 0:
			characterSprite.flip_h = true   # Izquierda
	else:
		# ✅ Si no hay movimiento, reproducir idle (solo si no está ya en idle)
		if animation.current_animation != "idle":
			animation.play("idle")

func _input(event):
	# ✅ Detecta cuando se suelta cualquier tecla de movimiento
	if event.is_action_released("ui_left") or event.is_action_released("ui_right") or event.is_action_released("ui_up") or event.is_action_released("ui_down"):
		if animation.current_animation != "idle":  # Evita reiniciar innecesariamente
			animation.play("idle")

func guardar_pos():
	Global.player_pos = global_position

func restaurar_pos():
	if Global.player_pos != Vector2.ZERO:
		global_position = Global.player_pos

func _physics_process(delta):
	get_input()
	move_and_slide()
