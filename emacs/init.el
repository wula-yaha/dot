;;; init.el --- A Simple and Stable Emacs Configuration. -*- coding: utf-8; lexical-binding: t; -*-

;;; References:
;; https://github.com/seagle0128/.emacs.d
;; https://github.com/bbatsov/prelude
;; https://github.com/redguardtoo/emacs.d
;; https://github.com/manateelazycat/lazycat-emacs
;; https://github.com/MiniApollo/kickstart.emacs
;; https://github.com/doomemacs/doomemacs
;; https://github.com/purcell/emacs.d
;; https://github.com/SystemCrafters/crafted-emacs

;;; Commentary:
;;; Code:

(use-package use-package
  :ensure nil
  :custom
  (use-package-compute-statistics t)
  (use-package-always-ensure t)
  (use-package-always-defer t)
  (use-package-expand-minimally t)
  (use-package-enable-imenu-support t))

(use-package package
  :ensure nil
  :custom
  (package-enable-at-startup nil)
  :config
  (when (or (featurep 'esup-child)
            (daemonp)
            noninteractive)
    (package-initialize))
  (setq package-check-signature nil)
  (setq package-quickstart t)
  (setq package-archives '(("melpa" . "https://melpa.org/packages/")
                           ;; ("elpa-devel" . "https://elpa.gnu.org/devel/")
                           ;; ("org" . "https://orgmode.org/elpa/")
                           ;; ("marmalade" . "http://marmalade-repo.jrg/packages/")
                           ;; ("melpa-stable" . "https://stable.melpa.org/packages/")
                           ;; ("jcs-elpa" . "https://jcs-emacs.github.io/jcs-elpa/packages/")
                           ("gnu" . "https://elpa.gnu.org/packages/")
                           ("nongnu" . "https://elpa.nongnu.org/nongnu/"))))

(use-package emacs
  :ensure nil
  :config
  (setq-default gc-cons-threshold most-positive-fixnum)
  (setq-default gc-cons-percentage 0.6)
  (setq-default use-short-answers t)
  (setq-default bidi-display-reordering nil)
  (setq-default bidi-inhibit-bpa t)
  (setq-default long-line-threshold 1000)
  (setq-default large-hscroll-threshold 1000)
  (setq-default tab-width 2)
  (setq-default truncate-lines t)
  (setq-default scroll-conservatively 101))

(use-package startup
  :ensure nil
  :init
  (setq initial-scratch-message (concat ";; Happy hacking, " user-login-name " - Emacs ♥ you!\n\n")))

(use-package syntax
  :ensure nil
  :config
  (setq-default syntax-wholeline-max 1000))

(use-package jit-lock
  :ensure nil
  :config
  (setq jit-lock-defer-time 0.25)
  (setq jit-lock-chunk-size 4096)
  (setq jit-lock-stealth-time 1.25)
  (setq jit-lock-stealth-nice 0.75))

