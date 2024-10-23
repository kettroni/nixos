{ lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "nixos";
    wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  services = {
    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    kmonad = {
      enable = true;
      keyboards = {
        myKMonadOutput = {
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd"; # TODO: Change me to default keyboard
          config = builtins.readFile ../../home/keyboard/config.kbd;
        };
      };
    };

    xserver = {
      enable = true;
      windowManager.qtile = {
        enable = true;
      };
    };

    # Auto login
    displayManager.autoLogin = {
      enable = true;
      user = "kettroni";
    };

    # Enable sound
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    # Enable the OpenSSH daemon.
    openssh.enable = true;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    brightnessctl
    xfce.mousepad
  ];

  # Define a user account.
  users.users.kettroni = {
    isNormalUser = true;
    extraGroups = [ 
      "wheel"  # Enable ‘sudo’ for the user.
      "audio"
      "video"
   ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "kettroni" = import ../../home/default.nix;
    };
  };

  system.stateVersion = "24.05"; # Did you read the comment?
}

