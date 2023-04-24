;;; init.el --- HOMEMADE emacs configuration -*- lexical-binding: t -*-
;;; Commentary:
;;
(setq gc-cons-threshold most-positive-fixnum)
(defvar bootstrap-version)
(let ((bootstrap-file
      (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
        "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
        'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(scroll-bar-mode -1)
(menu-bar-mode -1)
(tool-bar-mode -1)
(electric-pair-mode 1)
(set-face-attribute 'default nil :family "BlexMono Nerd Font" :slant 'italic :height 150)
(global-display-line-numbers-mode 1)
(recentf-mode)
(add-hook 'text-mode-hook #'auto-fill-mode)
(setq display-line-numbers-type 'relative)
(setq vc-follow-symlinks nil)
(setq tab-always-indent 'complete)
(setq read-extended-command-predicate #'command-completion-default-include-p) 
(setq enable-recursive-minibuffers t)
(setq-default tab-width 4)
(setq inhibit-splash-screen t)
(setq c-basic-offset 4)
(setq backup-directory-alist '(("." . "~/.config/emacs/backup")))
(setq-default fill-column 80)
(setq treesit-language-source-alist
   '((bash "https://github.com/tree-sitter/tree-sitter-bash")
     (cmake "https://github.com/uyha/tree-sitter-cmake")
     (css "https://github.com/tree-sitter/tree-sitter-css")
     (cpp "https://github.com/tree-sitter/tree-sitter-cpp")
     (elisp "https://github.com/Wilfred/tree-sitter-elisp")
     (go "https://github.com/tree-sitter/tree-sitter-go")
     (gomod "https://github.com/camdencheek/tree-sitter-go-mod")
     (html "https://github.com/tree-sitter/tree-sitter-html")
     (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
     (json "https://github.com/tree-sitter/tree-sitter-json")
     (make "https://github.com/alemuller/tree-sitter-make")
     (markdown "https://github.com/ikatyang/tree-sitter-markdown")
     (python "https://github.com/tree-sitter/tree-sitter-python")
     (toml "https://github.com/tree-sitter/tree-sitter-toml")
     (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
     (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
     (yaml "https://github.com/ikatyang/tree-sitter-yaml")))

(defun kill-other-buffers ()
	"Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer
		(delq (current-buffer)
			  (remove-if-not 'buffer-file-name (buffer-list)))))

(add-hook 'emacs-startup-hook (lambda () (setq gc-cons-threshold 128000000)))
;; --------------------------------------------------------------------------------------------------
(use-package exec-path-from-shell
  :config
  (when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize)))

(use-package general)

(use-package markdown-mode
  :mode ("README\\.md\\'" . gfm-mode)
  :init (setq markdown-command "multimarkdown"))

(use-package all-the-icons)

(use-package nerd-icons)

(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-dracula t)
  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; use "doom-colors" for less minimal icon theme
  ;; (setq doom-themes-treemacs-theme "doom-atom") 
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook
  (prog-mode . rainbow-delimiters-mode))
;; --------------------------------------------------------------------------------------------------
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-undo-system 'undo-fu)
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package evil-nerd-commenter
  :config (evilnc-default-hotkeys))

(use-package undo-fu)

(use-package rg
  :config (rg-enable-default-bindings))

(use-package projectile
  :config (projectile-mode 1))

(use-package diminish
  :config
  (diminish 'visual-line-mode))

(use-package corfu
  :config
  (setq corfu-auto t)
  (setq corfu-cycle t)
  (setq corfu-separator ?\s)
  :init
  (global-corfu-mode 1))

(use-package ssh-agency)

(use-package nerd-icons-corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package vertico
  :init
  (vertico-mode))

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (savehist-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package magit)

(use-package flycheck)

(use-package which-key
  :config (which-key-mode))

(use-package treemacs
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (setq treemacs-litter-directories '("/node_modules" "/.venv" "/.cask")
		treemacs-show-cursor nil
		treemacs-show-hidden-files t
		treemacs-show-cursor t
		treemacs-width 30))

(use-package treemacs-evil
  :after (treemacs evil)
  :ensure t)

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
  :ensure t
  :config (treemacs-set-scope-type 'Perspectives))

(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
  :after (treemacs)
  :ensure t
  :config (treemacs-set-scope-type 'Tabs))

(use-package perspective
  :bind
  ("C-x C-b" . persp-list-buffers)         ; or use a nicer switcher, see below
  :custom
  (persp-mode-prefix-key (kbd "C-c M-p"))  ; pick your own prefix key here
  :init
  (persp-mode))

(use-package avy)

(use-package ace-jump-mode)

(use-package company
  ; :config
  ; (add-hook 'after-init-hook #'global-company-mode)
  )

(use-package quickrun)

(defun tree-sitter-prog-mode-enable ()
  (add-hook 'prog-mode-hook 'tree-sitter-mode)
  (add-hook 'prog-mode-hook 'tree-sitter-hl-mode))

(use-package tree-sitter
  :config
  (add-hook 'after-init-hook #'tree-sitter-prog-mode-enable))

(use-package tree-sitter-langs)

(use-package helm-lsp)

(use-package helm
  :config 
  (helm-mode -1))

(use-package docker)

(use-package dockerfile-mode)

(use-package docker-compose-mode)
;; --------------------------------------------------------------------------------------------------
(use-package haskell-snippets)

(use-package yasnippet
  :config
  (yas-global-mode 1))

(use-package yasnippet-snippets)

(use-package java-snippets)

(use-package aws-snippets)

(use-package clojure-snippets)
;; --------------------------------------------------------------------------------------------------
(general-create-definer my-leader-def
  :prefix "SPC")

(my-leader-def
  :states 'normal
  :keymaps 'override
  "t 0" 'treemacs-select-window
  "t t" 'treemacs
  "t 1" 'treemacs-delete-other-windows
  "t f" 'treemacs-find-file
  "r f" 'helm-recentf
  "k o" 'kill-other-buffers
  "j" 'ace-jump-mode
  )

(my-leader-def
  :states 'normal
  :keymaps 'projectile-mode-map
  "p" 'projectile-command-map)

(my-leader-def
  :states 'normal
  :keymaps 'eglot-mode-map
  "r n" 'eglot-rename
  "a" 'eglot-code-action-quickfix
  )
;; --------------------------------------------------------------------------------------------------
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode) . ("clangd"))))

(use-package lsp-mode)

(use-package lsp-treemacs)

(use-package lsp-ui
  :config
  (setq lsp-ui-sideline-show-diagnostics nil))

(use-package dap-mode)

(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

(defun eglot-format-buffer-on-save ()
  (add-hook 'before-save-hook #'gofmt-before-save -10 t))

(use-package go-mode
  :init
  (setq gofmt-command "goimports")
  :config
  (define-key go-mode-map [remap godef-jump] #'xref-find-definitions)
  :hook
  (go-mode . eglot-ensure)
  (go-mode . eglot-format-buffer-on-save))

(use-package gotest)

(use-package clang-format)
(add-hook 'c++-mode-hook #'eglot-ensure)
(add-hook 'c++-mode-hook (lambda () (add-hook 'before-save-hook #'clang-format-buffer)))
(add-hook 'c-mode-hook #'eglot-ensure)
(add-hook 'c-mode-hook (lambda () (add-hook 'before-save-hook #'clang-format-buffer)))

(use-package terraform-mode
  :custom (terraform-indent-level 4)
  (add-hook 'terraform-mode-hook 'my-terraform-mode-init))

(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))

(use-package slime
  :config (setq inferior-lisp-program "sbcl"))
;; --------------------------------------------------------------------------------------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(corfu-min-width 35))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(corfu-current ((t (:background "light green" :foreground "black")))))