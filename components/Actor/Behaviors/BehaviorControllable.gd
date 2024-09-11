class_name BehaviorControllable
extends Behavior


func initialize(_target: Variant) -> void:
    super(_target)


func execute_process(delta: float) -> void:
    super(delta)
    if target == Global.selected_actor:
        var direction: Vector2 = Vector2.ZERO
        # NOTE: Consider passing input StringNames as initialization
        #       arguments.
        direction.x = Input.get_axis(&"move_left", &"move_right")
        direction.y = Input.get_axis(&"move_up", &"move_down")
        
        target.direction = direction


func destroy() -> void:
    super()
