{ pkgs, ... }:

{
  home = {
    packages = with pkgs; [
      fira-code
    ];
  };

  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Fira Code" ];
      };
    };
  };
}
