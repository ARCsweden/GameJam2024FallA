extends CanvasLayer
class_name HUD

@onready var lengthCounterLabel_node = %NumberCounterLentgh_Label
@onready var timeCounterLabel_Node = %NumberCounterTime_Label
@onready var scrapCounterLabel_Node = %ScrapCounter_label
var raftbody_node

var timer: float = 0.0

#func _ready() -> void:
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	timer += delta
	update_time_counter()
	update_lentgh_counter()

func update_time_counter():
	var timePassed = int(timer)
	timeCounterLabel_Node.text = str(timePassed)

func update_lentgh_counter():
	raftbody_node = get_tree().get_nodes_in_group("RaftBody") 
	var raft = raftbody_node[0]
	Global.distance_traveled = -int(raft.position.y/100)
	lengthCounterLabel_node.text = str(max(Global.distance_traveled,0)) #TODO change raft spawn position so its 0 by default

func update_scrap_Counter(newScrapAmount):
	scrapCounterLabel_Node.text = str(newScrapAmount)
