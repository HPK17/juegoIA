extends Control

@export var pregunta_label: Label
@export var contador_Aciertos: Label
@export var botones_respuesta: Array[Button]
@export var boton_salida: Button
@export var level_scene: String = "res://level.tscn"
@export var vidas_label: Label  # Muestra cuántas vidas quedan
@export var victoria_label: Label  # Muestra cuántas victorias lleva el jugador

var preguntas_respuestas: Array = [
	{"pregunta": "¿Cuál es una característica principal de la Inteligencia Artificial estrecha (IA)?", 
	"respuestas": ["Su capacidad para adaptarse a cualquier tarea.", "Su habilidad para llevar a cabo tareas específicas o limitadas.", "Su capacidad para superar la inteligencia humana.", "Su capacidad para aprender nuevas habilidades sin intervención humana."],
	 "correcta": 1},
	{ "pregunta": "¿Qué se entiende por Inteligencia Artificial General (IAG)?", 
	"respuestas": ["Una IA que solo puede realizar tareas muy específicas.", "Una IA que supera a la inteligencia humana en todo.", "Una IA que tiene la capacidad de entender, aprender y aplicar conocimientos en una amplia variedad de tareas.", "Una IA que no requiere datos para aprender."],
	 "correcta": 2 },
	{ "pregunta": "¿Cuál es el nivel de desarrollo más alto alcanzado actualmente en la IA?",
	 "respuestas": ["La Inteligencia Artificial General (IAG).", "La Superinteligencia Artificial.", "La Inteligencia Artificial estrecha (IA).", "Todos los tipos están igual de desarrollados."],
	 "correcta": 2 },
	{ "pregunta": "¿Cuál es el primer paso en el proceso de minería de datos?",
	 "respuestas": ["La preparación de los datos.", "El modelado de los datos.", "La comprensión del negocio.", "La evaluación de los datos."],
	 "correcta": 2 },
	{ "pregunta": "¿Qué es un aspecto crítico en el tratamiento de datos para la IA?",
	 "respuestas": ["La velocidad de procesamiento de los datos.", "La privacidad y protección de los datos.", "La cantidad de datos recopilados.", "El costo de los datos."],
	 "correcta": 1 },
	{ "pregunta": "¿Qué tipo de análisis de datos se utiliza para identificar relaciones entre variables en grandes conjuntos de datos?", 
	"respuestas": ["Minería de datos descriptiva.", "Minería de datos predictiva.", "Minería de datos de reglas de asociación.", "Minería de datos de texto."],
	 "correcta": 2 },
	{ "pregunta": "¿Cómo contribuye la IA en la computación en la nube?", 
	"respuestas": ["Almacenando grandes cantidades de datos.", "Permitiendo el despliegue rápido y escalable de modelos de aprendizaje automático.", "Asegurando la integridad de las transacciones.", "Optimizando el consumo de energía."],
	 "correcta": 1 },
	{ "pregunta": "¿Qué permite la IA en la realidad aumentada (RA)?", 
	"respuestas": ["Crear entornos virtuales inmersivos.", "Mejorar la interacción con los entornos físicos.", "Reconocer objetos en aplicaciones de realidad aumentada.", "Simular escenarios complejos para la toma de decisiones."], 
	"correcta": 2 },
	{ "pregunta": "¿Cómo se utiliza la IA en el sector de la energía?",
	 "respuestas": ["Personalización de anuncios de marketing.", "Optimización de la producción energética y análisis de eficiencia.", "Segmentación de clientes para campañas.", "Análisis predictivo de presupuestos."],
	 "correcta": 1 },
	{ "pregunta": "¿Qué se busca con la aplicación de la IA en la blockchain?",
	 "respuestas": ["La optimización de la sincronización de semáforos.", "La mejora de la eficiencia en la producción agrícola.", "El análisis de transacciones para detectar actividades fraudulentas.", "La personalización de la experiencia del cliente."],
	 "correcta": 2 }
]

var preguntas_disponibles: Array = []  # Lista de preguntas sin usar
var respuesta_correcta: int = -1  # Índice de la respuesta correcta
var aciertos: int = 0
var fallos: int = 0
var vidas: int = 2  # El jugador comienza con 2 vidas
var victorias: int = 0  # Contador de victorias
var juego_finalizado: bool = false

func _ready():
	$Control/QuestionLabel.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
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
	if aciertos >= 5:
		mostrar_victoria()
		return

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
	
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # "ui_cancel" es ESC en Godot por defecto
		get_tree().change_scene_to_file(level_scene)


func _on_button_pressed() -> void:
	if ResourceLoader.exists(level_scene):  
		get_tree().change_scene_to_file(level_scene)
	else:
		print("cagaste")

func mostrar_victoria():
	juego_finalizado = true  # Detener el flujo del quiz
	victorias += 1
	victoria_label.visible = true
	pregunta_label.text = "🎉 ¡FELICIDADES! HAS GANADO 🎉"
	boton_salida.visible = true

	
	# Ocultar botones de respuesta
	for boton in botones_respuesta:
		boton.visible = false


func _on_exit_pressed() -> void:
	if ResourceLoader.exists(level_scene):  
		get_tree().change_scene_to_file(level_scene)
