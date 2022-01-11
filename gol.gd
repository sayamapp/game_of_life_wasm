extends Node2D

var size = 10
var is_run = false

const FIELD_SIZE = 640
const TEXTURE_SIZE = 64

# リソース(テクスチャ、native script、visualserver_rid)のプリロード
onready var texture = preload("res://icon.png") 
onready var gol = preload("res://gol.gdns").new()
onready var ci_rid = VisualServer.canvas_item_create()

func _ready():
	# UIノードのシグナルを接続
	var ui_node = get_parent().get_node("UI")
	ui_node.connect("start", self, "_on_start")
	ui_node.connect("stop", self, "_on_stop")
	ui_node.connect("change_size", self, "_on_change_size")

	VisualServer.canvas_item_set_parent(ci_rid, get_canvas_item())

	gol.init(size) #GameOfLife構造体(rust側)の初期化
	_on_change_size(size)
	_draw()

# メインループ
func _process(_delta):
	if is_run:
		gol.calc()
	else:
		gol.calc_rand()
	_draw()

# セルの描画
func _draw():
	VisualServer.canvas_item_clear(ci_rid)
	var _array = gol.get_array()
	for p in _array:
		var _pos = Vector2(p.x, p.y) * TEXTURE_SIZE
		var _size = Vector2.ONE * TEXTURE_SIZE
		VisualServer.canvas_item_add_texture_rect(ci_rid, Rect2(_pos, _size), texture)

func _on_start():
	is_run = true

func _on_stop():
	is_run = false

func _on_change_size(_size):
	size = _size
	gol.init(size)
	self.scale = Vector2.ONE * 1.0
	self.scale = Vector2.ONE * (FIELD_SIZE / float(TEXTURE_SIZE * size))
