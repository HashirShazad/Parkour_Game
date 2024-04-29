extends Resource
class_name User_Preferences


# Variables <===========================================================================================>
@export var action_events: Dictionary = {
}
@export var saved_level:String
@export var points:int
@export var resolution:Vector2i
var window_mode:int

# Actual Code <===========================================================================================>

# Saves as file
func save() -> void:
	ResourceSaver.save(self, "user://user_prefs.tres")
# Loads or creates
static func load_or_create() -> User_Preferences:
	var res: User_Preferences = load("user://user_prefs.tres") as User_Preferences
	if !res:
		res = User_Preferences.new()
	return res
