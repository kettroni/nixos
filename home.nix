{ config, pkgs, ... }:

{
  home = {
    username = "kettroni";
    homeDirectory = "/home/kettroni";
    stateVersion = "24.05"; # Don't change!
    packages = [
      (pkgs.nerdfonts.override { fonts = [ "FiraCode" ]; })
      pkgs.emacs
    ];

    file = {
    };

    sessionVariables = {
      EDITOR = "emacs";
    };
  };

  programs.home-manager.enable = true;
}
