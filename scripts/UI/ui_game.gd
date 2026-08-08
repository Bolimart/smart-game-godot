extends Control

@onready var _coin_bar : CoinBarEuro = $CoinBarPanel/CoinBarEuro
@onready var _coin_label : Label = $CoinLabel
@export var _detection_zone : DetectionZone

@export var goal_value : float = 20.0
@export var object_value : float = 10.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_coin_bar.setup(goal_value, object_value, $CoinBarPanel.size.x - 5)
	_coin_bar.update_coin_stack()
	_coin_label.text = "%.2f€ / %.2f€" % [object_value, goal_value]


func _on_detection_zone_update_coins() -> void:
	_coin_bar.clear_coin()
	for coin in _detection_zone.coins_inside:
		_coin_bar.add_coin(coin.value)
	_coin_label.text = "%.2f€ / %.2f€" % [_detection_zone.value + object_value, goal_value]
