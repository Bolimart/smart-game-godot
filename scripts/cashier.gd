extends Node2D
class_name Cashier

@export var animation_duration: float = 1.4
@export var trans_type: Tween.TransitionType = Tween.TRANS_BACK
@export var ease_type : Tween.EaseType = Tween.EASE_OUT
@export var open_position : Vector2 = Vector2(0, 330)
@export var close_position : Vector2 = Vector2(0, 38)

@export var value: MoneyType.Denomination = MoneyType.Denomination.PIECE_1E
@export var coin_manager : CoinManager

var _open_button_hovered : bool = false
var is_open : bool = false
var _tween: Tween

func _ready() -> void:
	for child in $TiroirCaisse.get_children():
		print(child.get_class())
		if child is Area2D:
			child.set_coin_manager(coin_manager)
			child.cashier = self

func _mouse_enter() -> void:
	_open_button_hovered = true
	
func _mouse_exit() -> void:
	_open_button_hovered = false

func _input(event) -> void:
	if event is InputEventMouseButton:
		if _open_button_hovered and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			if is_open:
				close_cashier()
			else:
				open_cashier()

func open_cashier() -> void:
	var target = $TiroirCaisse
	
	if _tween and _tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_trans(trans_type)
	_tween.set_ease(ease_type)
	_tween.tween_property(target, "position", open_position, animation_duration)
	is_open = true
	
func close_cashier() -> void:
	var target = $TiroirCaisse
	
	if _tween and _tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_trans(trans_type)
	_tween.set_ease(ease_type)
	_tween.tween_property(target, "position", close_position, animation_duration)
	is_open = false
