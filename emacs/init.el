;;; package --- My Emacs initialization config
;;; Commentary:
;;; Code:
(defvar bootstrap-version)
(let ((bootstrap-file
	   (expand-file-name "straight/repos/straight.el/bootstrap.el"
						 user-emacs-directory))
	  (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
	(with-current-buffer
		(url-retrieve-synchronously
		 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
		 'silent
		 'inhibit-cookies)
	  (goto-char (point-max))
	  (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Lower threshold back to 128 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 27))))

(electric-pair-mode)
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(recentf-mode t)
(setq
 straight-use-package-by-default t
 use-package-always-ensure t
 EMACS_DIR "~/.config/emacs/"
 user-cache-directory (concat EMACS_DIR "cache")
 recentf-max-saved-items 30
 inhibit-splash-screen t
 c-basic-offset 4
 display-line-numbers-type 'relative
 delete-old-versions t
 backup-directory-alist `(("." . ,(expand-file-name "backups" user-cache-directory)))
 url-history-file (expand-file-name "url/history" user-cache-directory)
 auto-save-list-file-prefix (expand-file-name "auto-save-list/.saves-" user-cache-directory)
 sqlformat-command 'pgformatter
 sqlformat-args '("-s2" "-g")
 clang-format-style "{BasedOnStyle: Google, IndentWidth: 4}"
 gofmt-command "goimports")
;; (set-face-attribute 'default nil
;;                     :family "Monaco Nerd Font"
;;                     :width 'normal
;;                     :height 120)
(set-face-attribute 'default nil
                    ;; :family "CodeNewRoman Nerd Font Mono"
                    :family "InconsolataGo Nerd Font"
                    :width 'normal
                    :height 160)
(setq-default tab-width 4)
(setq explicit-shell-file-name "/bin/zsh")
(setq shell-file-name "zsh")
(setq explicit-zsh-args '("--login" "--interactive"))
(defun zsh-shell-mode-setup ()
  "Set up zsh shell."
  (setq-local comint-process-echoes t))
(add-hook 'shell-mode-hook #'zsh-shell-mode-setup)
(require 'term)
(define-key term-raw-map (kbd "M-o") 'other-window)
(define-key term-raw-map (kbd "M-p") 'term-send-up)
(define-key term-raw-map (kbd "M-n") 'term-send-down)
;; ============================================================================
(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `w/exec-path' and PATH environment variable."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
						  "[ \t\n]*$" "" (shell-command-to-string
										  "$SHELL --login -c 'echo $PATH'"
										  ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(use-package all-the-icons)

(use-package nerd-icons)

(use-package treemacs-nerd-icons
  :config
  (treemacs-load-theme "nerd-icons"))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode))

(use-package doom-themes
  :config
  (setq
   doom-themes-enable-bold t
   doom-themes-enable-italic t)
  (load-theme 'doom-dark+ t)
  (doom-themes-visual-bell-config)
  (doom-themes-treemacs-config)
  (doom-themes-org-config))

(use-package ag)

(use-package evil
  :init
  (setq
   evil-want-keybinding nil
   evil-want-integration t
   evil-want-C-u-delete t
   evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :config
  (evilnc-default-hotkeys))

(use-package general)

(use-package ace-jump-mode
  :after evil)

(use-package corfu
  :custom
  (corfu-cycle t)
  (corfu-auto t)
  :init
  (global-corfu-mode))

(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-cycle t))

(use-package cape
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))

(use-package which-key
  :config (which-key-mode))

(use-package flycheck
  :config (add-hook 'prog-mode-hook 'flycheck-mode))

(use-package magit)

(use-package sqlformat
  :hook (sql-mode . sqlformat-on-save-mode))

(use-package clang-format)

(use-package quickrun)

(use-package yasnippet
  :config (yas-global-mode))

(use-package lsp-treemacs)

(use-package lsp-mode
  :init (setq lsp-keymap-prefix "C-c l")
  :config (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  :hook ((lsp-mode . lsp-enable-which-key-integration)))

(use-package lsp-ui)

(use-package dap-mode
  :after lsp-mode
  :config (dap-auto-configure-mode))

(defun my-go-mode-hook ()
  "Hook to run in go-mode."
  (lsp-deferred)
  (add-hook 'before-save-hook 'gofmt-before-save 0 t))

(use-package go-mode
  :bind
  (:map go-mode-map ([remap godef-jump] . xref-find-definitions))
  :hook (go-mode . my-go-mode-hook))

(use-package js2-mode
  :hook (js-mode . lsp-deferred))

(add-hook 'c++-mode-hook #'lsp-deferred)

(use-package typescript-mode)

(use-package web-beautify
  :config
  (eval-after-load 'js2-mode
	'(add-hook 'js-mode-hook
			   (lambda ()
				 (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))
  (eval-after-load 'json-mode
	'(add-hook 'json-mode-hook
			   (lambda ()
				 (add-hook 'before-save-hook 'web-beautify-js-buffer t t))))
  (eval-after-load 'sgml-mode
	'(add-hook 'html-mode-hook
			   (lambda ()
				 (add-hook 'before-save-hook 'web-beautify-html-buffer t t))))
  (eval-after-load 'css-mode
	'(add-hook 'css-mode-hook
			   (lambda ()
				 (add-hook 'before-save-hook 'web-beautify-css-buffer t t))))
  )

(use-package haskell-mode
  :hook
  (haskell-mode . interactive-haskell-mode))

;; ============================================================================
(general-create-definer spc-leader-def
  :prefix "SPC")

(spc-leader-def
  :keymaps 'override
  :states '(normal motion visual)
  "pf" #'project-find-file
  )

(general-def 'normal
  "s" #'ace-jump-mode)

(provide 'init)
;;; init.el ends here

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-undo-system 'undo-redo))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(corfu-current ((t (:background "MediumPurple4" :foreground "#d4d4d4"))))
 '(shadow ((t (:foreground "gray50")))))
;; Local Variables:
;; byte-compile-warnings: (not free-vars unresolved)
;; End:
