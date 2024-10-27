extends Node

# Raft
var raft_tile_length: int = 100
var rng = RandomNumberGenerator.new()
var distance_traveled : int = 0
var scrapAmount : int = 0

### MECHANICS ###
# Cost in scrap to repair a tile
const repair_cost : int = 1
# Max hp of a tile
const raft_max_hp := 10.0
# Amount of tile hp repaired with a single repair (clamps at raft_max_hp)
const repair_amount : float = 1.0

# Timer range for tile decay (randomized) in seconds. Lower values is faster decay
const raft_decay_min : float = 10.0
const raft_decay_max : float = 20.0
# Amount of HP lost on decay tick
const raft_decay_amount : float = 1.0

# The amount of force applied while holding paddle
const paddle_force : float = 50.0
const player_move_speed : float = 200.0  # Movement speed of the character/s
const hook_distance : float = 400.0
const hook_speed : float = 0.5 # In s. Lower value is faster
const hook_retract : float = 0.1 # In s. Lower value is faster

# Rand range of grunka scrap value (determined on spawn)
const grunka_value_min : int = 1
const grunka_value_max : int = 5

# Spawn timer range for grunkor in s (lower value is more frequent)
const grunka_spawn_min : float = 2.0
const grunka_spawn_max : float = 5.0

const grunka_xvel : float = 50.0 # Initial speed in x direction (in random range + to -)
const grunka_yvel_min : float = -30.0 # Initial speed in y direction
const grunka_yvel_max : float = -15 # Initial speed in y direction
const grunka_ang_vel : float = 2.0 # Initial angular veclocity in radians/s (in random range + to -)

# Spawn timer range for stones in s (lower value is more frequent)
const stone_spawn_min : float = 1.0
const stone_spawn_max : float = 2.0
var stone_spawn_offset : int = 20
const stone_size_min : float = 50.0
const stone_size_max : float = 200.0

# Damage when colliding
const stone_damaged_tiles_min: int = 1
const stone_damaged_tiles_max: int = 3
const stone_damage: float = 3.0
const wall_damaged_tiles_min: int = 1
const wall_damaged_tiles_max: int = 3
const wall_damage: float = 3.0

# Raft max dimensions
const raft_rows : int = 5
const raft_columns : int = 5
const raft_start_radius : int = 1 # layers outside the center tile. 1 = 3x3 square

const river_force : float = 20.0
const river_acc : float = 0.0 # Amount that river_force increases every second
