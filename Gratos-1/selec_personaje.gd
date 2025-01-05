extends Control

@onready var animacion = $AnimationPlayer
@onready var texto = $Label
var personajes = PlayerHandle.characters

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Maps/Test_map.tscn")

#Si se presiona el personaje se oculta el texto previo
#e inicia la animación para confirmar la selección
func _on_personaje_1_pressed():
	texto.hide()
	animacion.play("selection1")
	

func _on_personaje_2_pressed():
	texto.hide()
	animacion.play("selection2")

func _on_personaje_3_pressed():
	texto.hide()
	animacion.play("selection3")

#Detiene la animación de confirmación y llama a la funcion de deshabilitar
#los personajes seleccionados
func _on_si_pressed():
	if animacion.get_current_animation() == "selection1":
		animacion.stop()
		deshabilitar.rpc(1)
	elif animacion.get_current_animation() == "selection2":
		animacion.stop()
		deshabilitar.rpc(2)
	elif animacion.get_current_animation() == "selection3":
		animacion.stop()
		deshabilitar.rpc(3)

#Detiene la animación de confirmación para poder seleccionar otro personaje
func _on_no_pressed():
	animacion.stop()


#deshabilita los personajes seleccionados y
#añade a una lista los personajes seleccionados
@rpc("any_peer", "call_local")
func deshabilitar(nro):
	if nro == 1:
		$Personaje1.disabled = true
		personajes.append("Personaje1")
		revision()
	elif nro == 2:
		$Personaje2.disabled = true
		personajes.append("Personaje2")
		revision()
	elif nro == 3:
		$Personaje3.disabled = true
		personajes.append("Personaje3")
		revision()


#revisa la lista para verificar que ambos jugadores hayan escogido personaje
#si se cumple, avanza y muestra el juego
func revision():
	if "Personaje1" and "Personaje2" in personajes or "Personaje1" and "Personaje3" in personajes or "Personaje2" and "Personaje3" in personajes:
		var game = load("res://Maps/Test_map.tscn").instantiate()
		get_tree().root.add_child(game)
		$".".visible = false
