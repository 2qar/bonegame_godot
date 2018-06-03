extends KinematicBody2D

func _ready():
	add_to_group("enemy")
	pass

func _on_head_area_body_entered(body):
	if body.name == "Player":
		if body.call("get_exploded"):
			destroy_head(body)

func _on_steal_body_entered(body):
	if body.name == "Player":
		if body.call("get_exploded"):
			steal_body()

func destroy_head(player):
	# make the player bounce
	var movement = player.call("get_movement")
	player.call("set_movement", Vector2(movement.x, -60))
	
	# get rid of the head
	$head/head_area/head_collider.disabled = true
	$head/head_area.queue_free()
	$head.visible = false
	
	# modify the collider to reflect the head removal
	var shape = RectangleShape2D.new()
	shape.set_extents(Vector2(4, 2.5))
	$body_collider.shape = shape
	$body_collider.position = Vector2(0, 1.5)
	
func steal_body():
	var player = get_parent().get_node("Player")
	
	player.position = position
	$body_collider.disabled = true
	player.call("re_assemble")
	
	queue_free()