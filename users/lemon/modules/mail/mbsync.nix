{ config, ... }: {

  home-manager.users.lemon = {
    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    };
}
