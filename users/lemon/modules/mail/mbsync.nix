{ config, ... }: {

    programs.mbsync.enable = true;
    programs.msmtp.enable = true;
    programs.notmuch  = {
      enable = true;
      extraConfig = {
        database = {
          path = "/home/lemon/Maildir/fastmail";
        };
        user = {
          name = "Matthew Lemon";
          primary_email = "matt@matthewlemon.com";
        };
        new = {
          tags = "unread;new";
        };
      };
    };
}
