extends Area2D

func call_repair() -> void:
	$"..".repair()
	
func get_health() -> float:
	return $"..".health

func get_max_health() -> float:
	return $"..".max_hp
