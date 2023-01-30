{ config, pkgs, ... }: {
  xdg = {
    desktopEntries = {
      neomutt = {
        name = "Neomutt";
        genericName = "Email Client";
        comment = "Read and send emails";
        exec = "neomutt %U";
        icon = "mutt";
        terminal = true;
        categories = [ "Network" "Email" "ConsoleOnly" ];
        type = "Application";
        mimeType = [ "x-scheme-handler/mailto" ];
      };
    };
    mimeApps.defaultApplications = {
      "x-scheme-handler/mailto" = "neomutt.desktop";
    };
  };

  programs.neomutt = {
    enable = true;
    vimKeys = true;
    sidebar = {
      enable = true;
      width = 30;
    };
    macros = [
      {
        action = "<shell-escape>clear && ${./mail-sync.sh}<enter>";
        key = "O";
        map = [ "index" "pager" ];
      }
    ];
    extraConfig = ''
# Allow forwarding of attachments with emails
set mime_forward
set mime_forward_rest

# Basic Options --------------------------------------
set wait_key = no        # shut up, mutt
set mbox_type = Maildir  # mailbox type
set timeout = 3          # idle time before scanning
set mail_check = 0       # minimum time between scans
#unset move               # gmail does that
set delete               # don't ask, just do
unset confirmappend      # don't ask, just do!
set quit                 # don't ask, just do!!
unset mark_old           # read/new is good enough for me
#set beep_new             # bell on new mails
set pipe_decode          # strip headers and eval mimes when piping
set thorough_search      # strip headers and eval mimes before searching

# nicer text
set text_flowed=yes

set mail_check_stats

# Status Bar -----------------------------------------
set status_chars  = " *%A"
set status_format = "───[ Folder: %f ]───[%r%m messages%?n? (%n new)?%?d? (%d to delete)?%?t? (%t tagged)? ]───%>─%?p?( %p postponed )?───"

# Header Options -------------------------------------
ignore *                                # ignore all headers
unignore from: to: cc: date: bcc: subject:   # show only these
unhdr_order *                           # some distros order things by default
hdr_order from: to: cc: bcc: date: subject:  # and in this order

# Default inbox.
set spoolfile = "+Inbox"

# groups
alternates -group me '^matt@matthewlemon.com$' '^matthew.lemon@gmail.com$' '^matthew.lemon104@mod.gov.uk$'

# Other special folders.
set mbox      = "+Archive"
set postponed = "+Drafts"

# Index View Options ---------------------------------
set date_format = "%d-%m-%Y %H:%M "
set index_format = "%4C [%Z] %B %D %-20.20F %s"
set sort = threads                         # like gmail
set sort_aux = reverse-last-date-received  # like gmail
set uncollapse_jump                        # don't collapse on an unread message
set sort_re                                # thread based on regex
set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"

# Folder Shortcuts
macro index Ei '<change-folder>+Inbox<enter>' 'Go to Inbox'
macro index Ea '<change-folder>+Archive<enter>' 'Go to Archive'
macro index Es '<change-folder>+Sent<enter>' 'Go to Sent Mail'

# Navigate threads
bind index { previous-thread
bind pager { half-up
bind index } next-thread
bind pager } half-down

bind index R        group-reply
bind index <tab>    sync-mailbox
bind index <space>  collapse-thread

# Email the sender (not a reply)
bind index,pager @ compose-to-sender


# toggle new
bind index \Cn toggle-new

# Ctrl-R to mark all as read
macro index \Cr "T~U<enter><tag-prefix><clear-flag>N<untag-pattern>.<enter>" "mark all messages as read"

# Saner copy/move dialogs
macro index C "<copy-message>?<toggle-mailboxes>" "copy a message to a mailbox"
macro index M "<save-message>?<toggle-mailboxes>" "move a message to a mailbox"

# Sidebar Navigation ---------------------------------
bind index,pager <down>   sidebar-next
bind index,pager <up>     sidebar-prev
bind index,pager <right>  sidebar-open

# Pager View Options ---------------------------------
set pager_index_lines = 10 # number of index lines to show
set pager_context = 3      # number of context lines to show
set pager_stop             # don't go to next message automatically
set menu_scroll            # scroll in menus
set tilde                  # show tildes like in vim
unset markers              # no ugly plus signs

set quote_regexp = "^( {0,4}[>|:#%]| {0,4}[a-z0-9]+[>|]+)+"
alternative_order text/plain text/enriched text/html

# Pager Key Bindings ---------------------------------
bind pager k  previous-line
bind pager j  next-line
#bind pager gg top
bind pager G  bottom
bind pager R  group-reply

# Compose View Options -------------------------------
set realname = "Matthew Lemon"       # who am i?
set envelope_from                    # which from?
set sig_dashes                       # dashes before sig
set edit_headers                     # show headers when composing
set fast_reply                       # skip to compose when replying
set askcc                            # ask for CC:
set fcc_attach                       # save attachments with the body
unset mime_forward                   # forward attachments as part of body
set forward_format = "Fwd: %s"       # format of subject when forwarding
set forward_decode                   # decode when forwarding
set attribution = "On %d, %n wrote:" # format of quoting header
set reply_to                         # reply to Reply to: field
set reverse_name                     # reply as whomever it was to
set include                          # include message in replies
set forward_quote                    # include message in forwards

set editor = "emacsclient -t %s"

set from = "matt@matthewlemon.com"

set record = "+Sent"

bind compose p postpone-message
bind index p recall-message

# MAILCAP
auto_view text/html

set virtual_spoolfile=yes
    '';
  };
}
