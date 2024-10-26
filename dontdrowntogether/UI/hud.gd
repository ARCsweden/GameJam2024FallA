extends CanvasLayer
class_name HUD

@onready var lengthCounterLabel_node = %NumberCounterLentgh_Label
@onready var timeCounterLabel_Node = %NumberCounterTime_Label
@onready var scrapCounterLabel_Node = %ScrapCounter_label
@onready var unixTime_start
@onready var unixTime_now

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	unixTime_start = Time.get_unix_time_from_system()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_time_counter()
	pass

func update_time_counter():
	unixTime_now = Time.get_unix_time_from_system()
	var timePassed = int(unixTime_now - unixTime_start)
	timeCounterLabel_Node.text = str(timePassed)
	
	pass

func update_lentgh_counter(newAmount):
	lengthCounterLabel_node.text = str(newAmount)
	pass
	
func update_scrap_Counter(newScrapAmount):
	scrapCounterLabel_Node.text = str(newScrapAmount)
	pass
