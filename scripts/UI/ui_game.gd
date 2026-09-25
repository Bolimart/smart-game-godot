extends Control
class_name GameUI

@onready var _coin_bar_euro : CoinBarEuro = $CoinBarPanel/CoinBarEuro
@onready var _coin_bar_cent : CoinBarEuro = $CoinBarCent/CoinBarCent
@onready var _coin_label : Label = $CoinLabel
@export var _detection_zone : DetectionZone
@export var _coin_manager : CoinManager
@export var _trash_button : Button
var last_coins_inside : Array = []

@export var goal_value : float = 20.0
@export var object_value : float = 10.0

@export var param_base_pos : Vector2 = Vector2(-200, 200)
@export var param_open_pos : Vector2 = Vector2(10, 200)

signal on_victory()

func _on_victory() -> void:
	on_victory.emit()
	$VictoryAnimation.play("Bravo")

func trash_button_clicked() -> void:
	_coin_manager.clear_coin()
	_coin_bar_cent.clear_coin()
	_coin_bar_euro.clear_coin()
	$TrashSound.play()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_bar()
	_coin_label.text = "%.2f€ / %.2f€" % [object_value, goal_value]
	_trash_button.pressed.connect(trash_button_clicked.bind())

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
		_coin_bar_euro.setup(int(goal_value) - int(unscrambled), int(object_value), $CoinBarPanel.size.x - 5)

func _on_detection_zone_update_coins() -> void:
	_coin_bar_euro.clear_coin()
	_coin_bar_cent.clear_coin()
	
	for coin in _detection_zone.coins_inside:
		var is_new_coin: bool = not last_coins_inside.has(coin)
		var coin_value: float = MoneyType.get_monetary_value(coin.value)
		
		if coin_value >= 1.0:
			var was_filled: bool = _coin_bar_euro.total == _coin_bar_euro._goal_value
			_coin_bar_euro.add_coin(coin.value)
			var is_now_filled: bool = is_equal_approx(_coin_bar_euro.total, _coin_bar_euro._goal_value)
			var is_now_overflow: bool = _coin_bar_euro.total > _coin_bar_euro._goal_value + _coin_bar_euro.EPSILON
			if is_new_coin and not was_filled:
				if is_now_filled:
					$BarFilledAudio.play()
				elif is_now_overflow:
					$BarOverflow.play()
		else:
			var was_filled: bool = _coin_bar_cent.total == _coin_bar_cent._goal_value
			_coin_bar_cent.add_coin(coin.value)
			var is_now_filled: bool = is_equal_approx(_coin_bar_cent.total, _coin_bar_cent._goal_value)
			var is_now_overflow: bool = _coin_bar_cent.total > _coin_bar_cent._goal_value + _coin_bar_cent.EPSILON
			if is_new_coin and not was_filled:
				if is_now_filled:
					$BarFilledAudio.play()
				elif is_now_overflow:
					$BarOverflow.play()
	
	_coin_label.text = "%.2f€ / %.2f€" % [_detection_zone.value + object_value, goal_value]
	if _detection_zone.value + object_value == goal_value:
		_on_victory()
	
	last_coins_inside = _detection_zone.coins_inside.duplicate()

	
func on_text_submited(text: String) -> void:
	object_value = float($Settings/EditLine/Prix.text)
	goal_value = float($Settings/EditLine/BilletDonne.text)
	update_bar()
	_on_detection_zone_update_coins()
