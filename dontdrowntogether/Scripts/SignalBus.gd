extends Node

@warning_ignore("unused_signal")
signal hooked(grunka, player)

@warning_ignore("unused_signal")
signal pickup_grunka(value)

@warning_ignore("unused_signal")
signal paddle(player_pos: Vector2, cur_dir: Vector2)

@warning_ignore("unused_signal")
signal build(player_pos: Vector2, cur_dir: Vector2, current_tile)
