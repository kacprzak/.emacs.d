;;; package --- Summary Marcin Kacprzak emacs configuration
;;; Commentary:
;;; Code:
(require 'package)

(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
(require 'diminish)
(require 'bind-key)

(require 'cc-mode)
(require 'compile)
(setq compilation-scroll-output t)

;; use-package always auto install packages
;(setq use-package-always-ensure t)

(use-package doom-themes
  :config
  (load-theme 'doom-molokai t))

;; Nice scrolling
(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

;; Enable y/n answers
(fset 'yes-or-no-p 'y-or-n-p)

;; Newline at end of file
(setq require-final-newline t)

;; Delete the selection with a keypress
(delete-selection-mode t)

;; More space on my tiny monitor
(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(global-hl-line-mode 1)
;; Disables bell sound
(setq visible-bell 1)
;; Show empty lines
(setq-default indicate-empty-lines t)
;; Matching parenthesis
(show-paren-mode t)
;; Modeline
(setq column-number-mode t)
(size-indication-mode t)

;; Store all backup and autosave files in the tmp dir
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Revert buffers automatically when underlying files are changed externally
(global-auto-revert-mode t)

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Same as in Prelude package
(global-set-key (kbd "<f12>") 'menu-bar-mode)
(global-set-key (kbd "M-/") 'hippie-expand)

(diminish 'abbrev-mode)
(diminish 'auto-revert-mode)

(use-package crux
  :ensure t
  :bind (("C-c o" . crux-open-with)
         ("M-o" . crux-smart-open-line)
         ("C-c n" . crux-cleanup-buffer-or-region)
         ("C-c f" . crux-recentf-ido-find-file)
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
         ("s-r" . crux-recentf-ido-find-file)
         ("s-j" . crux-top-join-line)
         ("C-^" . crux-top-join-line)
         ("s-k" . crux-kill-whole-line)
         ("C-<backspace>" . crux-kill-line-backwards)
         ("s-o" . crux-smart-open-line-above)
         ([remap move-beginning-of-line] . crux-move-beginning-of-line)
         ([(shift return)] . crux-smart-open-line)
         ([(control shift return)] . crux-smart-open-line-above)
         ([remap kill-whole-line] . crux-kill-whole-line)
	 ("C-c s" . crux-ispell-word-then-abbrev)))

(use-package undo-tree
  :diminish undo-tree-mode
  :config
  (global-undo-tree-mode 1))

(use-package key-chord
  :config
  (key-chord-mode t)
  (key-chord-define-global "jk" 'ace-jump-char-mode)
  (key-chord-define-global "jj" 'ace-jump-word-mode))

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode 1))

(use-package all-the-icons)

(use-package neotree
  :bind
  (("<f8>" . neotree-toggle))
  :config
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(use-package windmove
  :config
  ;; use shift + arrow keys to switch between visible buffers
  (windmove-default-keybindings))

(use-package expand-region
  :bind
  (("C-=" . er/expand-region)))

;; Default compilation window was driving me nuts
(use-package popwin
  :config
  (popwin-mode 1))

(use-package ace-jump-mode
  :bind ("C-." . ace-jump-mode))

(use-package helm
  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini)
         ("C-x C-b" . helm-buffers-list)
         ("M-y" . helm-show-kill-ring)
         ([f10] . helm-recentf))
  :init
  (setq helm-split-window-inside-p t))

(use-package helm-flycheck
  :config
  (eval-after-load 'flycheck
    '(define-key flycheck-mode-map (kbd "C-c ! h") 'helm-flycheck)))

(add-to-list 'load-path "~/.emacs.d/plugins/yasnippet")
(use-package yasnippet
  :diminish yas-minor-mode
  :config
  (yas-global-mode 1))

(use-package clang-format
  :bind (:map c-mode-map ("C-M-\\" . clang-format-buffer)
              :map c++-mode-map ("C-M-\\" . clang-format-buffer)))

(use-package move-text
  :bind (([M-up] . move-text-up)
         ([M-down] . move-text-down)))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package projectile
  :bind (("<f5>" . projectile-run-project)
         ("<f6>" . projectile-compile-project)
         ("<f7>" . projectile-test-project))
  :init
  ;;(setq projectile-keymap-prefix (kbd "s-p"))
  :config
  (projectile-mode +1))

(use-package helm-projectile
  :config
  (helm-projectile-on))

(use-package cmake-ide
  :config
  (cmake-ide-setup))

(use-package flycheck
  :diminish flycheck-mode
  :config
  (global-flycheck-mode))

(use-package guru-mode
  :diminish guru-mode
  :config
  (guru-global-mode +1))

(use-package nyan-mode
  :config
  (nyan-mode +1))

(require 'gdb-mi)
(setq
 gdb-many-windows t
 gdb-show-main t)

(use-package company
  :diminish company-mode
  :init
  (global-set-key "\t" 'company-indent-or-complete-common)
  :config
  (global-company-mode))

(use-package irony
  :diminish irony-mode
  :init
  (add-hook 'c++-mode-hook 'irony-mode)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'objc-mode-hook 'irony-mode)
  :config
  (defun my-irony-mode-hook ()
    "Replace the `completion-at-point' and `complete-symbol' bindings in
     irony-mode's buffers by irony-mode's function."
    (define-key irony-mode-map [remap completion-at-point] 'irony-completion-at-point-async)
    (define-key irony-mode-map [remap complete-symbol] 'irony-completion-at-point-async))

  (add-hook 'irony-mode-hook 'my-irony-mode-hook)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options))

(add-to-list 'load-path "~/.emacs.d/glsl-mode")
(autoload 'glsl-mode "glsl-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.glsl\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.vert\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.frag\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.geom\\'" . glsl-mode))
(if (boundp 'irony-supported-major-modes)
    (push 'glsl-mode irony-supported-major-modes))

(use-package company-irony-c-headers
  :config
  ;; Load with `irony-mode` as a grouped backend
  (eval-after-load 'company
    '(add-to-list
      'company-backends '(company-irony-c-headers company-irony))))

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(add-hook 'c-mode-common-hook 'diff-hl-mode)

(use-package flycheck-irony
  :config
  (eval-after-load 'flycheck
    '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup)))

(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
;;; init.el ends here

