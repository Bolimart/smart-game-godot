class_name DetectionZone
extends Area2D

var coins_inside : Array[Coin] = []
var value := 0.0

signal update_coins()

func add_coin(coin: Area2D) -> void:
	if coin is Coin:
		coins_inside.append(coin)
		value += coin.get_monetary_value()
		print("coin of value %.2f entered zone, new total is %.2f" % [coin.get_monetary_value(), value])
		update_coins.emit()


func remove_coin(coin: Area2D) -> void:
	if coin is Coin:
		coins_inside.erase(coin)
		value -= coin.get_monetary_value()
		print("coin of value %.2f exited zone, new total is %.2f" % [coin.get_monetary_value(), value])
		update_coins.emit()
