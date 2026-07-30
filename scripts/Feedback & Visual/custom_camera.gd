extends Camera2D

@export var offset_scale := 0.1

func _ready() -> void:
	zoom = Vector2(1 + offset_scale, 1 + offset_scale)


func _process(_delta: float) -> void:
	var cursor_pos = get_global_mouse_position() - position # La position de la souris par rapport à la caméra
	offset = cursor_pos * offset_scale
