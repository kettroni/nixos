{ pkgs, ... }:

{
  home.file.qtile_config = {
    source = ./config.py;
    target = ".config/qtile/config.py";
  };
}
