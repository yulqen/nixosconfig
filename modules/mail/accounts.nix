{ config, ... }:

let
  signaturePersonal = ''
    Matthew Lemon
  '';
in
{
  # same duplication program here - ref note in programs.nix
  
    accounts.email.accounts = {
      fastmail = {
        address = "matt@matthewlemon.com";
        signature.text = signaturePersonal;
        signature.showSignature = "append";
        primary = true;
        imap.host = "imap.fastmail.com";
        msmtp.enable = true;
        passwordCommand = "echo $(pass AppPasswords/mbsync_fastmail_may2022)";
        realName = "Matthew Lemon";
        smtp = {
          host = "smtp.fastmail.com";
        };
        userName = "mrlemon@mailforce.net";
        mbsync = {
          enable = true;
          create = "maildir";
          expunge = "maildir";
        };
      };
    };
}

  
