

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
       ./pulseeffects.nix
      ./hardware-configuration.nix
    ];
####################################################################
environment.localBinInPath = true;
environment.variables = {
    BROWSER = "google-chrome-stable";
    TERM = "xterm-256color";
    };
 fonts = {
    fontconfig.enable = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    };
 networking.firewall.enable = true;
  services.dbus.enable = true;
#####################################################################
fileSystems."/".options = [ "compress=zstd" "rw" "relatime" "ssd" "space_cache=v2" ];
hardware.cpu.intel.updateMicrocode = true;
services.timesyncd.enable = true;
 programs.java.enable = true;
   hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs.pkgsi686Linux; [ libva ];
  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;
   services.fwupd.enable = true;
     services.smartd = {
    enable = true;
    # Monitor all devices connected to the machine at the time it's being started
    autodetect = true;
    notifications = {
      x11.enable = if config.services.xserver.enable then true else false;
      wall.enable = true; # send wall notifications to all users
    };
  };
#####################################################################

nix = {
    trustedUsers = [ "root" "farlion" "@wheel" "@sudo" ];
       binaryCachePublicKeys = [
      "workflow.cachix.org-1:HhfBXgXCafJxYuATcMDQbC1qsbjF9qJUCchzFZS2zL4="
      "jupyterwith.cachix.org-1:/kDy2B6YEhXGJuNguG1qyqIodMyO4w8KwWH4/vAc7CI="
      "crazazy.cachix.org-1:3KaIHK26pkvd5palJH5A4Re1Hn2+GDV+aXYnftMYAm4=" # my own cache
      "emacsng.cachix.org-1:i7wOr4YpdRpWWtShI8bT6V7lOTnPeI7Ho6HaZegFWMI=" # emacs-ng cache
      "ethancedwards8.cachix.org-1:YMasjqyFnDreRQ9GXmnPIshT3tYyFHE2lUiNhbyIxOc=" # guix cache (for testing)
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" # mostly emacs-overlay
      "nrdxp.cachix.org-1:Fc5PSqY2Jm1TrWfm88l6cvGWwz3s93c6IOifQWnhNW4=" # flake shit
      "rycee.cachix.org-1:TiiXyeSk0iRlzlys4c7HiXLkP3idRf20oQ/roEUAh/A=" # for updating my firefox plugins
    ];
    binaryCaches = [
      "https://cache.nixos.org/"
      "https://workflow.cachix.org/"
      "https://jupyterwith.cachix.org/"
       "https://crazazy.cachix.org"
      "https://emacsng.cachix.org"
      "https://ethancedwards8.cachix.org"
      "https://nix-community.cachix.org"
      "https://nrdxp.cachix.org"
      "https://rycee.cachix.org"
    ];
};

#####################################################################
    boot.loader.grub.enable = true;
    boot.plymouth.enable = true;
    boot.cleanTmpDir = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.version = 2;
    boot.loader.grub.device = "nodev";
    boot.loader.grub.efiSupport = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
    boot.loader.grub.extraEntries = '' menuentry "Gentoo GNU/Linux, with Linux 5.15.52-gentoo-x86_64" --class gentoo --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.15.52-gentoo-x86_64-advanced-8658753b-fbb8-4ee6-b963-a0251970d709' {
		load_video
		if [ "x$grub_platform" = xefi ]; then
			set gfxpayload=keep
		fi
		insmod gzio
		insmod part_gpt
		insmod btrfs
		search --no-floppy --fs-uuid --set=root 639dfb3c-fab8-4470-a3b5-0664ffc6f8d6
		echo	'Loading Linux 5.15.52-gentoo-x86_64 ...'
		linux	/vmlinuz-5.15.52-gentoo-x86_64 root=UUID=8658753b-fbb8-4ee6-b963-a0251970d709 ro rootflags=subvol=@ crypt_root=UUID=5fc1f740-6266-45df-8894-718d388ddcc6 real_root=UUID=8658753b-fbb8-4ee6-b963-a0251970d709 rootflags=subvol=@ rootfstype=btrfs dobtrfs quiet 
		echo	'Loading initial ramdisk ...'
		initrd	/early_ucode.cpio /initramfs-5.15.52-gentoo-x86_64.img
}'';
######################################################################

i18n.inputMethod = {
  enabled = "ibus";
  ibus.engines = with pkgs.ibus-engines; [ anthy hangul mozc ];
 };

nixpkgs.config.permittedInsecurePackages = [
                "electron-9.4.4"
              ];

######################################################################

 security.polkit.enable = true;
 xdg.portal.extraPortals = [pkgs.xdg-desktop-portal-wlr];
 # services.xserver.displayManager.autoLogin.enable = true;
 # services.xserver.displayManager.autoLogin.user = "jason";

######################################################################
   networking.hostName = "nixos";
   networking.hostId = "4e13cd4c";
    networking.networkmanager.enable = true;

    time.timeZone = "Australia/Brisbane";

   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
   };
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };
nixpkgs.config = {
    allowUnfree = true;
    # more stuff
  };
#####################################
services.xserver.videoDrivers = [ "nvidia" ];
hardware.opengl.enable = true;
hardware.nvidia = {
      modesetting.enable = true;
      prime = {
        sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  specialisation = {
    external-display.configuration = {
      system.nixos.tags = [ "external-display" ];
    };
  };
############################################
  programs.fish.enable = true;

  users.users.jason = {   
     
    shell = pkgs.fish;
   
  };  

###########################################
services.flatpak.enable = true;
xdg.portal.enable = true;

############################################
   virtualisation.virtualbox.host.enable = true;
   users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

############################################

nix = {
   package = pkgs.nixFlakes;

extraOptions = "experimental-features = nix-command flakes";
};
############################################
 sound.enable = true;
 services.xserver.libinput.enable = true;
 services.gvfs.enable = true;
  services.tumbler.enable = true;
   users.users.jason = {
     isNormalUser = true;
     extraGroups = [ "wheel" "video" "audio" "disk" "networkmanager" ]; 
     packages = with pkgs; [
       firefox
       thunderbird
	google-chrome
        spotify
	vscode
	vim
	nano
	zsh
	file
	fish
	tmux
	kitty
	curl
	megasync
	protonmail-bridge
	libreoffice
	authy
     ]; 
   };  
environment.systemPackages = with pkgs; [
    wget vim nano zsh file fish tmux google-chrome kitty curl nvidia-offload gnome-menus discord nodejs openjdk sqlite  stack haskell-language-server nushell nixpkgs-lint nixpkgs-fmt 
    nixfmt emacs notify-desktop nnn nq fff trash-cli fzf surf unclutter gtk3-x11 gtk3 zlib php phpPackages.composer clang-tools gnumake binutils automake pciutils lm_sensors p7zip
    unzip zip tor-browser-bundle-bin gnome.gnome-tweaks gparted pulseeffects-legacy gnomeExtensions.sound-output-device-chooser gnomeExtensions.dash-to-dock-for-cosmic gcc
];

system.autoUpgrade.enable = true; 
##################################################################################
services.xserver.displayManager.gdm.enable = true;
services.xserver.desktopManager.gnome.enable = true;
environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  cheese # webcam tool
  gnome-music
  gnome-terminal
  gedit # text editor
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
]);
services.xserver.enable = true;
##################################################################################

hardware = {
  pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    daemon.config = {
    default-sample-rate = 48000;
    };
  };
};
##################################################################################
networking.enableIPv6 = false;
programs.nix-ld.enable = true;
security.sudo.wheelNeedsPassword = false;
services.locate.enable = true;

###################################################################################

    programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;



  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}

