{ pkgs, ... }:

{
  home.file = {
    bg = {
      source = ./background.png;
      target = ".config/qtile/background.png";
    };
    qtile_config = {
      source = ./config.py;
      target = ".config/qtile/config.py";
    };
  };
}
