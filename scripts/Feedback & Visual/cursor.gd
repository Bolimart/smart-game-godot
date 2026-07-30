extends Node2D

@export var tex_open_cursor : CompressedTexture2D
@export var tex_close_cursor : CompressedTexture2D

@onready var _cursor_sprite := $CursorSprite

var open := false:
	set(new_value):
		open = new_value
		_update_cursor()


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(_delta: float) -> void:
	position = get_global_mouse_position()


func _input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MouseButton.MOUSE_BUTTON_LEFT:
			open = not event.pressed


func _update_cursor() -> void:
	if open:
		_cursor_sprite.texture = tex_open_cursor
	else:
		_cursor_sprite.texture = tex_close_cursor
