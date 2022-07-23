 { config, pkgs, ... }:
{
home.username = "jason";
home.homeDirectory = "/home/jason/";
home.stateVersion = "22.05";
  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      enableExtraSocket = true;
    };
   };
     programs.home-manager.enable = true;
     home.packages = [  ];

    programs.git = {
    package = pkgs.gitAndTools.gitFull;
    enable = true;
    userName = "sogens";
    userEmail = "fischmann.jason@gmail.com";
    };
}
