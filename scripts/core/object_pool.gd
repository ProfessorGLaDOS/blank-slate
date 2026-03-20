class_name ObjectPool
extends Node
## Generic object pool for reusing scene instances.
## Pre-instantiates a fixed number of nodes and recycles them to avoid
## repeated instantiation and freeing during gameplay.

var pool: Array[Node] = []
var scene: PackedScene
var pool_size: int


func _init(packed_scene: PackedScene = null, size: int = 20) -> void:
	scene = packed_scene
	pool_size = size


func _ready() -> void:
	if scene == null:
		push_warning("ObjectPool: No PackedScene assigned. Pool will be empty.")
		return

	for i in pool_size:
		var instance: Node = scene.instantiate()
		_deactivate(instance)
		add_child(instance)
		pool.append(instance)


func get_instance() -> Node:
	for obj in pool:
		if not obj.visible:
			_activate(obj)
			return obj

	# All instances busy -- expand the pool by one
	if scene == null:
		push_error("ObjectPool: Cannot expand pool, no PackedScene set.")
		return null

	var instance: Node = scene.instantiate()
	add_child(instance)
	pool.append(instance)
	_activate(instance)
	pool_size += 1
	return instance


func return_instance(obj: Node) -> void:
	if obj == null:
		return
	_deactivate(obj)


func get_active_count() -> int:
	var count: int = 0
	for obj in pool:
		if obj.visible:
			count += 1
	return count


func get_pool_size() -> int:
	return pool.size()


func _activate(obj: Node) -> void:
	obj.visible = true
	obj.set_process(true)
	obj.set_physics_process(true)


func _deactivate(obj: Node) -> void:
	obj.visible = false
	obj.set_process(false)
	obj.set_physics_process(false)
