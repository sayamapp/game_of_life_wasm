extends Node2D

signal start
signal stop 
signal change_size(size) 

var time = 0

const OPTION_VALUES = [10, 20, 50, 100, 200, 400, 500, 800, 1000]

func _ready():
	var _e = $StartButton.connect("button_down", self, "_on_start_button_down")
	_e = $StopButton.connect("button_down", self, "_on_stop_button_down")
	_e = $OptionButton.connect("item_selected", self, "_on_option_button_item_selected")
	_change_status(false)

	for v in OPTION_VALUES:
		$OptionButton.add_item("%s X %s = %s" % [v, v, v * v])
	

func _process(delta):
	$Delta.text = "D:%s" % delta
	$FPS.text = "FPS:%s" % Engine.get_frames_per_second()

func inc_time():
	time += 1
	$Time.text = "T:%s" % time


func _on_start_button_down():
	_change_status(true)
	emit_signal("start")

func _on_stop_button_down():
	time = 0
	_change_status(false)
	emit_signal("stop")

func _on_option_button_item_selected(value):
	emit_signal("change_size", OPTION_VALUES[value])

func _change_status(b):
	$StartButton.disabled = b
	$StopButton.disabled = !b
	$OptionButton.disabled = b
