class_name Filer

var filePath
var file: File

func _init(path: String) -> void:
	filePath = path
	file = File.new()


func exists() -> bool:
	return file.file_exists(filePath)


func read() -> Dictionary:
	file.open(filePath, File.READ)
	var data = file.get_var()
	file.close()
	
	return data


func readStr() -> String:
	file.open(filePath, File.READ)
	var value = file.get_as_text()
	file.close()
	
	return value


func save(value) -> void:
	file.open(filePath, File.WRITE)
	file.store_var(value)
	file.close()
