;;; package --- Summary Marcin Kacprzak emacs configuration
;;; Commentary:
;;; Code:
(require 'package)

;;(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
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
;;(setq use-package-always-ensure t)

(use-package doom-themes
  :config
  (load-theme 'doom-molokai t))

;; More space on my tiny monitor
(scroll-bar-mode -1)
(menu-bar-mode -1)
;; Disables bell sound
(setq visible-bell 1)
;; Same as in Prelude package
(global-set-key (kbd "<f12>") 'menu-bar-mode)

;; Simulates functionality from popular IDE's
(defun newline-without-break-of-line ()
  "Newline without break of line."
  (interactive)
  (let ((oldpos (point)))
    (end-of-line)
    (newline-and-indent)))

(global-set-key (kbd "<S-return>") 'newline-without-break-of-line)

(defun newline-before-without-break-of-line ()
  "Newline before coursor without break of line."
  (interactive)
  (let ((oldpos (point)))
    (beginning-of-line)
    (open-line 1)
    (indent-according-to-mode)))

(global-set-key (kbd "<C-M-return>") 'newline-before-without-break-of-line)

(diminish 'abbrev-mode)
(diminish 'auto-revert-mode)

(use-package which-key
  :diminish which-key-mode
  :config
  (which-key-mode 1))

(use-package smartparens
  :diminish smartparens-mode
  :config
  (require 'smartparens-config)
  (smartparens-global-mode))

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
  (setq helm-split-window-in-side-p t))

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
  :bind (([S-up] . move-text-up)
         ([S-down] . move-text-down)))

(use-package magit
  :bind ("C-x g" . magit-status))

(use-package projectile
  :bind (("<f5>" . projectile-run-project)
         ("<f6>" . projectile-compile-project)
         ("<f8>" . projectile-test-project))
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

(use-package hungry-delete
  :diminish hungry-delete-mode
  :config
  (global-hungry-delete-mode))

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
(push 'glsl-mode irony-supported-major-modes)

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

(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
;;; init.el ends here
