@tool
class_name CoinBarEuro
extends HBoxContainer

const EPSILON := 0.001  # ou 0.001 selon la précision dont tu as besoin
const CoinPanelScene : PackedScene = preload("res://scenes/UI/CoinPanel.tscn")
var _coin_stack : Array[CoinPanel] = []
@onready var empty_panel : Panel = $EmptyPanel
@onready var object_price_panel : Panel = $ObjectPricePanel
@onready var price_label : Label = $ObjectPricePanel/PriceLabel

@export var _goal_value : float = 100
@export var _width = 500
@export var _base_object_price = 300

func setup(goal_value: float, base_object_price: float, width: float) -> void:
	_base_object_price = base_object_price
	_goal_value = goal_value
	_width = width
	add_theme_constant_override("separation", 0)
	object_price_panel.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if _base_object_price != 0:
		price_label.text = "%.2f€" % _base_object_price
	else:
		price_label.text = ""
	update_coin_stack()


func add_coin(money_type: MoneyType.Denomination) -> int:
	var coin_panel : CoinPanel = CoinPanelScene.instantiate()
	add_child(coin_panel)
	move_child(coin_panel, len(_coin_stack) + 1)
	coin_panel.setup(money_type)
	update_coin_stack()
	return len(_coin_stack)


func remove_coin(id: int) -> void:
	var coin = _coin_stack.pop_at(id)
	remove_child(coin)
	update_coin_stack()


func clear_coin() -> void:
	var coin = _coin_stack.pop_front()
	if coin == null:
		update_coin_stack()
		return
	remove_child(coin)
	clear_coin()


func update_coin_stack() -> void:
	if _goal_value <= 0: return
	_coin_stack.clear()
	var total = _base_object_price
	var size_percent = _base_object_price / _goal_value
	for child in get_children():
		if child is CoinPanel:
			_coin_stack.append(child)
			total += child.get_monetary_value()
			if (total / _goal_value) > 1.0 + EPSILON:
				print("%f / %f = %f" % [total, _goal_value, total/ _goal_value])
				child.set_overflow_color()
	size_percent = (total / _goal_value)
	
	if size_percent > 1:
		size = Vector2(size_percent * _width, size.y)
	else:
		size = Vector2(_width, size.y)

	for coin in _coin_stack:
		coin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		coin.size_flags_stretch_ratio = coin.get_monetary_value() / max(_goal_value, _goal_value * size_percent)
	object_price_panel.size_flags_stretch_ratio = _base_object_price / max(_goal_value, _goal_value * size_percent)
	empty_panel.size_flags_stretch_ratio = max(0.0, (_goal_value - total) / max(_goal_value, _goal_value * size_percent))
