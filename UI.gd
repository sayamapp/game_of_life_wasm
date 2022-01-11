extends Node2D

signal start
signal stop 
signal change_size(size) 

# サイズの種類
const OPTION_VALUES = [10, 20, 50, 100, 200, 400, 500, 800, 1000]

func _ready():
	# ボタン等からのシグナルを接続
	var _e = $StartButton.connect("button_down", self, "_on_start_button_down")
	_e = $StopButton.connect("button_down", self, "_on_stop_button_down")
	_e = $OptionButton.connect("item_selected", self, "_on_option_button_item_selected")
	# オプションメニューの項目を追加
	for v in OPTION_VALUES:
		$OptionButton.add_item("%s X %s = %s" % [v, v, v * v])

	_change_status(false)

	

# FPSとdelta timeの更新
func _process(delta):
	$Delta.text = "D:%s" % delta
	$FPS.text = "FPS:%s" % Engine.get_frames_per_second()


# スタートボタン押下でシグナル送信
func _on_start_button_down():
	_change_status(true)
	emit_signal("start")

# ストップボタン押下でシグナル送信
func _on_stop_button_down():
	_change_status(false)
	emit_signal("stop")

# オプションメニューのアイテム選択時にシグナル送信
func _on_option_button_item_selected(value):
	emit_signal("change_size", OPTION_VALUES[value])

# ボタンの状態変更
func _change_status(b):
	$StartButton.disabled = b
	$StopButton.disabled = !b
	$OptionButton.disabled = b
