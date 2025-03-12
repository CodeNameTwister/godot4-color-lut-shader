@tool
extends Node

@export var LUT_size: int = 16
@export var save_identity_LUT: bool = false

var lut_image: Image

func _enter_tree() -> void:
	lut_image = generate_identity_lut(LUT_size)

func _exit_tree() -> void:
	lut_image = null

func _unhandled_input(event) -> void:
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_F11:
			generate_lut_screenshot()


func generate_lut_screenshot() -> void:
	var screenshot : Image = take_screenshot()
	var identity_lut : Image = lut_image
	var final_image_size : Vector2 = Vector2(max(screenshot.get_width(),identity_lut.get_width()), max(screenshot.get_height(),identity_lut.get_height()))
	if final_image_size.x == 0 or final_image_size.y == 0:
		push_error("Image screenshot size can not be zero!")
		return
	var final_image: Image = Image.new()
	final_image.create(final_image_size.x, final_image_size.y, false, Image.FORMAT_RGB8)
	final_image = _insert_image(final_image, screenshot)
	final_image = _insert_image(final_image, identity_lut)
	final_image.save_png("res://screenshot_lut.png")
	if save_identity_LUT:
		identity_lut.save_png("res://identity_lut_"+str(LUT_size)+".png")
	print("COLOR GRADING LUT: Screenshot with LUT of size "+str(LUT_size)+" was successfully created!\nTarget path: res://screenshot_lut.png")


func take_screenshot() -> Image:
	var image : Image = get_viewport().get_texture().get_image()
	image.flip_y()
	return image


func _insert_image(target:Image, inserted:Image) -> Image:
	for i : int in range(inserted.get_width()):
		for j : int in range(inserted.get_height()):
			var pos = Vector2(i, j)
			target.set_pixelv(pos, inserted.get_pixelv(pos))
	return target


func generate_identity_lut(lut_size:int) -> Image:
	if lut_size < 2:
		push_error("Lut size can not be 1x1")
		return null
	var image: Image = Image.create(lut_size*lut_size, lut_size, false, Image.FORMAT_RGB8)
	var divider:int = (lut_size-1)
	var div_step:float = 1.0/(lut_size-1)
	for b in range(lut_size):
		for g in range(lut_size):
			for r in range(lut_size):
				var pos : Vector2i = Vector2i(r + lut_size*b, g)
				var cur_color : Color = Color(float(r),float(g),float(b)) * div_step
				cur_color.a = 1
				image.set_pixelv(pos, cur_color)
	return image
