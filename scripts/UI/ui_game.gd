extends Control

@onready var _coin_bar : CoinBarEuro = $Panel/CoinBarEuro
@onready var _detection_zone : DetectionZone = $DetectionZone

@export var goal_value : float = 20.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_coin_bar.setup(goal_value, $Panel.size.x - 5)
	_coin_bar.update_coin_stack()


func _on_detection_zone_update_coins() -> void:
	_coin_bar.clear_coin()
	for coin in _detection_zone.coins_inside:
		_coin_bar.add_coin(coin.value)
