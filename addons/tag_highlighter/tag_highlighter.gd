@tool
extends EditorPlugin

var keywords: Dictionary = {
    "@virtual": Color.DEEP_PINK
}

var enabled: bool = false

func _enter_tree() -> void:
    var version = Engine.get_version_info()
    if version.major >= 4 && version.minor >= 4:
        enabled = true
        EditorInterface.get_script_editor().editor_script_changed.connect(on_script_changed)
    else:
        push_warning("[Tag Highlighter] This plugin only works starting 4.4! Please disabled it!")


func _exit_tree() -> void:
    if enabled:
        EditorInterface.get_script_editor().editor_script_changed.disconnect(on_script_changed)


func on_script_changed(_script) -> void:
    var current_script = EditorInterface.get_script_editor().get_current_editor()
    var code_edit: CodeEdit = current_script.get_base_editor()
    for key in keywords.keys():
        code_edit.syntax_highlighter.add_keyword_color(key, keywords[key])
