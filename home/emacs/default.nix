{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
  home.packages = [
    pkgs.nerd-fonts.symbols-only
    (pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      package = pkgs.emacs-git;  # replace with pkgs.emacsPgtk, or another version if desired.
    })
    pkgs.fd
    pkgs.unzip
  ];
  
  home.file.".config/emacs/init.el" = {
    source = ./init.el;
  };
  
  home.file = {
    ".config/emacs/auto-recompile/auto-recompile.el" = {
      source = ./auto-recompile/auto-recompile.el;
    };
  };
}
