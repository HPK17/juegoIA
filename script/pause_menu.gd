extends Control

func resume():
	get_tree().paused = false
	if $AnimationPlayer:
		$AnimationPlayer.play_backwards("blur")

func pause():
	get_tree().paused = true
	if $AnimationPlayer:
		$AnimationPlayer.play("blur")

func _input(event):
	if event.is_action_pressed("ui_pause"):
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_resume_pressed():
	resume()

func _on_quit_pressed():
	get_tree().quit()
