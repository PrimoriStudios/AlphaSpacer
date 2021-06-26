class_name Filer

var filePath

func _init(path: String, default = null) -> void:
	filePath = path
	
	var file = File.new()
	if not file.file_exists(path) and not default == null:
		file.open(path, File.WRITE_READ)
		file.store_var(default)
		file.flush()


func read():
	var file = File.new()
	file.open(filePath, File.READ)
	var data = file.get_var()
	file.close()
	
	return data


func save(value) -> void:
	var file = File.new()
	file.open(filePath, File.WRITE)
	file.store_var(value)
	file.close()
