extends RigidBody3D

@export var max_speed : int = 8
@export var accel : int = 5

@onready var scaler = $Scaler
@onready var camera_3d = $Camera3D

var selected : bool = false
var velocity : Vector3
var speed : Vector3
var distance : float
var diraction :Vector3


func _ready() -> void:
	#We set the scaler as top level to ignore parent's transformations.
	#Otherwise, the camera will rotate violently.
	scaler.set_as_top_level(true)
	pass
	
#Checking if the golf ball is selected.
func _on_input_event(camera, event, position, normal, shape_idx) -> void:
	if event.is_action_pressed("left_mb"):
		selected = true
		
func _input(event) -> void:
	#After the mouse is released, we calculate the speed and shoot the ball in the given direction.	
	if event.is_action_released("left_mb"):
		if selected:
			#Calculating the speed 
			speed = - (diraction * distance * accel).limit_length(max_speed)
			
			shoot(speed)
		
		selected = false
		
func _process(delta) -> void:
	#Function to follow the golf ball.
	scaler_follow()
	
	pull_metter()
	
#Shothing the golf ball.
func shoot(vector:Vector3)->void:
	velocity = Vector3(vector.x,0,vector.z)
	
	self.apply_impulse(velocity, Vector3.ZERO)
	
#Function to the follow golf ball.
func scaler_follow() -> void:
	scaler.transform.origin = scaler.transform.origin.lerp(self.transform.origin,.8)
	
func pull_metter() -> void:
	#Calling the raycast from the camera node.
	var ray_cast = camera_3d.camera_raycast()
	
	if not ray_cast.is_empty():
		#Calculating the distance between the golf ball and the mouse position.
		distance = self.position.distance_to(ray_cast.position)
		#Calculating the direction vector between golf ball ,and mouse position.
		diraction = self.transform.origin.direction_to(ray_cast.position)
		#Looking at the mouse position in the 3D world.
		scaler.look_at(Vector3(ray_cast.position.x,position.y,ray_cast.position.z))
		
		if selected:
			#Scaling the scaler with limitation.
			scaler.scale.z = clamp(distance,0,2)
			
		else:
			#Resetting the scaler.
			scaler.scale.z = 0.01
