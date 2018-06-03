extends KinematicBody2D

const SPEED = 30
const JUMP_HEIGHT = 120

var movement = Vector2()
var exploded = false

var collisions
enum COLLISIONS {
	left,
	right,
	top,
	bottom
}

func _ready():
	explode()
	pass

func _physics_process(delta):
	movement_controller()
	
#	if !exploded and has_collided_with("ENEMY"):
#		explode()
	
	pass

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

	var touching_floor = left_ray_touching or right_ray_touching
	return touching_floor
	
func explode():
	exploded = true
	
	# change colliders
	$full_body.disabled = true
	$head_collider.disabled = false
	
	# hide the body (ꐦ°᷄д°᷅)
	$body.visible = false
	
	# move the floor casters
	$left_floor_ray.position = Vector2(-2, 0)
	$right_floor_ray.position = Vector2(2, 0)
	
	var cast_pos = Vector2(0, -2.2)
	$left_floor_ray.cast_to = cast_pos
	$right_floor_ray.cast_to = cast_pos

func re_assemble():
	exploded = false
	
	$full_body.disabled = false
	$head_collider.disabled = true
	
	$body.visible = true
	
	$left_floor_ray.position = Vector2(-4, 0)
	$right_floor_ray.position = Vector2(4, 0)
	
	var cast_pos = Vector2(0, -4.2)
	$left_floor_ray.cast_to = cast_pos
	$right_floor_ray.cast_to = cast_pos
	
# change between exploded and not exploded
func change_state(exploded):
	self.exploded = exploded
	
	$full_body.disabled = exploded
	$head_collider.disabled = !exploded
	
	$body.visible = !exploded
	
	var pos = 2
	if !exploded:
		pos = 4
	
	$left_floor_ray.position = Vector2(-pos, 0)
	$right_floor_ray.position = Vector2(pos, 0)
	
	var cast_pos = Vector2(0, -pos -.2)
	$left_floor_ray.cast_to = cast_pos
	$right_floor_ray.cast_to = cast_pos
	
func get_movement():
	return movement
	
func set_movement(new_movement):
	movement = new_movement
	
func get_exploded():
	return exploded