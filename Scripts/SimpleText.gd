tool
extends RichTextLabel

export(String) var Text

func _ready():
	add_text(Text)
	pass