extends CharacterBody2D

@export var max_health := 40
var health := 40
var speed := 80.0
var damage_cooldown := 0.0
var player: Node2D

func _ready():
    add_to_group("enemies")
    player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
    if player == null or not is_instance_valid(player):
        return

    var to_player = player.global_position - global_position
    var distance = to_player.length()
    damage_cooldown = max(0.0, damage_cooldown - delta)

    if distance > 0:
        if distance < 200:
            var direction = to_player.normalized()
            velocity = direction * speed
            move_and_slide()
        else:
            velocity = Vector2.ZERO

    if distance < 24 and damage_cooldown == 0.0:
        if player.has_method("take_damage"):
            player.take_damage(10)
        damage_cooldown = 1.0

func damage(amount):
    health -= amount
    if health <= 0:
        queue_free()
