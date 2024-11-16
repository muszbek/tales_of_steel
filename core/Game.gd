extends Node2D

const LAST_IMPLEMENTED_CHAPTER = 2

const START_SCREEN = "res://screens/StartScreen.tscn"
const TO_BE_CONTINUED_SCREEN = "res://screens/ToBeConinued.tscn"
const END_SCREEN = "res://screens/TheEnd.tscn"

var current_chapter_index
var current_chapter
var saved_game: Dictionary = {}

func _ready():
	var screen = load_start_screen()
	current_chapter_index = yield(screen, "start_screen_finished")
	load_chapter()

func load_start_screen():
	var start_screen_loaded = load(START_SCREEN)
	var start_screen_instance = start_screen_loaded.instance()
	add_child(start_screen_instance)
	return start_screen_instance

func load_chapter():
	saved_game = {}
	#var current_chapter_path = get_demo_chapter_path()
	var current_chapter_path = get_chapter_path(current_chapter_index)
	var chapter_loaded = load(current_chapter_path)
	var chapter_instance = chapter_loaded.instance()
	add_child(chapter_instance)
	current_chapter = chapter_instance

func on_chapter_finish():
	current_chapter.queue_free()
	if current_chapter_index == LAST_IMPLEMENTED_CHAPTER:
		load_to_be_continued() #load_end_screen()
	else:
		current_chapter_index += 1
		load_chapter()

func load_to_be_continued():
	var screen_loaded = load(TO_BE_CONTINUED_SCREEN)
	var screen_instance = screen_loaded.instance()
	add_child(screen_instance)

func load_end_screen():
	var screen_loaded = load(END_SCREEN)
	var screen_instance = screen_loaded.instance()
	add_child(screen_instance)

func get_demo_chapter_path():
	return "res://map/demo/DemoLoader.tscn"

func get_chapter_path(index: int):
	var i: String = str(index)
	return "res://map/chapter_" + i + "/Chapter" + i + "Loader.tscn"


### CHAPTER SELECTOR API ###
func get_max_chapter():
	return LAST_IMPLEMENTED_CHAPTER

func set_current_chapter(index: int):
	current_chapter_index = index

### SAVE API ###
func save():
	save_events()
	save_player()

func save_events():
	var events: Array = get_tree().get_nodes_in_group("event")
	
	for event in events:
		save_event(event)

func save_event(event):
	var id = event.get_name()
	var data: Dictionary = event.save_state()
	saved_game[id] = data

func save_player():
	var player = get_tree().get_nodes_in_group("player")[-1]
	
	var data: Dictionary = player.save_behavior.save_state()
	saved_game["Player"] = data
