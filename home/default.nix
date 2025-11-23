{ pkgs, ... }: let
  username = "kettroni";
in {
  imports = [
    ./alacritty.nix
    ./emacs
    ./fonts.nix
    ./keyboard
    ./qtile
    ./git.nix
  ];

  services.picom = {
    enable = true;
    opacityRules = [
      "85:class_g = 'Alacritty'"
      "85:class_g = 'Emacs'"
      "95:class_g = 'Chromium-browser'"
    ];

    # It is often helpful to set a specific backend that works well with your system
    backend = "glx";
  };

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
