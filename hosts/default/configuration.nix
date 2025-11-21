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
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable bluetooth
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
  };

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
    git
    man-pages
    man-pages-posix
    vim
    brightnessctl
    xfce.mousepad
  ];
  documentation = {
    man.enable = true;
    dev.enable = true;
  };

  # Define a user account.
  users.users.kettroni = {
    isNormalUser = true;
    extraGroups = [
      "wheel"  # Enable ‘sudo’ for the user.
      "audio"
      "video"
      "networkmanager"
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
