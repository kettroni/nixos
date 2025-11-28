{ lib, pkgs, inputs, ... }:

{
  imports =
    [
      ../common
      ../laptop/hardware-configuration.nix # TODO change when using other device
    ];

  console.useXkbConfig = true;

  services = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    xserver = {
      enable = true;
      windowManager = {
        backend = "wayland";
        qtile = {
          enable = true;
        };
      };
    };

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
