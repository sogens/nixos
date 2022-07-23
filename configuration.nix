

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

      ./hardware-configuration.nix
    ];
#####################################################################
    boot.loader.grub.enable = true;
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
   networking.hostName = "nixos";
    networking.networkmanager.enable = true;

    time.timeZone = "Australia/Brisbane";

   i18n.defaultLocale = "en_US.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "us";
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
     extraGroups = [ "wheel" ]; 
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
	neovim
	ibus
	kitty
	curl
	megasync
	git
	protonmail-bridge
	gnome-menus
	libreoffice
     ]; 
   };  
environment.systemPackages = with pkgs; [
    wget vim nano zsh file fish tmux google-chrome neovim ibus kitty curl nvidia-offload gnome-menus discord
];

 
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
  };
};
##################################################################################

###################################################################################
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #   wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  #  started in user sessions.
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

