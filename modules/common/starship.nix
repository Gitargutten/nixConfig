{ config, pkgs, lib, ... }:

{
  programs.starship = {
			enable = true;
			enableZshIntegration = true;
			settings = lib.mkMerge [
				(builtins.fromTOML
					(builtins.readFile "${pkgs.starship}/share/starship/presets/catppuccin-powerline.toml"
				))
				{
					# palette = lib.mkForce "catppuccin_latte";
				}
			];
		};
}
