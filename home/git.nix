{ pkgs, ... }:

{
  programs.git = {
    enable = true;
    settings.user = {
      email = "ronikettunen96@gmail.com";
      name = "kettroni";
    };
  };
}
