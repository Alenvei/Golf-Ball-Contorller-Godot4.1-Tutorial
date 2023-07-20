extends Camera3D

@onready var golf_ball = $".."

#Variables for raycast
const ray_length = 100
var mouse_pos : Vector2
var from :Vector3
var to : Vector3
var space : PhysicsDirectSpaceState3D
var query : PhysicsRayQueryParameters3D

#Variable for camera follow
var vector : Vector3

func _ready() -> void:
	#We set the camera as top level to ignore parent's transformations. 
	#Otherwise, the camera will rotate violently.
	self.set_as_top_level(true)
		
func _process(delta) -> void:
	#Function to follow golf ball.
	camera_follow()
	
#Function to follow golf ball.
func camera_follow() -> void:
	vector = Vector3(golf_ball.transform.origin.x,position.y,golf_ball.transform.origin.z)
	
	self.transform.origin = self.transform.origin.lerp(vector,1)
	
#Translating the mouse position from the screen into 3d world.
func camera_raycast():
	mouse_pos = get_viewport().get_mouse_position()
	from = project_ray_origin(mouse_pos) 
	to = from + project_ray_normal(mouse_pos) * ray_length
	space = get_world_3d().direct_space_state
	#Raycast checking only the second collision mask.
	query = PhysicsRayQueryParameters3D.create(from,to,2)
	
	return space.intersect_ray(query)
