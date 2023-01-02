{ config, ... }:

let
  signaturePersonal = ''
    --
    Matthew Lemon
  '';
in
{
  # same duplication program here - ref note in programs.nix
  
  home-manager.users.lemon = { pkgs, ... }: {
    accounts.email.accounts = {
      fastmail = {
        address = "matt@matthewlemon.com";
        signature.text = signaturePersonal;
        primary = true;
        imap.host = "imap.fastmail.com";
        msmtp.enable = true;
        notmuch.enable = true;
        passwordCommand = "echo $(pass AppPasswords/mbsync_fastmail_may2022)";
        realName = "Matthew Lemon";
        smtp = {
          host = "smtp.fastmail.com";
        };
        userName = "mrlemon@mailforce.net";
        neomutt = {
          enable = true;
        };
        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "maildir";
        };
      };
    };
  };
}

  
