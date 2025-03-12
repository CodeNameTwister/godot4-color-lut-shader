@tool
extends ColorRect

@export var lut: CompressedTexture2D

var shader_material : ShaderMaterial = null

func _init() -> void:
	# Create Shader Material
	shader_material = ShaderMaterial.new()
	material = shader_material
	# Assign Shader
	lut = load("res://addons/color_grading_lut/default_luts/identity.png")
	shader_material.shader = load("res://addons/color_grading_lut/filter_node/color_grading_lut.gdshader")
	shader_material.set_shader_parameter("lut", lut)
	# Resize to screen
	anchor_left = 0
	anchor_right = 1
	anchor_top = 0
	anchor_bottom = 1

func _draw() -> void:
	shader_material.set_shader_parameter("filter_alpha", color.a)
	shader_material.set_shader_parameter("lut", lut)
