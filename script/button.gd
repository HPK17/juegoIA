extends HBoxContainer

@export var pregunta_label: Label
@export var contador_Aciertos: Label
@export var botones_respuesta: Array[Button]
@export var boton_salida: Button
@export var level_scene: String = "res://level.tscn"
@export var vidas_label: Label  # Muestra cuántas vidas quedan
@export var victoria_label: Label  # Muestra cuántas victorias lleva el jugador

var preguntas_respuestas: Array = [
	{"pregunta": "¿Cuál es la capital de Francia?", 
	"respuestas": ["Madrid", "París", "Londres", "Berlín"],
	 "correcta": 1},
	{"pregunta": "¿Cuántos planetas hay en el sistema solar?",
	 "respuestas": ["7", "8", "9", "6"],
	 "correcta": 1},
	{"pregunta": "¿Quién escribió 'Don Quijote de la Mancha'?",
	 "respuestas": ["Miguel de Cervantes", "Pablo Neruda", "Gabriel García Márquez", "William Shakespeare"],
	 "correcta": 0},
	{"pregunta": "¿En qué año llegó el hombre a la Luna?",
	 "respuestas": ["1969", "1975", "1950", "1982"], 
	"correcta": 0},
	{"pregunta": "¿Cuál es el metal más abundante en la corteza terrestre?",
	 "respuestas": ["Hierro", "Oro", "Aluminio", "Plata"], 
	"correcta": 2}
]

var preguntas_disponibles: Array = []  # Lista de preguntas sin usar
var respuesta_correcta: int = -1  # Índice de la respuesta correcta
var aciertos: int = 0
var fallos: int = 0
var vidas: int = 2  # El jugador comienza con 2 vidas
var victorias: int = 0  # Contador de victorias

func _ready():
	victoria_label.visible = false  # Ocultar contador de victorias al inicio
	#mensaje_victoria.visible = false  # Ocultar mensaje de victoria al inicio
	reiniciar_preguntas()
	seleccionar_pregunta()
	boton_salida.visible = false  # Ocultar el botón de salida al inicio
	actualizar_contador()
	actualizar_vidas()
	actualizar_victorias()

func reiniciar_preguntas():
	preguntas_disponibles = preguntas_respuestas.duplicate()

func seleccionar_pregunta():
	if preguntas_disponibles.is_empty():
		mostrar_final()
		return

	var indice = randi_range(0, preguntas_disponibles.size() - 1)
	var pregunta_seleccionada = preguntas_disponibles[indice]

	pregunta_label.text = pregunta_seleccionada["pregunta"]
	var opciones = pregunta_seleccionada["respuestas"]
	respuesta_correcta = pregunta_seleccionada["correcta"]

	# Asignar respuestas a los botones
	for i in range(botones_respuesta.size()):
		if botones_respuesta[i].is_connected("pressed", funcion_boton):
			botones_respuesta[i].disconnect("pressed", funcion_boton)
		
		if i < opciones.size():
			botones_respuesta[i].text = opciones[i]
			botones_respuesta[i].disabled = false
			botones_respuesta[i].pressed.connect(funcion_boton.bind(i))
		else:
			botones_respuesta[i].text = ""
			botones_respuesta[i].disabled = true

	preguntas_disponibles.remove_at(indice)  

func funcion_boton(indice_boton: int):
	if indice_boton == respuesta_correcta:
		print("✅ Respuesta Correcta")
		aciertos += 1
	else:
		print("❌ Respuesta Incorrecta")
		fallos += 1
		vidas -= 1
		actualizar_vidas()
	
	# Si las vidas llegan a 0, reinicia el quiz
	if vidas <= 0:
		pregunta_label.text = "¡Te has quedado sin vidas! Reiniciando..."
		await get_tree().create_timer(2.0).timeout
		reiniciar_juego()
		return


	# Deshabilitar todos los botones tras responder
	for boton in botones_respuesta:
		boton.disabled = true

	actualizar_contador()

	# Esperar 1 segundo antes de cambiar de pregunta
	await get_tree().create_timer(1.0).timeout
	seleccionar_pregunta()  

func actualizar_contador():
	contador_Aciertos.text = "Aciertos: %d/5" % aciertos

func actualizar_vidas():
	vidas_label.text = "Vidas: %d" % vidas

func actualizar_victorias():
	victoria_label.text = "Victorias: %d" % victorias

func mostrar_final():
	if fallos > 0:
		vidas -= 1  # Resta una vida si el jugador falló alguna pregunta
		actualizar_vidas()

	if vidas <= 0:
		pregunta_label.text = "¡Te has quedado sin vidas! Reiniciando el quiz..."
		await get_tree().create_timer(2.0).timeout
		reiniciar_juego()
		return

	if aciertos == 5:
		victorias += 1  # Aumenta el contador de victorias
		actualizar_victorias()
		victoria_label.visible = true
		if victorias >= 3:
			pregunta_label.text = "🎉 FELICIDADES! HAS GANADO! 🎉"
			boton_salida.visible = true
			return  # No reinicia el quiz, solo muestra el mensaje final
		else:
			pregunta_label.text = "¡Has acertado todo! +1 Victoria 🏆"

	else:
		pregunta_label.text = "Oooh no, has fallado %d preguntas" % fallos

	# Ocultar botones de respuesta
	for boton in botones_respuesta:
		boton.visible = false

	boton_salida.visible = true  # Mostrar el botón de salida

func reiniciar_juego():
	aciertos = 0
	fallos = 0
	vidas = 2
	victorias = 0
	actualizar_contador()
	actualizar_vidas()
	actualizar_victorias()
	reiniciar_preguntas()
	seleccionar_pregunta()

func _on_button_pressed() -> void:
	if ResourceLoader.exists(level_scene):  
		get_tree().change_scene_to_file(level_scene)
	else:
		print("cagaste")
