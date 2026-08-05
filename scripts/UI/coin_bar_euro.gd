@tool
class_name CoinBarEuro
extends HBoxContainer

const CoinPanelScene : PackedScene = preload("res://scenes/UI/CoinPanel.tscn")
var _coin_stack : Array[CoinPanel] = []
@onready var empty_panel : Panel = $EmptyPanel

@export var _goal_value : float = 100
@export var _width = 500

func setup(goal_value: float, width: float) -> void:
	_goal_value = goal_value
	_width = width
	update_coin_stack()

func add_coin(money_type: MoneyType.Denomination) -> int:
	var coin_panel : CoinPanel = CoinPanelScene.instantiate()
	add_child(coin_panel)
	move_child(coin_panel, 0)
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
	var total = 0.0
	var size_percent = 0.0
	for child in get_children():
		if child is CoinPanel:
			_coin_stack.append(child)
			total += child.get_monetary_value() 
	size_percent = (total / _goal_value)
	for coin in _coin_stack:
		if size_percent > 1: # In case of overflow, adapt the width of the container
			print("overflow : %d%%" % (size_percent * 100))
			size = Vector2(size_percent * _width, size.y)
		else:
			size = Vector2(_width, size.y)
		coin.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		coin.size_flags_stretch_ratio = coin.get_monetary_value() / max(_goal_value, _goal_value * size_percent)
	empty_panel.size_flags_stretch_ratio = (_goal_value - total) / max(_goal_value, _goal_value * size_percent)
