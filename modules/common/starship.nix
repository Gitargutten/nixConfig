{ config, pkgs, lib, ... }:

{
  programs.starship = {
			enable = true;
			enableZshIntegration = true;
			settings = lib.recursiveUpdate
				(builtins.fromTOML
					(builtins.readFile "${pkgs.starship}/share/starship/presets/catppuccin-powerline.toml"
				))
				{
				format = lib.concatStrings [
				"[](red)"
				"$os"
				"$username"
				"[](bg:peach fg:red)"
				"$directory"
				"[](bg:yellow fg:peach)"
				"$git_branch"
				"$git_status"
				"[](fg:yellow bg:green)"
				"$c"
				"$rust"
				"$golang"
				"$nodejs"
				"$bun"
				"$php"
				"$java"
				"$kotlin"
				"$haskell"
				"$python"
				"[](fg:green bg:lavender)"
				"$time"
				"[ ](fg:lavender)"
				"$cmd_duration"
				"$line_break"
				"$character"
				];

				};
		};
}
