class_name CoinManager
extends Node2D

var coins : Array[Coin] = []
var grabbed_coins_queue : Array[Coin] = []

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("coins"):
		if node is Coin:
			node.ask_pickup.connect(_on_ask_pick_up.bind(node))
			node.dropped.connect(_on_coin_dropped.bind(node))
			node.z_index = len(coins)
			coins.append(node)
			grabbed_coins_queue.append(null)
	print(len(grabbed_coins_queue))

func _process(_delta: float) -> void:
	for i in range(len(grabbed_coins_queue) -1, -1, -1):
		if grabbed_coins_queue[i] is Coin:
			var coin = coins[i]
			print("Coin %.2f€ is allowed to be picked" % coin.get_monetary_value())
			coin.pick_up()
			put_coin_on_top(i)
			empty_queue()
			break

func empty_queue() -> void:
	grabbed_coins_queue.fill(null)

func get_coin_index(coin: Coin) -> int:
	return coins.find(coin)

func put_coin_on_top(index: int) -> void:
	coins.append(coins.pop_at(index))
	for i in range(index, len(coins)):
		coins[i].z_index = i + 1

func _on_ask_pick_up(coin: Coin) -> void:
	var index = get_coin_index(coin)
	print("Coin %.2f€ asked to be picked up" % coin.get_monetary_value())
	grabbed_coins_queue[index] = coin
	
func _on_coin_dropped(coin: Coin) -> void:
	var index = get_coin_index(coin)
	grabbed_coins_queue[index] = null
