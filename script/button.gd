extends VBoxContainer

@export var pregunta_label: Label
@export var botones_respuesta: Array[Button]  # Array de botones asignados en el editor

# Lista de preguntas con sus respectivas respuestas y la posición de la correcta
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

func _ready():
	reiniciar_preguntas()  # Copia las preguntas originales a preguntas_disponibles
	seleccionar_pregunta()  # Escoge la primera pregunta

func reiniciar_preguntas():
	preguntas_disponibles = preguntas_respuestas.duplicate()  # Duplica la lista de preguntas

func seleccionar_pregunta():
	if preguntas_disponibles.is_empty():
		pregunta_label.text = "¡Ya no hay más preguntas!"
		
		# Vacía y deshabilita los botones
		for boton in botones_respuesta:
			boton.text = ""
			boton.disabled = true
		return

	var indice = randi_range(0, preguntas_disponibles.size() - 1)
	var pregunta_seleccionada = preguntas_disponibles[indice]

	# Mostrar la pregunta en la Label
	pregunta_label.text = pregunta_seleccionada["pregunta"]
	var opciones = pregunta_seleccionada["respuestas"]
	respuesta_correcta = pregunta_seleccionada["correcta"]  # Guarda la respuesta correcta

	# Asignar respuestas a los botones
	for i in range(botones_respuesta.size()):
		# Desconectar señales anteriores para evitar múltiples conexiones
		if botones_respuesta[i].is_connected("pressed", funcion_boton):
			botones_respuesta[i].disconnect("pressed", funcion_boton)
		
		if i < opciones.size():
			botones_respuesta[i].text = opciones[i]  # Poner texto de respuesta
			botones_respuesta[i].disabled = false  # Habilitar botón
			# Conectar el botón a la función de validación, enviando el índice como parámetro
			botones_respuesta[i].pressed.connect(funcion_boton.bind(i))
		else:
			botones_respuesta[i].text = ""  # Si hay más botones que respuestas, vaciarlos
			botones_respuesta[i].disabled = true  # Deshabilitarlos

	preguntas_disponibles.remove_at(indice)  # Elimina la pregunta seleccionada

func funcion_boton(indice_boton: int):
	if indice_boton == respuesta_correcta:
		print("✅ Respuesta Correcta")
	else:
		print("❌ Respuesta Incorrecta")

	seleccionar_pregunta()  # Seleccionar la siguiente pregunta automáticamente
