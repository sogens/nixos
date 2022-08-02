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
     programs.dircolors.enable = true;
     programs.gpg.enable = true;
     programs.fzf.enable = true;
     modules.editors.neovim.enable = true;
     modules.editors.vscode.enable = true;
     modules.shell.base.enable = true;
     modules.shell.zsh.enable = true;
     modules.desktop.kitty.enable = true; 

     home.packages = with pkgs; [ fd ripgrep fortune cowsay go luarocks neovim python3 python cargo xclip zplug lf alacritty spotifyd spotify-tui ];
    
     programs.zsh.zplug = {
      enable = true;
      plugins = [
        { name = "zsh-users/zsh-autosuggestions"; }
        { name =  "ohmyzsh/ohmyzsh oh-my-zsh"; }
        { name =  "ajeetdsouza/zoxide"; }
        { name =  "marlonrichert/zsh-autocomplete"; }
        { name =  "marlonrichert/zsh-edit"; }
        { name =  "zsh-users/zsh-autosuggestions"; }
        { name =  "ptavares/zsh-exa"; }
        { name =  "zsh-users/zsh-syntax-highlighting"; }
        { name =  "mbenford/zsh-tmux-auto-title"; }
        { name =  "zsh-users/zsh-history-substring-search"; }
      ];
    };


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
