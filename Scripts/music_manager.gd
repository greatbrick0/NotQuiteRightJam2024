extends Node

var prevTrackIndex: int = 0
var currentTrackIndex: int = 0
var timeSinceTrackChange: float = 0.0

func _process(delta):
	timeSinceTrackChange += 1.0 * delta

func ChangeTrack(newTrack: int) -> void:
	timeSinceTrackChange = 0
	prevTrackIndex = currentTrackIndex
	currentTrackIndex = newTrack
