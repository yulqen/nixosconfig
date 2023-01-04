{ config, pkgs, lib, ... }:

let
  signaturePersonal = ''

    ---
    Matthew Lemon
  '';
  signatureYulqen = ''

    ---
    Matthew Lemon
  '';
  fastmail-source = "maildir://~/Maildir/fastmail";
  fastmail-outgoing = "smtps+plain://mrlemon%40mailforce.net@smtp.fastmail.com:465";
  fastmail-cred-cmd = "echo $(pass AppPasswords/mbsync_fastmail_may2022)";
  fastmail-copy-to = "Sent";
in
{
    programs.abook.enable = true;
    programs.aerc = {
      enable = true;
      extraAccounts = {
        fastmail = {
          enable-folders-sort = true;
          folders-sort = "Inbox,Sent,Archive";
          default = "Inbox";
          aliases = "y@yulqen.org";
          source = fastmail-source;
          outgoing = fastmail-outgoing;
          outgoing-cred-cmd = fastmail-cred-cmd;
          copy-to = fastmail-copy-to;
          from = "Matthew Lemon <matt@matthewlemon.com>";
          signature-file = toString (pkgs.writeText "signature-matt-fastmail" signaturePersonal);
        };
        notmuch = {
          source = "notmuch://~/Maildir/fastmail/";
          outgoing = fastmail-outgoing;          
          from = "Matthew Lemon <matt@matthewlemon.com>";          
        };
      };
      extraConfig = {
        viewer = {
          header-layout = "To,From,cc,Subject";
        };
        compose = {
          editor = "vim";
          header-layout = "To,From,cc,Subject";
          address-book-cmd = "sh -c 'abook --datafile /home/lemon/Documents/sync/.abook/addressbook --mutt-query \"%s\" | tail -n +2'";
        };
        filters = {
          "subject,~^\\[PATCH" = "awk -f ${pkgs.aerc}/share/aerc/filters/hldiff";          
          "text/plain" = "awk -f ${pkgs.aerc}/share/aerc/filters/colorize";
          "text/html" = "html";
        };
        general = {
          unsafe-accounts-conf = true;
          pgp-provider = "gpg";
        };
      };
      extraBinds = ''
        <C-p> = :prev-tab<Enter>
        <C-n> = :next-tab<Enter>
        <C-t> = :term<Enter>
        ? = :help keys<Enter>

        [messages]
        q = :quit<Enter>
        o = :exec ${./mail-sync.sh}<Enter>;

        j = :next<Enter>
        <Down> = :next<Enter>
        <C-d> = :next 50%<Enter>
        <C-f> = :next 100%<Enter>
        <PgDn> = :next 100%<Enter>

        k = :prev<Enter>
        <Up> = :prev<Enter>
        <C-u> = :prev 50%<Enter>
        <C-b> = :prev 100%<Enter>
        <PgUp> = :prev 100%<Enter>
        g = :select 0<Enter>
        G = :select -1<Enter>

        J = :next-folder<Enter>
        K = :prev-folder<Enter>
        H = :collapse-folder<Enter>
        L = :expand-folder<Enter>

        v = :mark -t<Enter>
        V = :mark -v<Enter>

        T = :toggle-threads<Enter>

        <Enter> = :view<Enter>
        d = :prompt 'Really delete this message?' 'delete-message'<Enter>
        D = :delete<Enter>
        A = :archive flat<Enter>

        C = :compose<Enter>

        rr = :reply -a<Enter>
        rq = :reply -aq<Enter>
        Rr = :reply<Enter>
        Rq = :reply -q<Enter>

        c = :cf<space>
        $ = :term<space>
        ! = :term<space>
        | = :pipe<space>

        / = :search<space>
        \ = :filter<space>
        n = :next-result<Enter>
        N = :prev-result<Enter>
        <Esc> = :clear<Enter>

        [messages:folder=Drafts]
        <Enter> = :recall<Enter>

        [view]
        / = :toggle-key-passthrough<Enter>/
        q = :close<Enter>
        O = :open<Enter>
        S = :save<space>
        | = :pipe<space>
        D = :delete<Enter>
        A = :archive flat<Enter>

       <C-l> = :open-link <space>

       f = :forward<Enter>
       rr = :reply -a<Enter>
       rq = :reply -aq<Enter>
       Rr = :reply<Enter>
       Rq = :reply -q<Enter>

       H = :toggle-headers<Enter>
       <C-k> = :prev-part<Enter>
       <C-j> = :next-part<Enter>
       J = :next<Enter>
       K = :prev<Enter>

       [view::passthrough]
       $noinherit = true
       $ex = <C-x>
       <Esc> = :toggle-key-passthrough<Enter>

       [compose]
       # Keybindings used when the embedded terminal is not selected in the compose
       # view
       $noinherit = true
       $ex = <C-x>
       <C-k> = :prev-field<Enter>
       <C-j> = :next-field<Enter>
       <A-p> = :switch-account -p<Enter>
       <A-n> = :switch-account -n<Enter>
       <tab> = :next-field<Enter>
       <backtab> = :prev-field<Enter>
       <C-p> = :prev-tab<Enter>
       <C-n> = :next-tab<Enter>

       [compose::editor]
       # Keybindings used when the embedded terminal is selected in the compose view
       $noinherit = true
       $ex = <C-x>
       <C-k> = :prev-field<Enter>
       <C-j> = :next-field<Enter>
       <C-p> = :prev-tab<Enter>
       <C-n> = :next-tab<Enter>

       [compose::review]
       # Keybindings used when reviewing a message to be sent
       y = :send<Enter>
       n = :abort<Enter>
       v = :preview<Enter>
       p = :postpone<Enter>
       q = :choose -o d discard abort -o p postpone postpone<Enter>
       e = :edit<Enter>
       a = :attach<space>
       d = :detach<space>

       [terminal]
       $noinherit = true
       $ex = <C-x>

       <C-p> = :prev-tab<Enter>
       <C-n> = :next-tab<Enter>
        '';     
    };
}
