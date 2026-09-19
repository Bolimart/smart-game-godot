extends Area2D
class_name CoinSpawner

var coin_manager : CoinManager
@export var coin_type : MoneyType.Denomination = MoneyType.Denomination.PIECE_1E
var _open_button_hovered : bool = false
var cashier : Cashier

func set_coin_manager(coin_manager: CoinManager):
	self.coin_manager = coin_manager

func mouse_entered() -> void:
	_open_button_hovered = true
	 
func mouse_exited() -> void:
	_open_button_hovered = false

func _input(event) -> void:
	if event is InputEventMouseButton and cashier.is_open:
		if _open_button_hovered and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
			coin_manager.add_coin(coin_type)
