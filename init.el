;;; package --- Summary Marcin Kacprzak's Emacs configuration
;;; Commentary:
;; For C++ install clang-format, clangd, lldb.  Clangd expects libc++ headers
;; in different place to where they are in Ubuntu:
;; https://stackoverflow.com/questions/55289053
;;; Code:

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(menu-bar-mode -1)
(tooltip-mode -1)
(scroll-bar-mode -1)

(if (eq system-type 'windows-nt)
    (setq default-frame-alist '((font . "Consolas-11"))))

(setq load-prefer-newer t)

(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 27)
  (package-initialize))

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package)
  (package-install 'diminish))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)
(require 'cc-mode)
(require 'compile)

(setq compilation-scroll-output t
      use-package-always-ensure t
      shift-select-mode nil
      delete-by-moving-to-trash t
      enable-recursive-minibuffers t
      require-final-newline t
      visible-bell 1
      x-stretch-cursor t
      dired-listing-switches "-alhFG"
      backup-directory-alist `((".*" . ,temporary-file-directory))
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t)))

(setq-default indicate-empty-lines t
              fill-column 80
              tab-width 4
              indent-tabs-mode nil
              display-time-24hr-format t)

(add-hook 'prog-mode-hook '(lambda ()
                             (setq truncate-lines t)))

(setq indent-line-function 'insert-tab) ;; https://stackoverflow.com/a/1819405

(global-unset-key (kbd "C-x f")) ;; fill-column

(fset 'yes-or-no-p 'y-or-n-p)

(require 'recentf)
(setq recentf-max-menu-items 25
      recentf-max-saved-items 100)
(add-to-list 'recentf-exclude (format "%s/\\.emacs\\.d/.*" (getenv "HOME")))
(recentf-mode 1)

(save-place-mode 1)
(column-number-mode t)
(size-indication-mode -1)
(global-hl-line-mode 1)
(global-auto-revert-mode t)
(delete-selection-mode t)
(show-paren-mode t)
(winner-mode 1)

;; Save mini-buffer history
(savehist-mode 1)
(setq history-length 1000)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Same as in Prelude package
(global-set-key (kbd "<f12>") 'menu-bar-mode)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-x C-o") 'ff-find-other-file)

(defun my/kill-current-buffer ()
  "Kill current buffer."
  (interactive)
  (kill-buffer (current-buffer)))

(global-set-key (kbd "C-x k") 'my/kill-current-buffer)

(diminish 'abbrev-mode)
(diminish 'auto-revert-mode)

(require 'org)
(setq org-agenda-files '("~/TODO.org")
      org-adapt-indentation nil)

(use-package doom-themes
  :config
  (load-theme 'doom-molokai t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)
  ;; Enable custom treemacs theme (all-the-icons must be installed!)
  (doom-themes-treemacs-config))

(use-package doom-modeline
  :hook
  (after-init . doom-modeline-mode))

(use-package diff-hl
  :config
  ;; https://github.com/dgutov/diff-hl/issues/116#issuecomment-449134234
  (let* ((height (frame-char-height))
         (width 2)
         (ones (1- (expt 2 width)))
         (bits (make-vector height ones)))
    (define-fringe-bitmap 'my-diff-hl-bitmap bits height width))
  (setq diff-hl-fringe-bmp-function (lambda (type pos) 'my-diff-hl-bitmap))
  ;; doom-molokai made diff-hl-change grey
  (set-face-foreground 'diff-hl-change "dodger blue")
  (global-diff-hl-mode))

(use-package dashboard
  :config
  (dashboard-setup-startup-hook))

(use-package crux
  :bind (("C-c o" . crux-open-with)
         ;; ("M-o" . crux-smart-open-line)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c f" . crux-recentf-find-file)
         ("C-M-z" . crux-indent-defun)
         ("C-c u" . crux-view-url)
         ("C-c e" . crux-eval-and-replace)
         ("C-c w" . crux-swap-windows)
         ("C-c D" . crux-delete-file-and-buffer)
         ("C-c r" . crux-rename-buffer-and-file)
         ("C-c t" . crux-visit-term-buffer)
         ("C-c k" . crux-kill-other-buffers)
         ("C-c TAB" . crux-indent-rigidly-and-copy-to-clipboard)
         ("C-c I" . crux-find-user-init-file)
         ("C-c S" . crux-find-shell-init-file)
         ("s-r" . crux-recentf-find-file)
         ("s-j" . crux-top-join-line)
         ("C-^" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ;; ("s-o" . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap kill-whole-line] . crux-kill-whole-line)
         ("C-c s" . crux-ispell-word-then-abbrev)))

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (setq undo-tree-visualizer-diff t)
  (global-undo-tree-mode 1))

(use-package avy)

(use-package key-chord
  :config
  (key-chord-mode t)
  (key-chord-define-global "jj" 'avy-goto-word-1)
  (key-chord-define-global "jk" 'avy-goto-char)
  (key-chord-define-global "jl" 'avy-goto-line)
  (key-chord-define-global "jw" 'ace-window)
  (key-chord-define-global "uu" 'undo-tree-visualize)
  (key-chord-define-global "JJ" 'crux-switch-to-previous-buffer))

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode 1))

(use-package all-the-icons)

(use-package all-the-icons-dired
  :hook
  (dired-mode . all-the-icons-dired-mode))

;; (use-package neotree
;;   :bind
;;   (("<f8>" . neotree-toggle))
;;   :config
;;   (setq neo-window-width 38)
;;   (setq neo-smart-open t)
;;   (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(use-package treemacs
  :bind
  (:map global-map
        ("<f8>" . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag))
  :config
  (setq treemacs-space-between-root-nodes nil)
  (treemacs-follow-mode -1))

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package treemacs-magit
  :after treemacs magit)

;; (use-package windmove
;;   :config
;;   ;; use shift + arrow keys to switch between visible buffers
;;   (windmove-default-keybindings))

(use-package expand-region
  :bind
  (("C-=" . er/expand-region)))

(use-package ivy
  :diminish ivy-mode
  :bind (("C-c C-r" . 'ivy-resume))
  :config
  (setq ivy-display-style 'fancy
        ivy-use-virtual-buffers t
        ivy-use-selectable-prompt t)
  (ivy-mode t))

(use-package counsel
  :bind (( "M-x" . 'counsel-M-x)
         ( "C-x C-f" . 'counsel-find-file)
         ( "<f1> f" . 'counsel-describe-function)
         ( "<f1> v" . 'counsel-describe-variable)
         ( "<f1> l" . 'counsel-find-library)
         ( "<f2> i" . 'counsel-info-lookup-symbol)
         ( "<f2> u" . 'counsel-unicode-char)))

(use-package swiper
  :bind
  ("C-s" . 'swiper))

(use-package dired-single
  :config
  (define-key dired-mode-map [return] 'dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'dired-single-buffer-mouse))

(use-package clang-format
  :bind
  (:map c-mode-map
        ("C-M-\\" . clang-format-buffer)
        :map c++-mode-map
        ("C-M-\\" . clang-format-buffer)
        :map glsl-mode-map
        ("C-M-\\" . clang-format-buffer)))

(use-package move-text
  :bind (([M-up] . move-text-up)
         ([M-down] . move-text-down)))

(use-package magit
  :bind ("C-x g" . magit-status)
  :config
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

(use-package git-timemachine)

(use-package projectile
  :bind (("<f5>" . projectile-run-project)
         ("<f6>" . projectile-compile-project)
         ("<f7>" . projectile-test-project)
         ("M-o". projectile-find-other-file))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  ("s-p" . projectile-command-map)
  :config
  (projectile-mode))

(use-package guru-mode
  :diminish guru-mode
  :config
  (guru-global-mode))

(use-package company
  :diminish company-mode
  :init
  (global-set-key "\t" 'company-indent-or-complete-common)
  :config
  (delete 'company-clang company-backends)
  (global-company-mode))

(use-package cmake-mode)

(use-package glsl-mode)

(use-package company-glsl
  :config
  (when (executable-find "glslangValidator")
    (add-to-list 'company-backends 'company-glsl)))

(use-package lsp-mode
  :defines lsp-clients-clangd-args
  :commands lsp
  :init
  (setq lsp-auto-guess-root t)
  (setq lsp-enable-snippet nil)
  (setq lsp-prefer-flymake nil)
  ;;(setq lsp-auto-configure t)
  :hook
  (c++-mode . lsp)
  (c-mode . lsp)
  (python-mode . lsp)
  (java-mode . lsp)
  :bind
  ;; temporary workaround
  (("M-?" . lsp-find-references))
  :config
  (setq lsp-symbol-highlighting-skip-current t)
  (setq lsp-clients-clangd-args '("-j=4" "-background-index" "-log=error")))

(use-package flycheck
  :init (global-flycheck-mode))

(use-package lsp-ui
  :commands lsp-ui-mode)

(use-package company-lsp
  :commands company-lsp
  :config
  (push 'company-lsp company-backends))

(if (> emacs-major-version 26)
    (use-package posframe))

(use-package dap-mode
  :after lsp-mode
  :defines dap-lldb-debug-program
  :init
  ;;(setq dap-print-io t)
  (require 'dap-lldb)
  (require 'dap-python)
  :config
  (setq dap-lldb-debug-program '("/usr/bin/lldb-vscode-10"))
  (dap-auto-configure-mode)
  (add-hook 'dap-stopped-hook
          (lambda (arg) (call-interactively #'dap-hydra)))
  :bind
  (("C-<f5>" . dap-debug-last)))

;; volatile highlights - temporarily highlight changes from pasting etc
(use-package volatile-highlights
  :diminish volatile-highlights-mode
  :config
  (volatile-highlights-mode t))

(use-package multiple-cursors
  :bind
  (("C->" . mc/mark-next-like-this)
   ("C-<" . mc/mark-previous-like-this)
   ("C-c C-<" . mc/mark-all-like-this)))

(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(if (file-exists-p custom-file)
    (load custom-file))

(put 'upcase-region 'disabled nil)
;;; init.el ends here
;; Local Variables:
;; ispell-check-comments: exclusive
;; ispell-local-dictionary: "american"
;; End:
