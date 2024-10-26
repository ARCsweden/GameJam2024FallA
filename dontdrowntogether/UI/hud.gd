extends CanvasLayer

@onready var lengthCounterLabel_node = %NumberCounterLentgh_Label
@onready var timeCounterLabel_Node = %NumberCounterTime_Label
@onready var scrapCounterLabel_Node = %ScrapCounter_label


@onready var scrapAmount : int = 0

var timer: float = 0.0


func _on_pickup_grunka(value: int) -> void:
	scrapAmount += value
	update_scrap_Counter(scrapAmount)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.pickup_grunka.connect(_on_pickup_grunka)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	update_time_counter()


func update_time_counter():
	var timePassed = int(timer)
	timeCounterLabel_Node.text = str(timePassed)
	
	pass

func update_lentgh_counter(newAmount):
	lengthCounterLabel_node.text = str(newAmount)
	pass
	
func update_scrap_Counter(newScrapAmount):
	scrapCounterLabel_Node.text = str(newScrapAmount)
	pass
