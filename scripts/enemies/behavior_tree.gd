class_name BehaviorTree
extends Node

enum Status { SUCCESS, FAILURE, RUNNING }


class BTNode:
	var children: Array[BTNode] = []

	func tick(_actor: Node, _delta: float) -> Status:
		return Status.FAILURE

	func add_child_node(child: BTNode) -> BTNode:
		children.append(child)
		return self


class BTSelector:
	extends BTNode

	## Tries children in order, returns the first non-FAILURE result.
	func tick(actor: Node, delta: float) -> Status:
		for child: BTNode in children:
			var result: Status = child.tick(actor, delta)
			if result != Status.FAILURE:
				return result
		return Status.FAILURE


class BTSequence:
	extends BTNode

	## Runs children in order, fails on first non-SUCCESS result.
	func tick(actor: Node, delta: float) -> Status:
		for child: BTNode in children:
			var result: Status = child.tick(actor, delta)
			if result != Status.SUCCESS:
				return result
		return Status.SUCCESS
