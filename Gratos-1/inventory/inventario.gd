extends Node2D

var items = ["sword"]

# Called when the node enters the scene tree for the first time.
@export var item_scene : PackedScene
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_time_timeout() -> void:
	$Warning.text = ""
	$Warning.queue_redraw()
