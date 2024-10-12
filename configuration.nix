{ lib, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Set your time zone.
  time.timeZone = "Europe/Helsinki";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "fi";
  services.xserver.xkb.options = "ctrl:nocaps, ctrl:swap_lwin_lctl, ctrl:swap_rwin_rctl";
  services.xserver.windowManager.qtile.enable = true;
  services.displayManager.autoLogin = {
    enable = true;
    user = "kettroni";
  };

  # Enable bluetooth
  hardware.bluetooth.enable = true;

  # Enable sound.
  #sound.enable = true;
  #hardware.pulseaudio.enable = true;
  # boot.extraModprobeConfig = ''
  #   options snd slots=snd-hda-intel
  # '';
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kettroni = {
    isNormalUser = true;
    extraGroups = [ 
        "wheel"
        "audio"
        "video"
   ]; # Enable ‘sudo’ for the user.
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    brightnessctl
    alacritty
    chromium
    git
    picom
    rofi
    nitrogen
    xfce.mousepad
  ];

  programs.thunar.enable = true;

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "kettroni" = import ./home.nix;
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.05"; # Did you read the comment?

}

