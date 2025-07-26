extends Node3D

@export_group("FOV")
@export var change_fov_on_run : bool
@export var normal_fov : float = 75.0
@export var run_fov : float = 90.0

const CAMERA_BLEND : float = 0.05

@onready var spring_arm : SpringArm3D = $SpringArm3D
@onready var camera : Camera3D = $SpringArm3D/Camera3D

@export_group("Camera Zoom")
@export var camera_distance_min := 1.0
@export var camera_distance_max := 5.0
@export var camera_distance_default := 3.0
@export var camera_zoom_step = 0.2

var mouse_sense = 0.003

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	camera.fov = normal_fov
	spring_arm.spring_length = camera_distance_default
	
func _input(_event):
	if Input.is_action_just_pressed("zoom_out"):
		spring_arm.spring_length += camera_zoom_step
		spring_arm.spring_length = clamp(spring_arm.spring_length, camera_distance_min, camera_distance_max)
	if Input.is_action_just_pressed("zoom_in"):
		spring_arm.spring_length -= camera_zoom_step
		spring_arm.spring_length = clamp(spring_arm.spring_length, camera_distance_min, camera_distance_max)
	if Input.is_action_just_pressed("zoom_reset"):
		spring_arm.spring_length = camera_distance_default
		
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sense)
		spring_arm.rotate_x(-event.relative.y * mouse_sense)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/3, PI/3)
		
func _physics_process(_delta):
	if change_fov_on_run:
		if owner.is_on_floor():
			if Input.is_action_pressed("run"):
				camera.fov = lerp(camera.fov, run_fov, CAMERA_BLEND)
			else:
				camera.fov = lerp(camera.fov, normal_fov, CAMERA_BLEND)
		else:
			camera.fov = lerp(camera.fov, normal_fov, CAMERA_BLEND)
