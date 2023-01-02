{ config, ... }: {

  home-manager.users.lemon = {
    programs.neomutt = {
      enable = true;
      vimKeys = true;
      sort = "threads";
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
