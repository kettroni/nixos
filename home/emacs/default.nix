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
    "${cfg-path}auto-recompile/auto-recompile.el" = {
      source = ./auto-recompile/auto-recompile.el;
    };
    "${cfg-path}themes/gruber-darker-theme.el" = {
      source = ./gruber-darker/gruber-darker-theme.el;
    };
  };
}