(use-package files
  :ensure nil
  :init
  (setq auto-save-default nil)
  (setq make-backup-files nil)
  (setq confirm-kill-emacs 'y-or-n-p))

(use-package tooltip
  :ensure nil
  :hook (after-init . tooltip-mode)
  :config
  (setq tooltip-hide-delay 20)
  (setq tooltip-delay 0.4)
  (setq tooltip-short-delay 0.08))

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'reverse)
  (setq uniquify-separator " • ")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*"))

(use-package faces
  :ensure nil
  :hook (after-init . setup-fonts)
  :config
  (defun setup-fonts ()
    "Setup fonts."
    (when (display-graphic-p)
      (cl-loop for font in '("JetbrainsMono Nerd Font" "Monaco" "Consolas")
	             when (find-font (font-spec :name font))
	             return (set-face-attribute 'default nil
					                                :family font
					                                :height (cond ((eq system-type 'darwin) 130)
							                                          ((eq system-type 'windows-nt) 100)
							                                          (t 110))))
      (cl-loop for font in '("JetbrainsMono Nerd Font" "Monaco" "Consolas")
	             when (find-font (font-spec :name font))
	             return (progn
			                  (set-face-attribute 'mode-line nil :family font :height 100)
			                  (when (facep 'mode-line-active)
			                    (set-face-attribute 'mode-line-active nil :family font :height 100))
			                  (set-face-attribute 'mode-line-inactive nil :family font :height 100)))
      (cl-loop for font in '("Apple Symbols" "Segoe UI Symbol" "Symbola" "Symbol")
	             when (find-font (font-spec :name font))
	             return (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))
      (cl-loop for font in '("Noto Color Emoji" "Apple Color Emoji" "Segoe UI Emoji")
	             when (find-font (font-spec :name font))
	             return (set-fontset-font t 'emoji (font-spec :family font) nil 'prepend))
      (cl-loop for font in '("LXGW Neo Xihei" "LXGW WenKai Mono" "WenQuanYi Micro Hei Mono" "PingFang SC" "Microsoft Yahei UI" "Simhei")
	             when (find-font (font-spec :name font))
	             return (progn
			                  (setq face-font-rescale-alist `((,font . 1.3)))
			                  (set-fontset-font t 'han (font-spec :family font)))))))

(use-package which-key
  :ensure nil
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 1.5)
  (setq which-key-idle-secondary-delay 0.25)
  (setq which-key-add-column-padding 1)
  (setq which-key-max-description-length 40))

(use-package display-line-numbers
  :ensure nil
  :hook (prog-mode . display-line-numbers-mode))

(use-package autorevert
  :ensure nil
  :hook (after-init . global-auto-revert-mode)
  :config
  (setq auto-revert-interval 3)
  (setq auto-revert-remote-files nil)
  (setq auto-revert-use-notify t)
  (setq auto-revert-avoid-polling nil)
  (setq auto-revert-verbose t))

(use-package paren
  :ensure nil
  :hook (prog-mode . show-paren-mode))

(use-package hl-line
  :ensure nil
  :hook (prog-mode . hl-line-mode))

(use-package simple
  :ensure nil
  :hook
  (prog-mode . line-number-mode)
  (prog-mode . column-number-mode)
  (prog-mode . size-indication-mode)
  :config
  (setq-default indent-tabs-mode nil))

(use-package loaddefs
  :ensure nil
  :hook
  (after-init . delete-selection-mode)
  (prog-mode . electric-pair-mode))

(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode)
  :config
  (setq save-place-limit 400))

(use-package flymake
  :ensure nil
  :hook (prog-mode . flymake-mode)
  :bind
  (("M-n" . flymake-goto-next-error)
   ("M-p" . flymake-goto-prev-error)))

(use-package dired
  :ensure nil
  :config
  (setq dired-dwim-target t)
  (setq dired-listing-switches "-al")
  (setq dired-recursive-copies 'always)
  (setq dired-kill-when-opening-new-dired-buffer t))

(use-package ibuffer
  :ensure nil
  :bind
  (("C-x C-b" . ibuffer))
  :config
  (setq ibuffer-filter-group-name-face 'font-lock-doc-face)
  (setq ibuffer-human-readable-size t))

(use-package evil
  :hook (after-init . evil-mode)
  :init
  (setq evil-want-keybinding nil)
  :config
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t))

(use-package evil-leader
  :hook (evil-mode . global-evil-leader-mode)
  :config
  (setq evil-leader/leader "<SPC>")
  (evil-leader/set-key
    "<SPC>" 'execute-extended-command))

(use-package evil-escape
  :hook (evil-mode . evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2))

(use-package evil-matchit
  :hook (evil-mode . global-evil-matchit-mode))

(use-package evil-collection
  :hook (evil-mode . evil-collection-init))

(use-package evil-nerd-commenter
  :after evil
  :bind
  (:map evil-normal-state-map
        ("gcc" . evilnc-comment-or-uncomment-lines))
  (:map evil-visual-state-map
        ("gc" . evilnc-comment-or-uncomment-lines)))

(use-package evil-surround
  :hook (evil-mode . global-evil-surround-mode))

(use-package evil-goggles
  :hook (evil-mode . evil-goggles-mode)
  :config
  (evil-goggles-use-diff-faces))

(use-package evil-visualstar
  :hook (evil-mode . global-evil-visualstar-mode))

(use-package evil-mc
  :hook (evil-mode . global-evil-mc-mode))

(use-package evil-args
  :after evil
  :bind
  (:map evil-inner-text-objects-map
        ("a" . evil-inner-arg))
  (:map evil-outer-text-objects-map
        ("a" . evil-outer-arg))
  (:map evil-normal-state-map
        ("K" . evil-jump-out-args)
        ("H" . evil-backward-arg)
        ("L" . evil-forward-arg))
  (:map evil-motion-state-map
        ("H" . evil-backward-arg)
        ("L" . evil-forward-arg)))

(use-package evil-textobj-line
  :after evil
  :bind
  (:map evil-inner-text-objects-map
        ("l" . evil-forward-arg))
  (:map evil-outer-text-objects-map
        ("l" . evil-forward-arg)))

(use-package evil-indent-textobject
  :after evil
  :bind
  (:map evil-inner-text-objects-map
        ("i" . evil-indent-i-indent))
  (:map evil-outer-text-objects-map
        ("i" . evil-indent-a-indent)
        ("I" . evil-indent-a-indent-lines)))

(use-package evil-snipe
  :hook
  (evil-mode . evil-snipe-mode)
  (evil-mode . evil-snipe-override-mode)
  :config
  (setq evil-snipe-scope 'whole-buffer))

(use-package dashboard
  :hook (after-init . dashboard-setup-startup-hook)
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-items '((recents . 5) (bookmarks . 5) (projects . 5)))
  (setq dashboard-navigation-cycle t)
  (setq dashboard-heading-shorcut-format " [%s]")
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-icon-file-height 1.75)
  (setq dashboard-icon-file-v-adjust -0.125)
  (setq dashboard-heading-icon-height 1.75)
  (setq dashboard-heading-icon-v-adjust -0.125))

(use-package doom-themes)
(use-package catppuccin-theme)
(use-package zenburn-theme)
(use-package solarized-theme)
(use-package spacemacs-theme)
(use-package monokai-theme)
(use-package gruvbox-theme)
(use-package dracula-theme)
(use-package material-theme)
(use-package moe-theme)
(use-package ample-theme)
(use-package tao-theme)
(use-package minimal-theme)
(use-package standard-themes)
(use-package color-theme-sanityinc-solarized)
(use-package color-theme-sanityinc-tomorrow
  :hook (after-init . (lambda () (load-theme 'sanityinc-tomorrow-bright t))))

(use-package beacon
  :hook (after-init . beacon-mode)
  :config
  (setq beacon-size 20))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 20)
  (setq doom-modeline-bar-width 5)
  (setq doom-modeline-enable-word-count t)
  (setq doom-modeline-minor-modes nil))

(use-package minions
  :hook (doom-modeline-mode . minions-mode))

(use-package hide-mode-line
  :hook
  (eshell-mode . hide-mode-line-mode)
  (neotree-mode . hide-mode-line-mode))

(use-package mode-line-bell
  :hook (doom-modeline-mode . mode-line-bell-mode))

(use-package centaur-tabs
  :defer 5
  :after evil
  :bind
  (:map evil-normal-state-map
        ("g t" . centaur-tabs-forward)
        ("g T" . centaur-tabs-backward))
  :config
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-height 25)
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-icon-type 'nerd-icons)
  (setq centaur-tabs-set-bar 'over)
  (centaur-tabs-mode))

(use-package winum
  :hook (after-init . winum-mode)
  :config
  (setq winum-format "[%s] ")
  (setq winum-mode-line-position 0))

(use-package vertico
  :hook (after-init . vertico-mode)
  :config
  (setq vertico-scroll-margin 0)
  (setq vertico-count 10)
  (setq vertico-resize t)
  (setq vertico-cycle t))

(use-package marginalia
  :hook (vertico-mode . marginalia-mode))

(use-package nerd-icons-completion
  :hook (marginalia-mode . nerd-icons-completion-marginalia-setup))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind
  (("C-c h". consult-history)
   ("C-s". consult-grep)
   ("C-c o". consult-outline)
   ("C-x b" . consult-buffer)))

(use-package corfu
  :hook
  ((prog-mode shell-mode eshell-mode) . corfu-mode)
  (corfu-mode . corfu-popupinfo-mode)
  :bind
  (:map corfu-map
        ([tab] . corfu-next)
        ([backtab] . corfu-previous)
        ("S-<return>" . corfu-insert)
        ("RET" . nil)
        ([remap move-end-of-line] . nil))
  :config
  (setq corfu-auto t)
  (setq corfu-auto-prefix 1)
  (setq corfu-count 10)
  (setq corfu-preview-current nil)
  (setq corfu-on-exact-match nil)
  (setq corfu-auto-delay 0.2)
  (setq corfu-popupinfo-delay '(0.4 . 0.2)))

(use-package nerd-icons-corfu
  :autoload nerd-icons-corfu-formatter
  :after corfu
  :init (add-to-list 'corfu-margin-formatters 'nerd-icons-corfu-formatter))

(use-package cape
  :after corfu
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block))

(use-package yasnippet-capf
  :after cape
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))

(use-package yasnippet-snippets
  :after yasnippet)

(use-package embark
  :bind
  (("C-." . embark-act)
   ("C-;" . embark-dwim)
   ("C-h B" . embark-bindings)))

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))

(use-package wgrep
  :commands wgrep-change-to-wgrep-mode
  :config
  (setq wgrep-auto-save-buffer t))

(use-package helpful
  :bind
  (([remap describe-command] . helpful-command)
   ([remap describe-function] . helpful-callable)
   ([remap describe-key] . helpful-key)
   ([remap describe-symbol] . helpful-symbol)
   ([remap describe-variable] . helpful-variable)
   ("C-h C-d" . helpful-at-point)))

(use-package diredfl
  :hook (dired-mode . diredfl-mode))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package colorful-mode
  :hook (prog-mode . colorful-mode))

(use-package breadcrumb
  :hook (prog-mode . breadcrumb-mode))

(use-package hl-todo
  :hook ((prog-mode yaml-mode) . hl-todo-mode)
  :config
  (setq hl-todo-highlight-punctuation ":")
  (setq hl-todo-keyword-faces '(("TODO" warning bold)
                                ("FIXME" error bold)
                                ("REVIEW" font-lock-keyword-face bold)
                                ("HACK" font-lock-constant-face bold)
                                ("DEPRECATED" font-lock-doc-face bold)
                                ("NOTE" success bold)
                                ("BUG" error bold)
                                ("XXX" font-lock-constant-face bold))))

(use-package symbol-overlay
  :hook ((prog-mode yaml-mode yaml-ts-mode) . symbol-overlay-mode)
  :bind
  (("M-i"  . symbol-overlay-put)
   ("M-I" . symbol-overlay-remove-all))
  :custom-face
  (symbol-overlay-default-face ((t (:inherit region :background unspecified :foreground unspecified))))
  (symbol-overlay-face-1 ((t (:inherit nerd-icons-blue :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-2 ((t (:inherit nerd-icons-pink :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-3 ((t (:inherit nerd-icons-yellow :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-4 ((t (:inherit nerd-icons-purple :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-5 ((t (:inherit nerd-icons-red :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-6 ((t (:inherit nerd-icons-orange :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-7 ((t (:inherit nerd-icons-green :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-8 ((t (:inherit nerd-icons-cyan :background unspecified :foreground unspecified :inverse-video t))))
  :config
  (setq symbol-overlay-idle-time 0.3))

(use-package indent-bars
  :hook ((prog-mode yaml-mode) . indent-bars-mode)
  :config
  (setq indent-bars-color '(highlight :face-bg t :blend 0.225))
  (setq indent-bars-no-descend-string t)
  (setq indent-bars-display-on-blank-lines nil)
  (setq indent-bars-prefer-character t))

(use-package diff-hl
  :hook
  (after-init . global-diff-hl-mode)
  (dired-mode . diff-hl-dired-mode))

(use-package deadgrep
  :commands deadgrep)

(use-package xclip
  :hook (after-init . xclip-mode))

(use-package gcmh
  :hook (after-init . gcmh-mode))

(use-package esup
  :commands esup
  :config
  (setq esup-depth 0))

(use-package vundo
  :commands vundo)

(use-package quickrun
  :commands quickrun
  :config
  (setq quickrun-focus-p nil)
  (setq quickrun-truncate-lines nil))

(use-package scratch
  :commands scratch)

(use-package minimap
  :commands minimap-mode
  :config
  (setq minimap-minimum-width 25)
  (setq minimap-window-location 'right))

(use-package avy
  :bind
  (("M-g l" . avy-goto-line)
   ("M-g w" . avy-goto-word-0)
   ("M-g c" . avy-goto-char-timer)))

(use-package ace-window
  :bind
  (([remap other-window] . ace-window))
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package neotree
  :commands neotree-toggle
  :config
  (setq neo-theme 'nerd-icons))

(use-package eat
  :commands eat)

(use-package magit
  :commands magit)

(use-package olivetti
  :commands olivetti-mode)

(use-package exec-path-from-shell
  :defer 10
  :when (memq window-system '(mac ns x))
  :config
  (exec-path-from-shell-initialize))

(use-package lua-mode
  :config
  (setq lua-indent-level 2)
  (setq lua-indent-nested-block-content-align nil)
  (setq lua-indent-close-paren-align nil))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package uv-mode
  :hook (python-mode . uv-mode-auto-activate-hook))

(use-package pyenv-mode
  :hook (python-mode . pyenv-mode))

(use-package anaconda-mode
  :hook (python-mode . anaconda-mode))

(use-package clojure-mode)
(use-package csv-mode)
(use-package dotenv-mode)
(use-package emmet-mode)
(use-package haskell-mode)
(use-package go-mode)
(use-package json-mode)
(use-package markdown-mode)
(use-package powershell)
(use-package rust-mode)
(use-package scss-mode)
(use-package toml-mode)
(use-package typescript-mode)
(use-package vimrc-mode)
(use-package web-mode)
(use-package yaml-mode)
(use-package zig-mode)

(use-package mason
  :hook (after-init-hook . mason-ensure))

(use-package apheleia
  :hook (prog-mode . apheleia-mode))

(use-package aggressive-indent
  :hook (emacs-lisp-mode . aggressive-indent-mode))

(use-package highlight-defined
  :hook (emacs-lisp-mode . highlight-defined-mode))

(use-package highlight-numbers
  :hook (prog-mode . highlight-numbers-mode))

(provide 'init)
;; Local Variables:
;; no-byte-compile: nil
;; End:
;;; init.el ends here
