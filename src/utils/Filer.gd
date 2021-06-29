class_name Filer

var filePath
var file: File

func _init(path: String, default: Dictionary) -> void:
	filePath = path
	
	file = File.new()
	if not file.file_exists(path) and not default == null:
		file.open(path, File.WRITE)
		file.store_var(default)
		file.close()


func read() -> Dictionary:
	file.open(filePath, File.READ)
	var data = file.get_var()
	file.close()
	
	return data


func save(value) -> void:
	file.open(filePath, File.WRITE)
	file.store_var(value)
	file.close()
