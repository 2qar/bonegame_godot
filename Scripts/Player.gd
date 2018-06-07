# FIXME: Right raycast 1 pixel short of where it should be when the
# player is just a skull

extends KinematicBody2D

const SPEED = 30
const JUMP_HEIGHT = 120

const RAYCAST_DISTANCE = .2

onready var SWORD_OFFSET = $sword.position.x

var movement = Vector2()
var exploded = false

func _ready():
	change_state(true)
	pass

func _physics_process(delta):
	movement_controller()

func movement_controller():
	var speed = SPEED
	if Input.is_action_pressed("sprint"):
		speed += 20
	
	var grounded = is_on_floor()
	if !grounded:
		movement.y += 10
	
	# limit fall speed to 500, adjust this maybe
	movement.y = clamp(movement.y, -10000, 500)
	
	# movement left + right
	if Input.is_action_pressed("left"):
		movement.x = -speed
	elif Input.is_action_pressed("right"):
		movement.x = speed
	else:
		movement.x = 0
	
	# jumping
	if Input.is_action_just_pressed("jump") and grounded:
		movement.y = -JUMP_HEIGHT
		
	# apply all of this funky movement
	movement = move_and_slide(movement, Vector2(0, -1))

func is_on_floor():
	var left_ray_touching = $left_floor_ray.is_colliding()
	var right_ray_touching = $right_floor_ray.is_colliding()

#	var left_distance = $left_floor_ray.global_position.distance_to($left_floor_ray.get_collision_point())
#	print("Left: ", left_distance)
#	var right_distance = $right_floor_ray.global_position.distance_to($right_floor_ray.get_collision_point())
#	print("Right: ", right_distance)

	var touching_floor = left_ray_touching or right_ray_touching
	return touching_floor
	
# change between exploded and not exploded
func change_state(exploded):
	self.exploded = exploded
	
	if !exploded:
		$hitbox/collider.position = Vector2(-.5, 0)
		$hitbox/collider.shape.set_extents(Vector2(3.5, 4))
	else:
		$hitbox/collider.position = $head_collider.position
		$hitbox/collider.shape = $head_collider.shape
	
	$full_body.disabled = exploded
	$head_collider.disabled = !exploded
	
	$body.visible = !exploded
	
	var pos = 2
	if !exploded:
		pos = 4
	
	#$left_floor_ray.position = Vector2(-2, 0)
	#$right_floor_ray.position = Vector2(2, 0)
	
	var cast_pos = Vector2(0, pos + RAYCAST_DISTANCE)
	if exploded:
		cast_pos.y = 1 + RAYCAST_DISTANCE
		
	$left_floor_ray.cast_to = cast_pos
	$right_floor_ray.cast_to = cast_pos
	
func get_movement():
	return movement
	
func set_movement(new_movement):
	movement = new_movement
	
func get_exploded():
	return exploded