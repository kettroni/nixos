{ pkgs, inputs, ... }:

{
  nixpkgs.overlays = [ (import inputs.emacs-overlay) ];
  home.packages = [
    (pkgs.nerdfonts.override {fonts = ["NerdFontsSymbolsOnly"];})
    (pkgs.emacsWithPackagesFromUsePackage {
      config = ./init.el;
      defaultInitFile = true;
      alwaysEnsure = true;
      package = pkgs.emacs-git;  # replace with pkgs.emacsPgtk, or another version if desired.
    })
    pkgs.fd
  ];
  
  home.file.".config/emacs/init.el" = {
    source = ./init.el;
  };
  
  home.file.".config/emacs/current-window-only/current-window-only.el" = {
    source = ./current-window-only/current-window-only.el;
  };
}
