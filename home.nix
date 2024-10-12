{ config, pkgs, ... }:

{
  home = {
    username = "kettroni";
    homeDirectory = "/home/kettroni";
    stateVersion = "24.05"; # Don't change!
    packages = with pkgs; [
      emacs
      fira-code
      rofi
      nitrogen
      alacritty
      chromium
      git
      picom
    ];

    keyboard = {
      layout = "fi";
      options = [
        "ctrl:nocaps"
        "ctrl:swap_lwin_lctl"
        "ctrl:swap_rwin_rctl"
      ];
    };

    file = {
    };
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Fira Code" ];
      };
    };
  };
  
  xsession = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
