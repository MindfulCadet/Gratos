extends CharacterBody2D

#Variables que se mostraran en el inspector del nodo correspondiente
#al personaje
#@export_category("Player settings")
#@export_enum("caballero","mago", "arquero","barbaro") var clase = "mago"
#@export var nivel:int = 1
#@export var attacks : Array[Resource] 

@onready var camera = $Camera2D

var mov_speed = 150
var distance_traveled = mov_speed/2 
var character = Resource #Referencia al nodo correspondiente al nivel, clase y ataques del personaje
var stats = Resource #Referencia al nodo correspondiente a lso stats

#Con esta variable, se calcula el movimiento total en pixeles
#y en el mapa, para la aparicion de enemigos
var step_pixel : float = 0.0:
	set(value):
		step_pixel = value
		var step = step_pixel/distance_traveled

		if step >= Manager.encounter:
			set_physics_process(false)
			Manager.save_data(self)
			$Stats.visible = false
			$inventario.visible = false
			camera.enabled = false
			Manager.change_to_battle()

			step = 0
			
		
func _ready():
	
	#Añade el sprite correspondiente a la clase, y coloca al
	#jugador en la posición correspondiente (e instancia los stats)
	character_sprite()
	position = Manager.player_last_position
	add_child(character)
	stats = load("res://stats/stats.tscn").instantiate()
	add_child(stats)
	character.play("Idle")
	
	#Se guardan las skills en un script global
	PlayerHandle.players[multiplayer.get_unique_id()].skills = character.attacks.duplicate()
	set_multiplayer_authority(name.to_int())


func _physics_process(delta):
	var initial = position

	if is_multiplayer_authority() and is_physics_processing():
		$Stats.visible = true
		$inventario.visible = true # Esto es para que el inventario solo sea visible por el propietario

		var direction = Input.get_vector("ui_left","ui_right", "ui_up", "ui_down")
		if direction:
			character.play("Walk")
			
			if direction.x > 0:
				character.flip_h = false
					
			elif direction.x < 0:
				character.flip_h = true
		
		else:
			character.play("Idle")
			
		velocity = direction * mov_speed
		
		move_and_slide()
		step_pixel += position.distance_to(initial) #Suma los pixeles movidos
		
	else: 
		$Stats.visible = false
		$inventario.visible = false# Aqui se oculta para que los otros players no lo vean
		camera.enabled = false


#Coloca en personaje en el mapa, correspondiente al seleccionado
#en el menú de selección (guarda toda la información en un script global)
func character_sprite():
	match PlayerHandle.players[multiplayer.get_unique_id()].character:
		"caballero":
			character = load("res://Characters/PLayable characters/Scenes/Knight.tscn").instantiate()
			
		"arquero":
			character = load("res://Characters/PLayable characters/Scenes/Archer.tscn").instantiate()
			
		"barbaro":
			character = load("res://Characters/PLayable characters/Scenes/Barbarian.tscn").instantiate()
			
		"mago":
			character = load("res://Characters/PLayable characters/Scenes/Wizard.tscn").instantiate()

		
