{ pkgs, ... }: let
  username = "kettroni";
in {
  imports = [
    ./emacs.nix
    ./fonts.nix
    ./keyboard.nix
  ];

  home = {
    stateVersion = "24.05"; # Don't change!

    inherit username;
    homeDirectory = "/home/${username}";

    packages = with pkgs; [
      alacritty
      chromium
      git
    ];
  };


  
  xsession = {
    enable = true;
  };

  programs.home-manager.enable = true;
}
