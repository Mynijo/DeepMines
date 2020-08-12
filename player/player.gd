extends Node

export (int) var health = 100
export (int) var money = 120

func _ready():
	$Live.text = "Health:" + String(health)
	$Wave.text = "Wave:"
	$Money.text = "Money:" + String(money)
	
func add_money(value):
	money += value
	$Money.text = "Money:" + String(money)
	
	
func take_damage(damage):
	health -= damage
	$Live.text = "Health:" + String(health)
	if health <= 0:
		pass 

func get_health():
	return health
		
func wave_changed(_wave):
	$Wave.text = "Wave:" + String(_wave)

func wave_status(_status):
	$WaveEnd.text = _status
