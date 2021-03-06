extends Node

signal on_player_life_changed(life, remaining)
signal on_score_increment(amount)
signal on_pause_clicked()
signal on_home_pressed()
signal on_restart_pressed()
signal on_go_back_requested()
signal on_continue_requested()
signal on_continue_cancelled()
signal on_player_died()
signal on_coin_catched()
signal on_gem_catched()
signal on_banner_loaded(dimensions)

signal on_purchase_requested(pack)
