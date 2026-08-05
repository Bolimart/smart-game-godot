@tool
class_name CoinPanel
extends Panel

@onready var label = $Label

@export var _value : MoneyType.Denomination = MoneyType.Denomination.PIECE_1E:
	set(new_value):
		_value = new_value
		if Engine.is_editor_hint():
			setup(_value)

@export var main_colors : Array[Color]
@export var accent_colors : Array[Color]
@export var min_sizes : Array[float]


func get_monetary_value() -> float:
	return MoneyType.get_monetary_value(_value)

func setup(value: MoneyType.Denomination) -> void:
	if not is_node_ready():
		return
	_value = value
	match value:
		MoneyType.Denomination.PIECE_1C: label.text = "1c"
		MoneyType.Denomination.PIECE_2C: label.text = "2c"
		MoneyType.Denomination.PIECE_5C: label.text = "5c"
		MoneyType.Denomination.PIECE_10C: label.text = "10c"
		MoneyType.Denomination.PIECE_20C: label.text = "20c"
		MoneyType.Denomination.PIECE_50C: label.text = "50c"
		MoneyType.Denomination.PIECE_1E: label.text = "1€"
		MoneyType.Denomination.PIECE_2E: label.text = "2€"
		MoneyType.Denomination.BILLET_5E: label.text = "5€"
		MoneyType.Denomination.BILLET_10E: label.text = "10€"
		MoneyType.Denomination.BILLET_20E: label.text = "20€"
		MoneyType.Denomination.BILLET_50E: label.text = "50€"
		MoneyType.Denomination.BILLET_100E: label.text = "100€"
		MoneyType.Denomination.BILLET_200E: label.text = "200€"
		MoneyType.Denomination.BILLET_500E: label.text = "500€"
		_: label.text = "Error"
	var raw_style := get_theme_stylebox("panel")
	if raw_style is StyleBoxFancy:
		var sbf: StyleBoxFancy = raw_style
		sbf.color = main_colors[value]
		sbf.borders[0].color = accent_colors[value]
		custom_minimum_size = Vector2(min_sizes[value], custom_minimum_size.y)
	else:
		push_warning("Le panel n'a pas de StyleBoxFancy assignée en override")
