extends Control
class_name GameUI

@onready var _coin_bar_euro : CoinBarEuro = $CoinBarPanel/CoinBarEuro
@onready var _coin_bar_cent : CoinBarEuro = $CoinBarCent/CoinBarCent
@onready var _coin_label : Label = $CoinLabel
@export var _detection_zone : DetectionZone

@export var goal_value : float = 20.0
@export var object_value : float = 10.0

@export var param_base_pos : Vector2 = Vector2(-200, 200)
@export var param_open_pos : Vector2 = Vector2(10, 200)

@export var trans_type: Tween.TransitionType = Tween.TRANS_BACK
@export var ease_type : Tween.EaseType = Tween.EASE_OUT
@export var animation_duration: float = 0.6
var _is_open: bool
var _tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_bar()
	_coin_label.text = "%.2f€ / %.2f€" % [object_value, goal_value]

func update_bar() -> void:
	var sum = object_value + goal_value
	var remainder = sum - int(sum)
	var unscrambled: bool = is_zero_approx(fmod(object_value, 1.0)) != is_zero_approx(fmod(goal_value, 1.0))
	if remainder == 0:
		$CoinBarCent.scale = Vector2(0, 0)
		_coin_bar_euro.setup(int(goal_value), int(object_value), $CoinBarPanel.size.x - 5)
	else :
		$CoinBarCent.scale = Vector2(1, 1)
		_coin_bar_cent.setup(1, remainder, $CoinBarPanel.size.x - 5)
		_coin_bar_cent.update_coin_stack()
		_coin_bar_euro.setup(int(goal_value) - int(unscrambled), int(object_value), $CoinBarPanel.size.x - 5)
	_coin_bar_euro.update_coin_stack()

func _on_detection_zone_update_coins() -> void:
	_coin_bar_euro.clear_coin()
	_coin_bar_cent.clear_coin()
	for coin in _detection_zone.coins_inside:
		if MoneyType.get_monetary_value(coin.value) >= 1:
			_coin_bar_euro.add_coin(coin.value)
		else:
			_coin_bar_cent.add_coin(coin.value)
	_coin_label.text = "%.2f€ / %.2f€" % [_detection_zone.value + object_value, goal_value]

func button_setting_pressed():
	print("Setting button pressed")
	if !_is_open:
		open_settings()
		_is_open = true
	else:
		close_settings()
		_is_open = false

func open_settings() -> void:
	print("Setting Open")
	var target = $Settings
	
	if _tween and _tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_trans(trans_type)
	_tween.set_ease(ease_type)
	_tween.tween_property(target, "position", param_open_pos, animation_duration)
	
func close_settings() -> void:
	print("Setting Closed")
	var target = $Settings
	
	if _tween and _tween.is_running():
		_tween.kill()
	
	_tween = create_tween()
	_tween.set_trans(trans_type)
	_tween.set_ease(ease_type)
	_tween.tween_property(target, "position", param_base_pos, animation_duration)
	object_value = float($Settings/VBoxContainer/Prix.text)
	goal_value = float($Settings/VBoxContainer/BilletDonne.text)
	update_bar()	
	_on_detection_zone_update_coins()
