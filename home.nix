 { config, pkgs, ... }:
{

imports = [ ./modules ];

home.username = "jason";
home.homeDirectory = "/home/jason/";
home.stateVersion = "22.05";
home.sessionVariables.HOSTNAME = "nixos";
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
    };
   };
     programs.home-manager.enable = true;
     modules.editors.neovim.enable = true;
     modules.editors.vscode.enable = true;
     modules.shell.base.enable = true;
     modules.shell.zsh.enable = true;
     modules.desktop.kitty.enable = true;

     home.packages = with pkgs; [ fd ripgrep fortune cowsay go luarocks neovim-nightly python3 python cargo xclip openjdk ];
     
    programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    lfs.enable = true;
    difftastic.enable = true;
    userName = "sogens";
    userEmail = "fischmann.jason@gmail.com";
    extraConfig = {
    	color = {
	ui = "auto";
	init.defaultBranch = "master";
	};
      };
    };
home.language.base = "en_US.UTF-8";
  home.sessionVariables = {
    EDITOR = "nvim";
    TERM = "tmux-256color";
    TERMINAL = "kitty";
  };
}
