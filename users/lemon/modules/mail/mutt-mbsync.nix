{ config, ... }: {

  home-manager.users.lemon = {
    programs.neomutt = {
      enable = true;
      vimKeys = true;
    };
    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    programs.notmuch = {
      enable = true;
      hooks = {
        preNew = "mbsync --all";
      };
    };
  };
}
