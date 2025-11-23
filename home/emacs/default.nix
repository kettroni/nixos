{ pkgs, inputs, ... }: let
  cfg-path = ".config/emacs/";
in {

  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];

  home.packages = [
    pkgs.nerd-fonts.symbols-only
    (pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      package = pkgs.emacs-git;
    })
    pkgs.fd
    pkgs.unzip
  ];

  home.file = {
    "${cfg-path}init.el" = {
      source = ./init.el;
    };
    "${cfg-path}elisp" = {
      source = ./elisp;
      recursive = true;
    };
    "${cfg-path}themes" = {
      source = ./themes;
      recursive = true;
    };
  };
}
