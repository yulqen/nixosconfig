{config, pkgs, ... }:
{
  
 programs.emacs = {
    enable = true;
    package = pkgs.emacs;
    extraPackages = epkgs: [
      epkgs.use-package
      epkgs.solarized-theme
      epkgs.magit
      epkgs.denote
      epkgs.nix-mode
      epkgs.org
      epkgs.ef-themes
      epkgs.reformatter
      epkgs.pass
      epkgs.vertico
      epkgs.consult
      epkgs.consult-lsp
      epkgs.orderless
      epkgs.expand-region
      epkgs.undo-tree
      epkgs.marginalia
      epkgs.embark
      epkgs.embark-consult
      epkgs.markdown-mode
      epkgs.eglot
      epkgs.yasnippet
      epkgs.company
      epkgs.paredit
      epkgs.rainbow-delimiters
      epkgs.elfeed
      epkgs.cider
      epkgs.ledger-mode
      epkgs.flycheck
      epkgs.diminish
      epkgs.browse-kill-ring
      epkgs.unicode-fonts
      epkgs.which-key
    ];
    extraConfig = builtins.readFile ./init.el;
 };

 services.emacs = {
   enable = true;
   client.enable = true;
   defaultEditor = true;
   socketActivation.enable = true;
 };
}
