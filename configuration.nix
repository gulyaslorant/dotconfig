# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{


  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
	<home-manager/nixos>
];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.loader.grub.useOSProber = true;

# Use latest Kernel Version
boot.kernelPackages = pkgs.linuxPackages_latest;
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-db1af10f-b2b5-41c8-8bf2-f690f225947b".device = "/dev/disk/by-uuid/db1af10f-b2b5-41c8-8bf2-f690f225947b";
  boot.initrd.luks.devices."luks-db1af10f-b2b5-41c8-8bf2-f690f225947b".keyFile = "/crypto_keyfile.bin";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.hostName = "Nixgulasch"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable Bluetooth
   hardware.bluetooth.enable = true;
   services.blueman.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n.defaultLocale = "de_AT.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_AT.UTF-8";
    LC_IDENTIFICATION = "de_AT.UTF-8";
    LC_MEASUREMENT = "de_AT.UTF-8";
    LC_MONETARY = "de_AT.UTF-8";
    LC_NAME = "de_AT.UTF-8";
    LC_NUMERIC = "de_AT.UTF-8";
    LC_PAPER = "de_AT.UTF-8";
    LC_TELEPHONE = "de_AT.UTF-8";
    LC_TIME = "de_AT.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "at";
    xkbVariant = "";
    displayManager.gdm.enable = true;
 };



  # Enable the GNOME Desktop Environment.
#  services.xserver.desktopManager.gnome.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowInsecure = true;
  nixpkgs.config.PermittedInsecurePackages = [
	"python-2.7.18.6"
	];

#Allow Flatpak
services.flatpak.enable = true;

#Allow Zsh
programs.zsh.enable = true;
users.defaultUserShell = pkgs.zsh;
environment.shells = with pkgs; [ zsh ];
environment.binsh = "${pkgs.zsh}/bin/zsh";


#Activate Hyprland
programs.hyprland = {
	enable = true;	
};

programs.hyprland.xwayland = {
	hidpi = true;
	enable = true;
};

# Tor Netzwerk
services.tor = {
  enable = true;
  openFirewall = true;
  relay = {
    enable = true;
    role = "relay";
  };
  settings = {
    ContactInfo = "info@photog.com";
    Nickname = "PhotoG";
    ORPort = 9001;
    ControlPort = 9051;
    BandWidthRate = "1 MBytes";
  };
};

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lorant = {
    isNormalUser = true;
    description = "Lorant Gulyas";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      
    #  thunderbird
    ];
  };
  
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
 	vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
 	wget
	btop
	curl
	zsh
	kitty
	alacritty
	firefox-wayland
	neofetch
      	vscode
      	git
      	tor-browser-bundle-bin
	hyprland
	meson
	dunst
	swww
	networkmanagerapplet
	wofi
	waybar
	xwayland
	xdg-desktop-portal-hyprland
	xdg-desktop-portal-gtk
	xdg-utils
	grim
	swappy
	slurp
	pcmanfm
	darktable
	krita	
	eww-wayland
	brightnessctl
];
fonts.fontDir.enable= true;
fonts.fonts = with pkgs; [
	nerdfonts
	font-awesome
	google-fonts
 noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  liberation_ttf
  fira-code
  fira-code-symbols
  mplus-outline-fonts.githubRelease
  dina-font
  proggyfonts
	];
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.


  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
     enableSSHSupport = true;
   };
  xdg.portal = {
	enable = true;
	extraPortals = [
	pkgs.xdg-desktop-portal-gtk
	];
    };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

	nixpkgs.overlays = [
	(self: super: {
	waybar = super.waybar.overrideAttrs (oldAttrs: {
	mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
	});
	})
	];
}
