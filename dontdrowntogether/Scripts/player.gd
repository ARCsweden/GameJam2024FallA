extends CharacterBody2D
class_name Player

@onready var hook: Hook = $Hook
@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $PlayerBoundUi/Label
@onready var paddle_sprite: AnimatedSprite2D = $PaddleSprite

const GAME_OVER_CANVAS_LAYER = preload("res://UI/game_over_canvas_layer.tscn")

@export var speed: float = Global.player_move_speed

var controller_id

var move_up
var move_down
var move_left
var move_right
var paddle_btn
var hook_btn
var repair_btn
var controller_ready := false
var repair_prompt = "PRESS B TO REPAIR"

var last_tile
var can_repair = false

@export var cur_dir: Vector2 = Vector2.LEFT

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Vector2.ZERO
	# Get input direction
	if controller_ready == true:
		direction = Input.get_vector(move_left, move_right, move_up, move_down).normalized()
	# Update last known facing, used for hook
	if direction != Vector2.ZERO:
		cur_dir = direction
		rotation = (cur_dir.angle() + PI/2) - get_parent().rotation

	velocity = direction * speed

	# Move the character
	move_and_slide()

func _ready() -> void:
	add_to_group("ActivePlayers")
	if(controller_id % 2 == 1):
		var texture = load("res://Assets/Cap2.png")
		sprite.texture = texture
	connect_Raft_Tiles_signal()
	SignalBus.pickup_grunka.connect(_on_pickup_grunka)

func set_controller_id(id) -> void:
	controller_id = id
	move_up = "move_up" + str(controller_id)
	move_down = "move_down" + str(controller_id)
	move_right = "move_right" + str(controller_id)
	move_left = "move_left" + str(controller_id)
	paddle_btn = "paddle" + str(controller_id)
	hook_btn = "hook" + str(controller_id)
	repair_btn = "repair" + str(controller_id)
	controller_ready = true

func _process(_delta) -> void:
	if controller_ready == true:
		if Input.is_action_pressed(paddle_btn):
			SignalBus.paddle.emit(position, cur_dir)
			paddle_sprite.visible = true
		else:
			paddle_sprite.visible = false
		if Input.is_action_just_pressed(hook_btn):
			hook.activate_hook(cur_dir)
		if Input.is_action_just_pressed(repair_btn):
			if(can_repair and last_tile != null):
				last_tile.call_repair()
				if(Global.scrapAmount < Global.repair_cost):
					label.visible = false
					can_repair = false

func repair_raft_tile() -> void:
	pass

func _on_damage_tile_entered(_area):
	if(Global.scrapAmount >= Global.repair_cost):
		label.text = repair_prompt
		label.visible = true
		can_repair = true

func _on_repair_check_area_area_exited(_area: Area2D) -> void:
	label.visible = false
	can_repair = false

func connect_Raft_Tiles_signal():
	var raftTiles = get_tree().get_nodes_in_group("RaftTiles")
	for i in raftTiles:
		i.destroyTile.connect(killPlayer)

func killPlayer(body):
	var distaneToDestiodTile = body.position - self.position
	var removeSelf = false
	
	if distaneToDestiodTile.length() <= (Global.raft_tile_length - 50):
		print("remove")
		print(self)
		self.remove_from_group("ActivePlayers")
		removeSelf = true
		self.hide()
		
	var playersGroup = get_tree().get_nodes_in_group("ActivePlayers")
	if playersGroup.size() == 0:
		var newGameover = GAME_OVER_CANVAS_LAYER.instantiate()
		add_child(newGameover)
		get_tree().paused = true
	if removeSelf:
		$Drowning_AudioStreamPlayer.play()
		await $Drowning_AudioStreamPlayer.finished
		queue_free()

func set_repair(_status) -> void:
	can_repair = _status
	label.visible = _status
	if(_status):
		label.text = repair_prompt
	
func _on_pickup_grunka(_value: int) -> void:
	if(last_tile != null):
		if(last_tile.get_health() < last_tile.get_max_health()):
			set_repair(true)

func _on_tile_entered(area) -> void:
	last_tile = area
