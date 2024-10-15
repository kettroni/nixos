{ pkgs, ... }:

{
  programs = {
    alacritty = {
      enable = true;
    };
    bash = {
      enable = true;
      shellAliases = {
        sw = "sudo nixos-rebuild switch --flake /etc/nixos#default";
        eh = "sudo vim /etc/nixos/home";
        eq = "sudo vim /etc/nixos/home/qtile/config.py";
        en = "sudo vim /etc/nixos/hosts/default/configuration.nix";
	cn = "cd /etc/nixos";
	ga = "sudo git add .";
        gs = "sudo git status";
        gd = "sudo git diff";
      };
    };
  };
}
