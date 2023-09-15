#!/usr/bin/env zsh

#initializin Wallpaper Daemon & Wallpaper
	swww init &
	swww img ~/Bilder/Wallpaper/wp13.jpg &

# Applet
	nm-applet --indicator &

#TopBar
	waybar &
	dunst

