extends Node

signal elements_changed
signal element_acquired(element_id: String)
signal element_removed(element_id: String)
signal combination_performed(result_id: String)

const MAX_ELEMENTS: int = 4

var held_elements: Array[String] = []


func acquire_element(element_id: String) -> bool:
	if held_elements.size() >= MAX_ELEMENTS:
		return false
	held_elements.append(element_id)
	element_acquired.emit(element_id)
	elements_changed.emit()
	return true


func remove_element(element_id: String) -> void:
	var index := held_elements.find(element_id)
	if index >= 0:
		held_elements.remove_at(index)
		element_removed.emit(element_id)
		elements_changed.emit()


func has_element(id: String) -> bool:
	return held_elements.has(id)


func try_combine(element_a: String, element_b: String) -> String:
	if not has_element(element_a) or not has_element(element_b):
		return ""
	# Query ElementDB autoload for a valid combination result
	if not Engine.has_singleton("ElementDB") and not get_node_or_null("/root/ElementDB"):
		return ""
	var element_db := get_node_or_null("/root/ElementDB")
	if element_db == null:
		return ""
	if element_db.has_method("get_combination_result"):
		var result: String = element_db.get_combination_result(element_a, element_b)
		return result
	return ""


func perform_combination(element_a: String, element_b: String) -> void:
	var result := try_combine(element_a, element_b)
	if result.is_empty():
		return
	remove_element(element_a)
	remove_element(element_b)
	held_elements.append(result)
	combination_performed.emit(result)
	elements_changed.emit()


func get_elemental_weights() -> Dictionary:
	var weights: Dictionary = {}
	for element_id in held_elements:
		# Look up base element composition from ElementDB if available
		var element_db := get_node_or_null("/root/ElementDB")
		if element_db != null and element_db.has_method("get_base_elements"):
			var base_elements: Dictionary = element_db.get_base_elements(element_id)
			for base_id in base_elements:
				var w: float = base_elements[base_id]
				weights[base_id] = weights.get(base_id, 0.0) + w
		else:
			# Treat the element itself as a base element with weight 1.0
			weights[element_id] = weights.get(element_id, 0.0) + 1.0
	return weights
