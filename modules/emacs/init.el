(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t)
(require 'use-package)

(use-package nix-mode
  :mode "\\.nix\\'")

(load-theme 'ef-deuteranopia-dark t)

;; settle with the warnings
(setq warning-minimum-level :emergency)

(require 'org-protocol)

;; cursor colour
(set-cursor-color "magenta")

;; timestamps
;; from: https://gist.github.com/takehiko/306021460b21f5d1520c32293cd831e0
(defun mrl/insert-timestamp-default ()
  "Insert the current timestamp"
  (interactive)
  (insert (current-time-string)))

(defun mrl/insert-timestamp-iso ()
  "Insert the current timestamp (ISO 8601 format)"
  (interactive)
  (insert
   (concat
    (format-time-string "%Y-%m-%dT%T")
    ((lambda (x) (concat (substring x 0 3) ":" (substring x 3 5)))
     (format-time-string "%z")))))

(require 'org-protocol)

(require 'org)
(add-to-list 'org-modules 'org-habit)

;; MISC optimizations
(setq org-clock-sound "~/Documents/sync/dong.wav")
(setq idle-update-delay 1.0)
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)
(setq-default cursor-in-non-selected-windows nil)
(setq hightlight-nonselected-windows nil)
(setq fast-but-imprecise-scrolling t)
(setq inhibit-compacting-font-caches t)
(menu-bar-mode 1)

(add-hook 'org-mode-hook 'visual-line-mode)

;; turn off flycheck-mode
(add-hook 'org-mode-hook (lambda () flycheck-mode -1))

;; ID basics
(setq user-full-name "Matthew Lemon"
      user-mail-address "matt@matthewlemon.com")

;; UI
(setq inhibit-startup-message 1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(put 'narrow-to-defun  'disabled nil)
(put 'narrow-to-page   'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; Put backups in /tmp where they belong
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; recursively copy by default
(setq dired-recursive-copies 'always)

;; y or n instead of yes or no
(fset 'yes-or-no-p 'y-or-n-p)

;; auto revert files
(global-auto-revert-mode t)

;; BACKUPS/LOCKFILES --------
;; Don't generate backups or lockfiles.
(setq create-lockfiles nil
      make-backup-files nil
      ;; But in case the user does enable it, some sensible defaults:
      version-control t     ; number each backup file
      backup-by-copying t   ; instead of renaming current file (clobbers links)
      delete-old-versions t ; clean up after itself
      kept-old-versions 5
      kept-new-versions 5
      backup-directory-alist (list (cons "." (concat user-emacs-directory "backup/"))))

;; Display the current time
(display-time-mode t)

;; Simply has to be done
(setq visible-bell t)

(setq display-line-numbers-type `relative)
(setq undo-limit 8000000) ; raise limit to 80Mb
(setq truncate-string-ellipsis "…") ; better than using dots
(setq scroll-preserve-screen-position 'always) ; experimental
(setq scroll-margin 3) ; bit of space

;; calendar proper Monday start
(setq calendar-week-start-day 1)
(setq calendar-date-style (quote european))

;; Handling tabs (for programming)
(setq-default tab-width 2)
(setq-default tab-width 2 indent-tabs-mode nil)
(setq-default indent-tabs-mode nil)
(setq js-indent-level 2)
(setq python-indent 2)
(setq css-indent-offset 2)
(add-hook 'sh-mode-hook
          (lambda ()
            (setq sh-basic-offset 2
                  sh-indentation 2)))
(setq web-mode-markup-indent-offset 2)

;; Highlight matching parens
(show-paren-mode t)

;; Stop C-z suspending emacs
(global-set-key (kbd "C-z") 'nil)

;; encoding
(prefer-coding-system 'utf-8)
(setq coding-system-for-read 'utf-8)
(setq coding-system-for-write 'utf-8)

(use-package denote
  :ensure t
  :init
  (add-hook 'dired-mode-hook #'denote-dired-mode)
  :config
  (setq denote-directory (expand-file-name "~/Documents/denote/"))
  (setq denote-known-keywords '("emacs" "clojure" "org-mode" "work" "technote"))
  (setq denote-file-type nil)
  (setq denote-prompts '(title keywords))
  (setq denote-date-prompt-use-org-read-date t)

  (defun mrl/denote-find-file ()
      "Find file in the current `denote-directory'."
      (interactive)
      (require 'consult)
      (require 'denote)
      (consult-find (denote-directory)))

  (defun mrl/is-todays-journal? (f)
    "If f is today's journal in denote, f is returned"
    (let* ((month-regexp (car (calendar-current-date)))
           (day-regexp (nth 1 (calendar-current-date)))
           (year-regexp (nth 2 (calendar-current-date)))
           (journal-files (directory-files (denote-directory) nil "_journal"))
           (day-match? (string-match-p (concat "^......" (format "%02d" day-regexp)) f))
           (year-match? (string-match-p (concat "^" (number-to-string year-regexp)) f))
           (month-match? (string-match-p (concat (number-to-string month-regexp) "..T") f)))
      (when (and day-match? year-match? month-match?)
        f)))

  (defun mrl/denote-journal ()
    "Create an entry tagged 'journal' with the date as its title."
    (defvar mrl/in-mod-denote nil)
    (interactive)
    (let* ((journal-dir (concat (denote-directory) "journals"))
           (today-journal
            (car (-non-nil
                  (mapcar #'mrl/is-todays-journal? (directory-files journal-dir nil "_journal"))))))
      (if today-journal
          (find-file (concat journal-dir "/" today-journal))
        (if mrl/in-mod-denote ; this variable is from the .dir-locals.el file in the silo directory; we want to use a specific template
            (denote
         (format-time-string "%A %e %B %Y")
         '("journal") nil journal-dir nil 'modjournal)
          (denote
           (format-time-string "%A %e %B %Y")
           '("journal") nil journal-dir)))))
  
  :bind (("C-c n n" . denote-create-note)
         ("C-c n d" . mrl/denote-journal)
         ("C-c n t" . denote-type)
         ("C-c n f" . mrl/denote-find-file)
         ("C-c n l" . denote-link))
            )

(use-package vertico
  :ensure t
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)

  ;; Show more candidates
  ;; (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  ;; (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  ;; (setq vertico-cycle t)
)

(use-package savehist
  :ensure t
  :init
  (savehist-mode))

;; A few more useful configurations...
(use-package emacs
  :ensure t
  :init
  ;; Add prompt indicator to `completing-read-multiple'.
  ;; We display [CRM<separator>], e.g., [CRM,] if the separator is a comma.
  (defun crm-indicator (args)
    (cons (format "[CRM%s] %s"
                  (replace-regexp-in-string
                   "\\`\\[.*?]\\*\\|\\[.*?]\\*\\'" ""
                   crm-separator)
                  (car args))
          (cdr args)))
  (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

  ;; Do not allow the cursor in the minibuffer prompt
  (setq minibuffer-prompt-properties
        '(read-only t cursor-intangible t face minibuffer-prompt))
  (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

  ;; Emacs 28: Hide commands in M-x which do not work in the current mode.
  ;; Vertico commands are hidden in normal buffers.
  ;; (setq read-extended-command-predicate
  ;;       #'command-completion-default-include-p)

  ;; Enable recursive minibuffers
  (setq enable-recursive-minibuffers t))

(use-package orderless
  :ensure t
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))


; Example configuration for Consult - from https://github.com/minad/consult
(use-package consult
  :ensure t
  ;; Replace bindings. Lazily loaded due by `use-package'.
  :bind (;; C-c bindings (mode-specific-map)
         ("C-c h" . consult-history)
         ("C-c m" . consult-mode-command)
         ("C-c k" . consult-kmacro)
         ;; C-x bindings (ctl-x-map)
         ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
         ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
         ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
         ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
         ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
         ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
         ;; Custom M-# bindings for fast register access
         ("M-#" . consult-register-load)
         ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
         ("C-M-#" . consult-register)
         ;; Other custom bindings
         ("M-y" . consult-yank-pop)                ;; orig. yank-pop
         ;; M-g bindings (goto-map)
         ("M-g e" . consult-compile-error)
         ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
         ("M-g g" . consult-goto-line)             ;; orig. goto-line
         ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
         ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
         ("M-g m" . consult-mark)
         ("M-g k" . consult-global-mark)
         ("M-g i" . consult-imenu)
         ("M-g I" . consult-imenu-multi)
         ;; M-s bindings (search-map)
         ("M-s d" . consult-find)
         ("M-s D" . consult-locate)
         ("M-s g" . consult-grep)
         ("M-s G" . consult-git-grep)
         ("M-s r" . consult-ripgrep)
         ("M-s l" . consult-line)
         ("M-s L" . consult-line-multi)
         ("M-s m" . consult-multi-occur)
         ("M-s k" . consult-keep-lines)
         ("M-s u" . consult-focus-lines)
         ;; Isearch integration
         ("M-s e" . consult-isearch-history)
         :map isearch-mode-map
         ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
         ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
         ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
         ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
         ;; Minibuffer history
         :map minibuffer-local-map
         ("M-s" . consult-history)                 ;; orig. next-matching-history-element
         ("M-r" . consult-history))                ;; orig. previous-matching-history-element

  ;; Enable automatic preview at point in the *Completions* buffer. This is
  ;; relevant when you use the default completion UI.
  :hook (completion-list-mode . consult-preview-at-point-mode)

  ;; The :init configuration is always executed (Not lazy)
  :init

  ;; Optionally configure the register formatting. This improves the register
  ;; preview for `consult-register', `consult-register-load',
  ;; `consult-register-store' and the Emacs built-ins.
  (setq register-preview-delay 0.5
        register-preview-function #'consult-register-format)

  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Configure other variables and modes in the :config section,
  ;; after lazily loading the package.
  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key (kbd "M-."))
  ;; (setq consult-preview-key (list (kbd "<S-down>") (kbd "<S-up>")))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.2 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key (kbd "M-.")
   :preview-key '(:debounce 0.4 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; (kbd "C-+")

  ;; Optionally make narrowing help available in the minibuffer.
  ;; You may want to use `embark-prefix-help-command' or which-key instead.
  ;; (define-key consult-narrow-map (vconcat consult-narrow-key "?") #'consult-narrow-help)

  ;; By default `consult-project-function' uses `project-root' from project.el.
  ;; Optionally configure a different project root function.
  ;; There are multiple reasonable alternatives to chose from.
  ;;;; 1. project.el (the default)
  ;; (setq consult-project-function #'consult--default-project--function)
  ;;;; 2. projectile.el (projectile-project-root)
  ;; (autoload 'projectile-project-root "projectile")
  ;; (setq consult-project-function (lambda (_) (projectile-project-root)))
  ;;;; 3. vc.el (vc-root-dir)
  ;; (setq consult-project-function (lambda (_) (vc-root-dir)))
  ;;;; 4. locate-dominating-file
  ;; (setq consult-project-function (lambda (_) (locate-dominating-file "." ".git")))
  )

(use-package consult-lsp
  :ensure t)

(use-package expand-region
  :bind (("C-@" . er/expand-region)
         ("C-=" . er/expand-region)
         ("M-3" . er/expand-region)))

(use-package undo-tree
  :ensure t
  :init
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d./.cache"))) ; from https://github.com/syl20bnr/spacemacs/issues/15426
  (global-undo-tree-mode))

(use-package marginalia
  :ensure t
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

(use-package embark
  :ensure t
  :bind
  (("C-." . embark-act)         ;; pick some comfortable binding
   ("C-;" . embark-dwim)        ;; good alternative: M-.
   ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings'

  :init

  ;; Optionally replace the key help with a completing-read interface
  (setq prefix-help-command #'embark-prefix-help-command)

  :config

  ;; Hide the mode line of the Embark live/completions buffers
  (add-to-list 'display-buffer-alist
               '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                 nil
                 (window-parameters (mode-line-format . none)))))

(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

(use-package markdown-mode
  :ensure t
  :bind (:map markdown-mode-map
              ("C-c C-q" . mrl/clear-check-single-line)
              ("C-c C-v" . mrl/clear-check-from-region))
  :hook (markdown-mode-hook . (lambda ()
                                (when buffer-file-name
                                  (add-hook 'after-save-hook
                                            'check-parens
                                            nil t)))))

(use-package eglot
  :ensure t
  :hook ((python-mode . eglot-ensure)
         (clojure-mode . eglot-ensure)
         (clojurescript-mode . eglot-ensure)))


(use-package yasnippet
  :ensure t
  :diminish yas-minor-mode
  :hook ((prog-mode LaTeX-mode org-mode) . yas-minor-mode)
  :bind
  (:map yas-minor-mode-map ("C-c C-n" . yas-expand-from-trigger-key))
  (:map yas-keymap
        (("TAB" . smarter-yas-expand-next-field)
         ([(tab)] . smarter-yas-expand-next-field)))
  :config
  (use-package yasnippet-snippets)
  (yas-reload-all)
  (defun smarter-yas-expand-next-field ()
    "Try to `yas-expand' then `yas-next-field' at current cursor position."
    (interactive)
    (let ((old-point (point))
          (old-tick (buffer-chars-modified-tick)))
      (yas-expand)
      (when (and (eq old-point (point))
                 (eq old-tick (buffer-chars-modified-tick)))
        (ignore-errors (yas-next-field))))))

(use-package company
  :ensure t
  :diminish company-mode
  :hook ((prog-mode LaTeX-mode latex-mode ess-r-mode ledger-mode) . company-mode)
  :bind
  (:map company-active-map
        ([tab] . smarter-yas-expand-next-field-complete)
        ("TAB" . smarter-yas-expand-next-field-complete))
  :custom
  (company-tooltip-align-annotations t)
  (company-begin-commands '(self-insert-command))
  (company-require-match 'never)
  ;; Don't use company in the following modes
  (company-global-modes '(not shell-mode eaf-mode))
  ;; Trigger completion immediately.
  (company-idle-delay 0.1)
  ;; Number the candidates (use M-1, M-2 etc to select completions).
  (company-show-numbers t)
  :config
  ;; clangd variable not present which was a problem
  ;;  (unless *clangd* (delete 'company-clang company-backends))
  ;;  (global-company-mode 1)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 3)
  (defun smarter-yas-expand-next-field-complete ()
    "Try to `yas-expand' and `yas-next-field' at current cursor position.

If failed try to complete the common part with `company-complete-common'"
    (interactive)
    (if yas-minor-mode
        (let ((old-point (point))
              (old-tick (buffer-chars-modified-tick)))
          (yas-expand)
          (when (and (eq old-point (point))
                     (eq old-tick (buffer-chars-modified-tick)))
            (ignore-errors (yas-next-field))
            (when (and (eq old-point (point))
                       (eq old-tick (buffer-chars-modified-tick)))
              (company-complete-common))))
      (company-complete-common))))


(use-package paredit
  :ensure t
  :init
  (add-hook 'clojure-mode-hook #'enable-paredit-mode)
  (add-hook 'cider-repl-mode-hook #'enable-paredit-mode)
  (add-hook 'emacs-lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
  (add-hook 'ielm-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-mode-hook #'enable-paredit-mode)
  (add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
  (add-hook 'scheme-mode-hook #'enable-paredit-mode)
  :config
  (show-paren-mode t)
  :bind (("M-[" . paredit-wrap-square)
         ("M-{" . paredit-wrap-curly))
  :diminish nil)

(use-package rainbow-delimiters
  :ensure t
  :config
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode))

(use-package which-key
  :config
  (which-key-mode))

(use-package elfeed
  :ensure t
  :config
  (setq elfeed-feeds
        '(("https://planet.clojure.in/atom.xml")
          ("https://hnrss.org/newest?q=plaintext")
          ("https://hnrss.org/newest?q=taskwarrior")
          ("https://hnrss.org/newest?q=Roam")
          ("https://herbertlui.net/feed/")
          ("https://cheapskatesguide.org/cheapskates-guide-rss-feed.xml")
          ("https://reallifemag.com/rss")
          ("https://yulqen.org/blog/index.xml")
          ("https://yulqen.org/stream/index.xml")
          ("https://dataswamp.org/~solene/rss.xml")
          ("https://baty.net/feed/")
          ("https://bsdly.blogspot.com/feeds/posts/default")
          ("https://sivers.org/en.atom")
          ("http://feeds.bbci.co.uk/sport/rugby-union/rss.xml?edition=uk")
          ("https://krebsonsecurity.com/feed/")
          ("https://www.computerweekly.com/rss/IT-security.xml")
          ("https://undeadly.org/errata/errata.rss")
          ("https://eli.thegreenplace.net/feeds/all.atom.xml")
          ("https://m-chrzan.xyz/rss.xml")
          ("https://plaintextproject.online/feed.xml")
          ("http://ebb.org/bkuhn/blog/rss.xml")
          ("https://usesthis.com/feed.atom")
          ("http://www.linuxjournal.com/node/feed")
          ("http://www.linuxinsider.com/perl/syndication/rssfull.pl")
          ("http://feeds.feedburner.com/mylinuxrig")
          ("https://landchad.net/rss.xml")
          ("https://lukesmith.xyz/rss.xml")
          ("https://yewtu.be/feed/channel/UCs6KfncB4OV6Vug4o_bzijg")
          ("https://idle.nprescott.com/")
          ("https://eradman.com/")
          ("https://hunden.linuxkompis.se/feed.xml")
          ("https://greghendershott.com/")
          ("https://www.romanzolotarev.com/rss.xml")
          ("https://feeds.feedburner.com/StudyHacks")
          ("https://www.theregister.com/Design/page/feeds.html")
          ("https://stevenpressfield.com/feed")
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCrqM0Ym_NbK1fqeQG2VIohg") "Tsoding)"
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC2eYFnH61tmytImy1mTYvhA") "Luke Smith)"
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UCittVh8imKanO_5KohzDbpg") "Paul Joseph Watson)"
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UChWbNrHQHvKK6paclLp7WYw") "Ben Hoff)"
          ("https://www.youtube.com/feeds/videos.xml?channel_id=UC5A6gpksxKgudZxrTOpz0XA") "fstori" 
          ("https://www.reddit.com/r/stallmanwasright.rss")
          ("http://feeds2.feedburner.com/Command-line-fu")
          ("https://www.debian.org/News/news")
          ("https://opensource.org/news.xml")
          ("https://www.fsf.org/static/fsforg/rss/news.xml")
          ("https://jordanorelli.com/rss")
          ("https://www.c0ffee.net/rss/")
          ("http://tonsky.me/blog/atom.xml")
          ("https://akkshaya.blog/feed")
          ("https://miguelmota.com/index.xml")
          ("https://web3isgoinggreat.com/feed.xml")
          ("https://feeds.feedburner.com/arstechnica/open-source")
          ("https://karl-voit.at/feeds/lazyblorg-all.atom_1.0.links-only.xml")
          ("https://nitter.net/webzinepuffy/rss")
          ("https://nitter.net/jcs/rss")
          ("https://nitter.net/openbsdjournal/rss")
          ("https://nitter.net/sizeofvoid/rss")
          ("https://nitter.net/wesley974/rss")
          ("https://nitter.net/slashdot/rss")
          ("https://www.romanzolotarev.com/rss.xml")
          ("https://www.romanzolotarev.com/n/rss.xml"))))


(use-package magit
  :ensure t
  :bind ("C-x g" . magit-status))

(use-package ledger-mode
  :ensure t
  :mode ("\\.ledger\\'")
  :config
  ;;  (setq ledger-default-date-format "%d/%m/%Y")
  (setq ledger-reports
        '(("hsbc_current_account" "ledger [[ledger-mode-flags]] --date-format \"%d/%m/%Y\" -f /home/lemon/Documents/Budget/ledger/2021/budget2021.ledger reg Assets\\:HSBC\\:Current")
          ("bal" "%(binary) -f %(ledger-file) bal")
          ("reg" "%(binary) -f %(ledger-file) reg")
          ("payee" "%(binary) -f %(ledger-file) reg @%(payee)")
          ("account" "%(binary) -f %(ledger-file) reg %(account)")))
  (add-hook 'ledger-mode-hook
            (lambda ()
              (setq-local tab-always-indent 'complete)
              (setq-local completion-cycle-threshold t)
              (setq-local ledger-complete-in-steps t)))
  :custom (ledger-clear-whole-transactions t))

(use-package flycheck
  :ensure t
  :init (global-flycheck-mode))

(setq flycheck-global-modes '(not org-mode))

(use-package dired
  :ensure nil
  :bind
  (("C-x C-j" . dired-jump)
   ("C-x j" . dired-jump-other-window))
  :custom
  ;; Always delete and copy recursively
  (dired-recursive-deletes 'always)
  (dired-recursive-copies 'always)
  ;; Auto refresh Dired, but be quiet about it
  (global-auto-revert-non-file-buffers t)
  (auto-revert-verbose nil)
  ;; Quickly copy/move file in Dired
  (dired-dwim-target t)
  ;; Move files to trash when deleting
  (delete-by-moving-to-trash t)
  :config
  ;; Reuse same dired buffer, to prevent numerous buffers while navigating in dired
  (put 'dired-find-alternate-file 'disabled nil)
  :hook
  (dired-mode . (lambda ()
                  (local-set-key (kbd "<mouse-2>") #'dired-find-alternate-file)
                  (local-set-key (kbd "RET") #'dired-find-alternate-file)
                  (local-set-key (kbd "^")
                                 (lambda () (interactive) (find-alternate-file ".."))))))

;; dired config
;; human readable
(setq-default dired-listing-switches "-alh")
;; Ability to use a to visit a new directory or file in dired instead of using RET. RET works just fine,
;; but it will create a new buffer for every interaction whereas a reuses the current buffer.
(put 'dired-find-alternate-file 'disabled nil)
(setq dired-recursive-copies 'always)

(use-package browse-kill-ring
  :bind ("C-x C-y" . browse-kill-ring)
  :config
  (setq browse-kill-ring-quit-action 'kill-and-delete-window))


(use-package recentf
  :hook (after-init . recentf-mode)
  :bind (("C-x C-r" . recentf-open-files))
  :custom
  (recentf-auto-cleanup "05:00am")
  (recentf-exclude '((expand-file-name package-user-dir)
               ".cache"
               ".cask"
               ".elfeed"
               "bookmarks"
               "cache"
               "ido.*"
               "persp-confs"
               "recentf"
               "undo-tree-hist"
               "url"
               "COMMIT_EDITMSG\\'"))
  (setq recentf-auto-cleanup 'never
        recentf-max-saved-items 50
        recentf-save-file (concat user-emacs-directory ".recentf"))
  (setq recentf-max-menu-items 25)
  (setq recentf-max-saved-items 25)
  (recentf-mode t))


(use-package unicode-fonts
 :ensure t
 :config
  (unicode-fonts-setup))

(global-set-key (kbd "C-+") #'text-scale-increase)
(global-set-key (kbd "C--") #'text-scale-decrease)

(setq calendar-latitude 55.77)
(setq calendar-longitude -2.01)
(setq calendar-location-name "Berwick-upon-Tweed")

(use-package org
  :ensure t
  :init
  (add-to-list 'org-modules 'org-habit)
  :bind (("C-c l" . 'org-store-link)
         ("C-c a" . 'org-agenda)
         ("C-c b" . 'org-iswitchb)
         ("C-c c" . 'org-capture))
  :config
  ;; advice function to immediately narrow to subtree from org-agenda-goto
  ;; which is hitting TAB to view an item in the agenda
  ;; from https://emacs.stackexchange.com/questions/17797/how-to-narrow-to-subtree-in-org-agenda-follow-mode
  (advice-add 'org-agenda-goto :after
            (lambda (&rest args)
              (org-narrow-to-subtree)))
  (setq org-src-tab-acts-natively t)
  (setq org-directory "~/org/")
  (setq org-highest-priority ?A)
  (setq org-default-priority ?C)
  (setq org-lowest-priority ?E)
  (setq org-priority-faces
      '((?A . (:foreground "#CC0000" :background "#FFE3E3"))
        (?B . (:foreground "#64992C" :background "#EBF4DD"))
        (?C . (:foreground "#64992C" :background "#FFFFFF"))))
  (setq org-ellipsis "...")
  (setq org-startup-indented nil)
  (setq org-hide-leading-stars nil)
  (setq org-log-into-drawer t)
  (setq org-deadline-warning-days 4)
  (setq org-clock-persist 'history)
  (org-clock-persistence-insinuate)
  (setq org-M-RET-may-split-line '(default . nil))
  (setq org-enforce-todo-dependencies t)
  (setq org-log-done 'time)
  (setq org-log-done-with-time 'note)
  (setq diary-file "~/org/diary")
  (setq org-reverse-note-order t)
  (setq +org-habit-min-width 45)
  (setq org-habit-show-habits t)
  (setq org-habit-show-habits-only-for-today nil)
  (setq org-columns-default-format "%50ITEM(Task) %10CLOCKSUM %25TIMESTAMP_IA")
  (setq org-archive-location "~/org/archive.org::* From %s")
  (setq org-refile-targets (quote ((nil :maxlevel . 9)
                                   (org-agenda-files :maxlevel . 9))))

(setq org-agenda-span 'day)
(setq org-agenda-start-day "today")
(setq org-agenda-files (quote ("~/org/home.org"
                               "~/org/refile.org"
                               "~/org/mod.org"
                               "~/org/habits.org")))
(setq org-agenda-window-setup 'other-window)
(setq org-agenda-start-with-log-mode t)
(setq org-agenda-include-diary nil)
(setq org-agenda-diary-file "~/org/calendar/cal.org")
(setq org-agenda-show-future-repeats t)
(setq org-agenda-skip-deadline-if-done t)
(setq org-agenda-skip-deadline-prewarning-if-scheduled t)
(setq org-agenda-skip-scheduled-if-done t)
(setq org-agenda-sort-notime-is-late nil)

(setq org-agenda-custom-commands
      '(
        ("w" "Work"
         (
          (agenda)
          (tags "TODO=\"DOING\"|REFILE+LEVEL=2|current|PRIORITY=\"A\"" ((org-agenda-overriding-header "DEAL")))
          (tags-todo "TODO=\"WAITING\"" ((org-agenda-overriding-header "MOD WAITING")
                                         (org-agenda-sorting-strategy '(deadline-down scheduled-down priority-down))))
          (tags-todo "-SCHEDULED>=\"<today>\"&TODO=\"NEXT\""
                     ((org-agenda-overriding-header "MOD NEXT UNSCHEDULED")
                      (org-agenda-sorting-strategy '(deadline-up priority-down))))
          (tags-todo "TODO=\"PROJECT\"" ((org-agenda-overriding-header "Projects")))
          (tags-todo "TODO=\"NEXT\"" ((org-agenda-overriding-header "All Next Actions")
                                      (org-agenda-sorting-strategy '(deadline-up scheduled-down priority-down))))
          (tags-todo "TODO=\"TODO\"" ((org-agenda-overriding-header "TODO")
                                      (org-agenda-sorting-strategy '(deadline-up)))))
         ((org-agenda-category-filter-preset '("+MOD" "+Proj/Task" "+Meeting" "+WorkTrip" "+refile"))))

        ("h" "Home"
         (
          (agenda)
          (tags "TODO=\"DOING\"|REFILE+LEVEL=2|current|PRIORITY=\"A\"" ((org-agenda-overriding-header "DEAL")
                                                                        (org-agenda-sorting-strategy '(priority-down alpha-up))))
          (tags-todo "TODO=\"WAITING\"" ((org-agenda-overriding-header "Home WAITING")
                                         (org-agenda-sorting-strategy '(deadline-down scheduled-down priority-down))))
          (tags-todo "-SCHEDULED>=\"<today>\"&TODO=\"NEXT\""
                     ((org-agenda-overriding-header "Home NEXT UNSCHEDULED")
                      (org-agenda-sorting-strategy '(alpha-up deadline-down scheduled-down priority-down))))
          (tags-todo "TODO=\"PROJECT\"" ((org-agenda-overriding-header "Projects")
                                         (org-agenda-sorting-strategy '(alpha-up))))
          (tags-todo "TODO=\"NEXT\"" ((org-agenda-overriding-header "All Next Actions")
                                      (org-agenda-sorting-strategy '(alpha-up deadline-down scheduled-down priority-down))))
          (tags-todo "TODO=\"TODO\"" ((org-agenda-overriding-header "TODO")
                                      (org-agenda-sorting-strategy '(alpha-up deadline-down scheduled-down priority-down)))))
         ((org-agenda-category-filter-preset '("+home" "+habits" "+refile" "+Birthday"))))
        ("i" tags "idea")
        ("r" tags "LEVEL=2+REFILE" ((org-agenda-overriding-header "Stuff to refile")))))

(setq org-capture-templates
      (quote (("i" "Inbox" entry (file+headline "~/org/refile.org" "Inbox")
               "* %?\nCaptured: %U\n")
              ("h" "Home Tasks & Notes")
              ;; ("w" "Protocol Capture" entry (file+headline "~/org/refile.org" "Web Capture")
              ;;  "* %^{Title or Comment}\nDescription: %:description\nSource: %:link\n%:initial\nCaptured: %U\n")
              ("x" "Protocol Capture" entry (file+headline "~/org/refile.org" "Web Capture")
               "* TODO Review %:description\nSource: %:link\n%:initial\nCaptured: %U\n" :immediate-finish t)
              ("w" "Protocol Capture" entry (file+headline "~/org/refile.org" "Web Capture")
               "* %:description\nSource: %:link\n%:initial\nCaptured: %U\n")
              ("ht" "Home TODO" entry (file+headline "~/org/home.org" "Tasks")
               "** TODO %?\nEntered on %U\n"
               :prepend t)
              ("hn" "Home NEXT" entry (file+headline "~/org/home.org" "Tasks")
               "** NEXT %?\nEntered on %U\n"
               :prepend t)
              ("hS" "Home Someday" entry (file+headline "~/org/home.org" "Someday")
               "** SOMEDAY %?\nEntered on %U\n")
              ("hi" "Home Idea" entry (file+headline "~/org/home.org" "Notes")
               "** %? :idea:\nEntered on %U\n")
              ("hs" "Home Calendar - Single" entry (file+headline "~/org/home.org" "Calendar")
               "* %?\n%^T")
              ("hb" "Home Calendar - Block" entry (file+headline "~/org/home.org" "Calendar")
               "* %?\n%^t--%^t")
              ("w" "Work Tasks & Notes")
              ("wt" "Work TODO" entry (file+headline "~/org/mod.org" "Tasks")
               "** TODO %?\nEntered on %U\n"
               :prepend t)
              ("wn" "Work NEXT" entry (file+headline "~/org/mod.org" "Tasks")
               "** NEXT %?\nEntered on %U\n"
               :prepend t)
              ("wS" "Work Someday" entry (file+headline "~/org/mod.org" "Someday")
               "** SOMEDAY %?\nEntered on %U\n")
              ("wN" "Note" entry (file+headline "~/org/mod.org" "Notes")
               "* %?\nEntered on %U\n")
              ("wc" "Note from Clipboard" entry (file+headline "~/org/mod.org" "Notes")
               "* %?\n\t\n%c")
              ("wr" "Note from Region" entry (file+headline "~/org/mod.org" "Notes")
               "* %?\n\t\n%i")
              ("wj" "Journal" entry (file+olp+datetree "~/org/mod.org" "Journal")
               "* %?\nEntered on %U\n")
              ("wd" "Retrospective Tasks" entry (file+headline "~/org/mod.org" "Tasks")
               "* DONE %?\nCLOSED: %U")
              ("ws" "Work Calendar - Single" entry (file+headline "~/org/mod.org" "Calendar")
               "* %?\n%^T")
              ("wb" "Work Calendar - Block" entry (file+headline "~/org/mod.org" "Calendar")
               "* %?\n%^t--%^t")
              ("wp" "Work Calendar - Trip" entry (file+headline "~/org/mod.org" "Work Trips")
               "* %?\n%^t--%^t")
              ("wm" "Work Calendar - Meeting" entry (file+headline "~/org/mod.org" "Meetings")
               "* %?\n:PROPERTIES:\n:CATEGORY: Meeting\n:END:\n%^T")
              ("e" "Emacs Tip")
              ("et" "Emacs Tip" entry (file+headline "~/org/emacs-tips.org" "Emacs Tips")
               "* %?\n\t%a")
              ("er" "Emacs Tip from Region" entry (file+headline "~/org/emacs-tips.org" "Emacs Tips")
               "* %?\n\t%i"))))

(setq org-tag-alist '(
                     ("brainstorm" . ?b)
                     ("idea" . ?d)
                     ("work" . ?w)
                     ("baes" . ?B)
                     ("offscreen" . ?O)
                     ("computer" .?c)
                     ("home" . ?h)
                     ("errand" . ?e)
                     ("emacs" . ?E)
                     ("orgmode" . ?o)
                     ("joanna" . ?j)
                     ("harvey" . ?H)
                     ("sophie" . ?S)))

(defun open-agenda ()
  "Open the org-agenda."
  (interactive)
  (let ((agenda "*Org Agenda*"))
    (if (equal (get-buffer agenda) nil)
        (org-agenda-list)
      (unless (equal (buffer-name (current-buffer)) agenda)
        (switch-to-buffer agenda))
      (org-agenda-redo t)
      (beginning-of-buffer))))

(setq org-stuck-projects
      '("+LEVEL=2/+PROJECT" ("NEXT" "DOING") nil ""))

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "|" "DEFERRED(r@/!)")
              (sequence "TODO(t)" "NEXT(n)" "DOING(D)" "PROJECT(p)"  "|" "DONE(d!)")
              (sequence "WAITING(w@/!)" "SOMEDAY(s@/!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)"))))


(setq org-todo-keyword-faces
      (quote (("TODO" :foreground "red" :weight bold)
              ("NEXT" :foreground "MediumBlue" :weight bold)
              ("PROJECT" :foreground "blue" :weight bold)
              ("DOING" :foreground "orchid" :weight bold)
              ("DONE" :foreground "ForestGreen" :weight bold)
              ("WAITING" :foreground "black" :background "yellow" :weight bold)
              ("SOMEDAY" :foreground "blue" :weight bold)
              ("HOLD" :foreground "magenta" :weight bold)
              ("CANCELLED" :foreground "snow4" :weight bold))))

(setq org-todo-state-tags-triggers
      (quote (("CANCELLED" ("CANCELLED" . t))
              ("WAITING" ("WAITING" . t))
              ("HOLD" ("WAITING") ("HOLD" . t))
              (done ("WAITING") ("HOLD"))
              ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
              ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
              ("DONE" ("WAITING") ("CANCELLED") ("HOLD"))))))
