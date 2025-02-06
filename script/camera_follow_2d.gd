extends Camera2D

@export var target: CharacterBody2D = null  # Referencia al personaje
@export var smoothing: float = 5.0  # Velocidad de suavizado
@export var limit_enabled: bool = false  # Si se deben aplicar límites
@export var limit_rect: Rect2 = Rect2(0, 0, 1024, 768)  # Área límite opcional

func _ready():
	# Habilitar el modo de suavizado de la cámara
	position_smoothing_enabled = true

func _process(delta: float):
	if target:
		var target_position = target.global_position
		# Interpolación suave
		position = position.lerp(target_position, 1.0 - exp(-smoothing * delta))
		
		# Aplicar límites si están activados
		if limit_enabled:
			position.x = clamp(position.x, limit_rect.position.x, limit_rect.end.x)
			position.y = clamp(position.y, limit_rect.position.y, limit_rect.end.y)
