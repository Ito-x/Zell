extends Node2D
## Outil de capture d'écran one-shot, utilisé par le skill `lancer-godot`.
##
## Usage :
##   <godot> --path <projet> res://tools/capture.tscn -- <scene_cible> [chemin_png]
##
## Instancie la scène cible (qui amène sa propre caméra), laisse le moteur
## dessiner quelques frames, sauvegarde un PNG, puis quitte. Claude lit ensuite
## le PNG pour « voir » ce que donnerait un F5.

func _ready() -> void:
	var args := OS.get_cmdline_user_args()
	var target := "res://scenes/world/LesYeux.tscn"
	var out := "res://.capture.png"
	if args.size() >= 1 and args[0] != "":
		target = args[0]
	if args.size() >= 2 and args[1] != "":
		out = args[1]

	var packed := load(target) as PackedScene
	if packed == null:
		push_error("capture: scène introuvable: %s" % target)
		get_tree().quit(1)
		return
	add_child(packed.instantiate())

	# Laisse rendre quelques frames (caméra qui se pose, shaders animés…).
	for _i in 90:
		await get_tree().process_frame
	await RenderingServer.frame_post_draw

	var img := get_viewport().get_texture().get_image()
	var err := img.save_png(out)
	if err == OK:
		print("CAPTURE_OK %s" % ProjectSettings.globalize_path(out))
	else:
		push_error("capture: échec save_png (code %d)" % err)
	get_tree().quit(0 if err == OK else 1)
