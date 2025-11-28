{ lib, pkgs, inputs, ... }:

{
  imports =
    [
      ../common
      ./hardware-configuration.nix
    ];

  services = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    kmonad = {
      enable = true;
      keyboards = {
        myKMonadOutput = {
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = builtins.readFile ../../home/keyboard/config.kbd;
        };
      };
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}
