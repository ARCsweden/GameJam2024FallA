extends CanvasLayer
class_name HUD

@onready var lengthCounterLabel_node = %NumberCounterLentgh_Label
@onready var timeCounterLabel_Node = %NumberCounterTime_Label
@onready var scrapCounterLabel_Node = %ScrapCounter_label

var timer: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	update_time_counter()

func update_time_counter():
	var timePassed = int(timer)
	timeCounterLabel_Node.text = str(timePassed)

func update_lentgh_counter(newAmount):
	lengthCounterLabel_node.text = str(newAmount)

func update_scrap_Counter(newScrapAmount):
	scrapCounterLabel_Node.text = str(newScrapAmount)
