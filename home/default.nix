{ pkgs, ... }: let
  username = "kettroni";
in {
  imports = [
    ./alacritty.nix
    ./emacs
    ./fonts.nix
    ./keyboard.nix
    ./qtile
    ./git.nix
  ];

  home = {
    stateVersion = "24.05"; # Don't change!

    inherit username;
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      chromium
      feh
    ];
  };
  
  xsession = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
