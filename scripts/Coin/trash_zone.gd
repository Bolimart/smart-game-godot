extends Area2D

@export var coin_manager : CoinManager

func on_object_enter(coin: Area2D) -> void:
	if coin is Coin:
		if coin.picked_up:
			print("Coin Entered")
			coin.dropped.connect(remove_coin.bind(coin))
		else:
			remove_coin(coin)

func remove_coin(coin: Coin) -> void:
	coin_manager.remove_coin(coin)
	coin.queue_free()
