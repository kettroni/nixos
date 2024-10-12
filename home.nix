{ config, pkgs, ... }:

{
  home = {
    username = "kettroni";
    homeDirectory = "/home/kettroni";
    stateVersion = "24.05"; # Don't change!
    packages = with pkgs; [
      emacs
      rofi
      nitrogen
      alacritty
      chromium
      git
      picom
    ];

    file = {
    };

    sessionVariables = {
      EDITOR = "emacs";
    };
  };

  programs.home-manager.enable = true;
}
