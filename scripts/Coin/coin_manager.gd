class_name CoinManager
extends Node2D

var coins : Array[Coin] = []
var grabbed_coins_queue : Array[Coin] = []
var coin_scene : Resource = preload("res://scenes/Coin/Coin.tscn")

func _process(_delta: float) -> void:
	for i in range(len(grabbed_coins_queue) -1, -1, -1):
		if grabbed_coins_queue[i] is Coin:
			var coin = coins[i]
			coin.pick_up()
			put_coin_on_top(i)
			empty_queue()
			break

func empty_queue() -> void:
	grabbed_coins_queue.fill(null)

func get_coin_index(coin: Coin) -> int:
	return coins.find(coin)

func add_coin(coin_type: MoneyType.Denomination) -> void:	
	var coin : Coin = coin_scene.instantiate()
	coin.value = coin_type
	add_child(coin)
	coin.ask_pickup.connect(_on_ask_pick_up.bind(coin))
	coin.dropped.connect(_on_coin_dropped.bind(coin))
	coin.z_index = len(coins)
	coins.append(coin)
	coin.position = get_global_mouse_position()
	grabbed_coins_queue.append(null)
	coin.pick_up()


func remove_coin(coin: Coin) -> void:	
	remove_child(coin)
	coin.ask_pickup.disconnect(_on_ask_pick_up.bind(coin))
	coin.dropped.disconnect(_on_coin_dropped.bind(coin))
	coins.remove_at(get_coin_index(coin))

func clear_coin() -> void:
	for coin in coins:
		remove_child(coin)
		coin.ask_pickup.disconnect(_on_ask_pick_up.bind(coin))
		coin.dropped.disconnect(_on_coin_dropped.bind(coin))
	coins.clear()

func put_coin_on_top(index: int) -> void:
	coins.append(coins.pop_at(index))
	for i in range(index, len(coins)):
		coins[i].z_index = i + 1

func _on_ask_pick_up(coin: Coin) -> void:
	var index = get_coin_index(coin)
	grabbed_coins_queue[index] = coin
	
func _on_coin_dropped(coin: Coin) -> void:
	var index = get_coin_index(coin)
	grabbed_coins_queue[index] = null
