;;; init.el --- -*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:
;;; Code:

;;; BUILTIN
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
  (setq package-quickstart t)
  (package-initialize)
  (setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
                           ("nongnu" . "https://elpa.nongnu.org/nongnu/")
                           ("melpa" . "https://melpa.org/packages/"))))

(use-package emacs
  :ensure nil
  :hook
  (minibuffer-setup-hook . (lambda () (setq gc-cons-threshold most-positive-fixnum)))
  (minibuffer-exit-hook . (lambda () (setq gc-cons-threshold 800000)))
  :config
  (setq gc-cons-percentage 0.6)
  (setq gc-cons-threshold most-positive-fixnum)
  (setq fast-but-imprecise-scrolling t)
  (setq-default truncate-lines t)
  (setq-default fill-column 80)
  (setq-default tab-width 2)
  (setq-default bidi-display-reordering nil)
  (setq-default default-text-properties '(line-spacing 0.2 line-height 1.2)))

(use-package faces
  :ensure nil
  :hook (emacs-startup . set-fonts)
  :config
  (defun set-fonts ()
    "fonts setup"
    (when (display-graphic-p)
      (cl-loop for font in '("JetbrainsMono Nerd Font" "Menlo" "Consolas")
               when (find-font (font-spec :name font))
               return (set-face-attribute 'default nil
                                          :family font
                                          :height (cond ((eq system-type 'darwin) 130)
                                                        ((eq system-type 'windows-nt) 110)
                                                        (t 100))))
      (cl-loop for font in '("JetBrainsMono Nerd Font" "Menlo" "Consolas")
               when (find-font (font-spec :name font))
               return (progn
                        (set-face-attribute 'mode-line nil :family font :height 120)
                        (when (facep 'mode-line-active)
                          (set-face-attribute 'mode-line-active nil :family font :height 120))
                        (set-face-attribute 'mode-line-inactive nil :family font :height 120)))
      (cl-loop for font in '("Apple Symbols" "Segoe UI Symbol" "Symbol")
               when (find-font (font-spec :name font))
               return (set-fontset-font t 'symbol (font-spec :family font) nil 'prepend))
      (cl-loop for font in '("Noto Color Emoji" "Apple Color Emoji" "Segoe UI Emoji")
               when (find-font (font-spec :name font))
               return (set-fontset-font t 'emoji (font-spec :family font) nil 'prepend))
      (cl-loop for font in '("LXGW WenKai Mono" "WenQuanYi Micro Hei Mono" "PingFang TC" "Microsoft Yahei UI" "Simhei")
               when (find-font (font-spec :name font))
               return (progn
                        (setq face-font-rescale-alist `((,font . 1.3)))
                        (set-fontset-font t 'han (font-spec :family font)))))))

(use-package jit-lock
  :ensure nil
  :config
  (setq jit-lock-defer-time 0.2)
  (setq jit-lock-stealth-time 1.25)
  (setq jit-lock-stealth-nice 1.0)
  (setq jit-lock-chunk-size 4096))

(use-package files
  :ensure nil
  :custom
  (make-backup-files nil)
  (auto-save-default nil))

(use-package cus-edit
  :ensure nil
  :custom
  (custom-file (concat (file-name-as-directory user-emacs-directory) "custom.el")))

(use-package paren
  :ensure nil
  :hook (prog-mode . show-paren-mode))

(use-package elec-pair
  :ensure nil
  :hook (prog-mode . electric-pair-mode))

(use-package simple
  :ensure nil
  :hook
  (prog-mode . line-number-mode)
  (prog-mode . column-number-mode)
  (prog-mode . size-indication-mode)
  (prog-mode . auto-fill-mode)
  :config
  (setq-default indent-tabs-mode nil)
  (setq idle-update-delay 1.0))

(use-package hl-line
  :ensure nil
  :hook (prog-mode . hl-line-mode))

(use-package display-line-numbers
  :ensure nil
  :hook (prog-mode . display-line-numbers-mode)
  :config
  (setq display-line-numbers-type 'relative))

(use-package display-fill-column-indicator
  :ensure nil
  :hook (prog-mode . display-fill-column-indicator-mode))

(use-package whitespace
  :ensure nil
  :hook (prog-mode . whitespace-mode)
  :config
  (setq whitespace-style '(face trailing)))

(use-package so-long
  :ensure nil
  :hook (prog-mode . global-so-long-mode)
  :config
  (setq-default so-long-threshold 2000))

(use-package autorevert
  :ensure nil
  :hook (after-init . global-auto-revert-mode))

(use-package isearch
  :ensure nil
  :config
  (setq isearch-lazy-count t)
  (setq lazy-count-prefix-format "[%s/%s]"))

(use-package saveplace
  :ensure nil
  :hook (after-init . save-place-mode))

(use-package recentf
  :ensure nil
  :hook (after-init . recentf-mode))

(use-package winner-mode
  :ensure nil
  :hook (after-init . winner-mode))

(use-package prog-mode
  :ensure nil
  :hook (prog-mode . global-prettify-symbols-mode))

(use-package ibuffer
  :ensure nil
  :bind
  (([remap list-buffers] . ibuffer))
  :config
  (setq ibuffer-expert t)
  (setq ibuffer-display-summary nil)
  (setq ibuffer-use-other-window nil)
  (setq ibuffer-show-empty-filter-groups nil)
  (setq ibuffer-movement-cycle nil)
  (setq ibuffer-default-sorting-mode 'filename/process)
  (setq ibuffer-use-header-line t)
  (setq ibuffer-default-shrink-to-minimum-size nil)
  (setq ibuffer-saved-filter-groups nil)
  (setq ibuffer-old-time 48))

(use-package delsel
  :ensure nil
  :hook
  (after-init . delete-selection-mode))

(use-package dired
  :ensure nil
  :config
  (setq dired-dwim-target t)
  (setq dired-listing-switches "-alh")
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies 'always))

(use-package which-key
  :ensure nil
  :hook (after-init . which-key-mode)
  :config
  (setq which-key-idle-delay 0.3))

(use-package treesit
  :ensure nil
  :when (and (fboundp 'treesit-available-p) (treesit-available-p))
  :config
  (setq treesit-language-source-alist
        '((bash . ("https://github.com/tree-sitter/tree-sitter-bash"))
          (c . ("https://github.com/tree-sitter/tree-sitter-c"))
          (cpp . ("https://github.com/tree-sitter/tree-sitter-cpp"))
          (css . ("https://github.com/tree-sitter/tree-sitter-css"))
          (cmake . ("https://github.com/uyha/tree-sitter-cmake"))
          (csharp . ("https://github.com/tree-sitter/tree-sitter-c-sharp.git"))
          (dockerfile . ("https://github.com/camdencheek/tree-sitter-dockerfile"))
          (elisp . ("https://github.com/Wilfred/tree-sitter-elisp"))
          (elixir "https://github.com/elixir-lang/tree-sitter-elixir" "main" "src" nil nil)
          (go . ("https://github.com/tree-sitter/tree-sitter-go"))
          (gomod . ("https://github.com/camdencheek/tree-sitter-go-mod.git"))
          (haskell "https://github.com/tree-sitter/tree-sitter-haskell" "master" "src" nil nil)
          (html . ("https://github.com/tree-sitter/tree-sitter-html"))
          (java . ("https://github.com/tree-sitter/tree-sitter-java.git"))
          (javascript . ("https://github.com/tree-sitter/tree-sitter-javascript"))
          (json . ("https://github.com/tree-sitter/tree-sitter-json"))
          (lua . ("https://github.com/Azganoth/tree-sitter-lua"))
          (make . ("https://github.com/alemuller/tree-sitter-make"))
          (markdown . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown/src"))
          (markdown-inline . ("https://github.com/tree-sitter-grammars/tree-sitter-markdown" "split_parser" "tree-sitter-markdown-inline/src"))
          (ocaml . ("https://github.com/tree-sitter/tree-sitter-ocaml" nil "ocaml/src"))
          (org . ("https://github.com/milisims/tree-sitter-org"))
          (python . ("https://github.com/tree-sitter/tree-sitter-python"))
          (php . ("https://github.com/tree-sitter/tree-sitter-php"))
          (typescript . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "typescript/src"))
          (tsx . ("https://github.com/tree-sitter/tree-sitter-typescript" nil "tsx/src"))
          (ruby . ("https://github.com/tree-sitter/tree-sitter-ruby"))
          (rust . ("https://github.com/tree-sitter/tree-sitter-rust"))
          (sql . ("https://github.com/m-novikov/tree-sitter-sql"))
          (scala "https://github.com/tree-sitter/tree-sitter-scala" "master" "src" nil nil)
          (toml "https://github.com/tree-sitter/tree-sitter-toml" "master" "src" nil nil)
          (vue . ("https://github.com/merico-dev/tree-sitter-vue"))
          (kotlin . ("https://github.com/fwcd/tree-sitter-kotlin"))
          (yaml . ("https://github.com/ikatyang/tree-sitter-yaml"))
          (zig . ("https://github.com/GrayJack/tree-sitter-zig"))
          (clojure . ("https://github.com/sogaiu/tree-sitter-clojure"))
          (nix . ("https://github.com/nix-community/nix-ts-mode"))
          (mojo . ("https://github.com/HerringtonDarkholme/tree-sitter-mojo")))))

(use-package uniquify
  :ensure nil
  :config
  (setq uniquify-buffer-name-style 'reverse)
  (setq uniquify-separator " • ")
  (setq uniquify-after-kill-buffer-p t)
  (setq uniquify-ignore-buffers-re "^\\*"))

;;; EVIL
(use-package evil
  :init (setq evil-want-keybinding nil)
  :hook (after-init . evil-mode)
  :config
  (setq evil-want-C-d-scroll t)
  (setq evil-want-C-u-scroll t))

(use-package evil-leader
  :hook (evil-mode . global-evil-leader-mode)
  :config
  (evil-leader/set-leader "<SPC>")
  (evil-leader/set-key
    "<SPC>" 'counsel-M-x
    "ff" 'counsel-find-file
    "fb" 'counsel-switch-buffer
    "fs" 'swiper-isearch
    "fw" 'counsel-grep-or-swiper
    "fr" 'counsel-recentf
    "fo" 'counsel-outline
    "fc" 'counsel-load-theme
    "fy" 'counsel-flycheck
    "hf" 'helpful-callable
    "hk" 'helpful-key
    "hp" 'helpful-at-point
    "hx" 'helpful-command
    "hv" 'helpful-variable
    "ww" 'ace-window
    "wo" 'delete-other-windows
    "wd" 'delete-window
    "tt" 'emacs-init-time
    "tr" 'quickrun
    "tn" 'neotree-toggle
    "tm" 'minimap-mode
    "tw" 'writeroom-mode
    "0" 'winum-select-window-0-or-10
    "1" 'winum-select-window-1
    "2" 'winum-select-window-2
    "3" 'winum-select-window-3
    "4" 'winum-select-window-4
    "5" 'winum-select-window-5
    "6" 'winum-select-window-6
    "7" 'winum-select-window-7
    "8" 'winum-select-window-8
    "9" 'winum-select-window-9))

(use-package evil-escape
  :hook (evil-mode . evil-escape-mode)
  :config
  (setq-default evil-escape-key-sequence "jk")
  (setq-default evil-escape-delay 0.2))

(use-package evil-collection
  :hook (evil-mode . (lambda () (evil-collection-init))))

(use-package evil-nerd-commenter
  :after evil
  :bind
  (:map evil-normal-state-map
        (("gcc" . evilnc-comment-or-uncomment-lines)))
  (:map evil-visual-state-map
        (("gc" . evilnc-comment-or-uncomment-lines))))

(use-package evil-matchit
  :hook (evil-mode . global-evil-matchit-mode))

(use-package evil-visualstar
  :hook (evil-mode . global-evil-visualstar-mode))

(use-package evil-goggles
  :hook (evil-mode . evil-goggles-mode)
  :config
  (setq evil-goggles-duration 0.500))

(use-package evil-surround
  :hook (evil-mode . evil-surround-mode))

(use-package evil-args
  :after evil
  :bind
  (:map evil-inner-text-objects-map
        ("a" . evil-inner-arg))
  (:map evil-outer-text-objects-map
        ("a" . evil-outer-arg))
  (:map evil-normal-state-map
        ("H" . evil-backward-arg)
        ("L" . evil-forward-arg))
  (:map evil-motion-state-map
        ("H" . evil-backward-arg)
        ("L" . evil-forward-arg)))

(use-package evil-indent-plus
  :after evil
  :bind
  (:map evil-inner-text-objects-map
        ("i" . evil-indent-plus-i-indent)
        ("I" . evil-indent-plus-i-indent-up)
        ("J" . evil-indent-plus-i-indent-up-down))
  (:map evil-outer-text-objects-map
        ("i" . evil-indent-plus-a-indent)
        ("I" . evil-indent-plus-a-indent-up)
        ("J" . evil-indent-plus-a-indent-up-down)))

(use-package evil-snipe
  :hook
  (evil-mode . evil-snipe-mode)
  (evil-mode . evil-snipe-override-mode)
  :config
  (setq evil-snipe-scope 'whole-buffer)
  (setq evil-snipe-repeat-scope 'whole-buffer))

;;; UI
(use-package dashboard
  :hook (after-init . dashboard-setup-startup-hook)
  :config
  (setq dashboard-startup-banner 'logo)
  (setq dashboard-center-content t)
  (setq dashboard-vertically-center-content t)
  (setq dashboard-navigation-cycle t)
  (setq dashboard-show-shortcuts t)
  (setq dashboard-display-icons-p t)
  (setq dashboard-icon-type 'nerd-icons)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-icon-file-height 1.75)
  (setq dashboard-icon-file-v-adjust -0.125)
  (setq dashboard-heading-icon-height 1.75)
  (setq dashboard-heading-icon-v-adjust -0.125))

(use-package doom-themes
  :hook (after-init . (lambda () (load-theme 'doom-one t)))
  :config
  (setq doom-themes-enable-bold t)
  (setq doom-themes-enable-italic t)
  (doom-themes-visual-bell-config))

(use-package solaire-mode
  :defer 5
  :config
  (solaire-global-mode))

(use-package doom-modeline
  :hook (after-init . doom-modeline-mode)
  :config
  (setq doom-modeline-height 25)
  (setq doom-modeline-bar-width 5)
  (setq doom-modeline-enable-word-count nil)
  (setq doom-modeline-minor-modes t))

(use-package hide-mode-line
  :hook
  (neotree-mode . hide-mode-line-mode)
  (shell-mode . hide-mode-line-mode)
  (eshell-mode . hide-mode-line-mode))

(use-package minions
  :hook (doom-modeline-mode . minions-mode))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package colorful-mode
  :hook (prog-mode . colorful-mode))

(use-package indent-bars
  :hook ((prog-mode yaml-mode) . indent-bars-mode)
  :config
  (setq indent-bars-color '(highlight :face-bg t :blend 0.425))
  (setq indent-bars-no-descend-string t)
  (setq indent-bars-prefer-character t)
  (setq indent-bars-display-on-blank-lines nil))

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

(use-package diredfl
  :hook (dired-mode . diredfl-mode))

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))

(use-package centaur-tabs
  :after evil
  :hook (prog-mode . centaur-tabs-mode)
  :bind
  (:map evil-normal-state-map
        ("gt" . centaur-tabs-forward)
        ("gT" . centaur-tabs-backward))
  :config
  (setq centaur-tabs-height 25)
  (setq centaur-tabs-style "bar")
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-icon-type 'nerd-icons)
  (setq centaur-tabs-set-bar 'left))

(use-package beacon
  :hook (after-init . beacon-mode)
  :config
  (setq beacon-size 60)
  (setq beacon-color (face-attribute 'nerd-icons-red :foreground))
  (setq beacon-blink-duration 0.6)
  (setq beacon-blink-delay 0.6)
  (setq beacon-blink-when-window-scrolls t)
  (setq beacon-blink-when-window-changes t)
  (setq beacon-blink-when-point-moves t)
  (setq beacon-blink-when-point-moves-vertically 6)
  (setq beacon-blink-when-point-moves-horizontally 6))

(use-package which-key-posframe
  :when (display-graphic-p)
  :hook (which-key-mode . which-key-posframe-mode)
  :custom-face
  (which-key-posframe-border ((t (:inherit cursor :background unspecified :foreground unspecified))))
  :config
  (setq which-key-posframe-poshandler 'posframe-poshandler-window-center)
  (setq which-key-posframe-parameters '((left-fringe . 12) (right-fringe . 12))))

;;; TOOL
(use-package avy
  :bind
  (("M-g l" . avy-goto-line)
   ("M-g w" . avy-goto-word-0)
   ("M-g c" . avy-goto-char-timer)))

(use-package diff-hl
  :hook
  (prog-mode . global-diff-hl-mode)
  (prog-mode . global-diff-hl-show-hunk-mouse-mode)
  (dired-mode . diff-hl-dired-mode))

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
  :hook ((prog-mode yaml-mode) . symbol-overlay-mode)
  :bind (("M-i" . symbol-overlay-put)
         ("M-N" . symbol-overlay-switch-forward)
         ("M-P" . symbol-overlay-switch-backward)
         ("M-R" . symbol-overlay-remove-all))
  :custom-face
  (symbol-overlay-default-face ((t (:inherit region :background unspecified :foreground unspecified))))
  (symbol-overlay-face-1 ((t (:inherit nerd-icons-blue :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-2 ((t (:inherit nerd-icons-pink :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-3 ((t (:inherit nerd-icons-yellow :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-4 ((t (:inherit nerd-icons-purple :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-5 ((t (:inherit nerd-icons-red :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-6 ((t (:inherit nerd-icons-orange :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-7 ((t (:inherit nerd-icons-green :background unspecified :foreground unspecified :inverse-video t))))
  (symbol-overlay-face-8 ((t (:inherit nerd-icons-cyan :background unspecified :foreground unspecified :inverse-video t)))))

(use-package envrc
  :hook (after-init . envrc-global-mode))

(use-package xclip
  :hook (after-init . xclip-mode))

(use-package gcmh
  :hook (after-init . gcmh-mode))

(use-package helpful
  :bind
  (("C-h f" . helpful-callable)
   ("C-h v" . helpful-variable)
   ("C-h k" . helpful-key)
   ("C-h x" . helpful-commad)
   ("C-h C-p" . helpful-at-point)))

(use-package ace-window
  :bind ([remap other-window] . ace-window)
  :config
  (setq aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l)))

(use-package winum
  :hook (doom-modeline-mode . winum-mode))

(use-package expand-region
  :bind ("C-=" . er/expand-region))

(use-package exec-path-from-shell
  :when (memq window-system '(mac ns x))
  :defer 5
  :config
  (exec-path-from-shell-initialize))

(use-package neotree
  :bind ("<f8>" . neotree-toggle)
  :config
  (setq neo-theme 'nerd-icons))

(use-package quickrun
  :commands (quickrun)
  :config
  (setq quickrun-focus-p nil)
  (setq quickrun-truncate-lines nil))

(use-package vundo
  :commands vundo)

(use-package esup
  :commands esup
  :config
  (setq esup-depth 0))

(use-package benchmark-init)

(use-package minimap
  :commands minimap-mode
  :config
  (setq minimap-window-location 'right)
  (setq minimap-minimum-width 10)
  (setq minimap-update-delay 0.3)
  (setq minimap-width-fraction 0.13))

(use-package writeroom-mode
  :commands writeroom-mode
  :config
  (setq split-width-threshold 120)
  (setq writeroom-width 128)
  (setq writeroom-bottom-divider-width 0)
  (setq writeroom-fringes-outside-margins t))

(use-package eat
  :commands eat)

(use-package scratch
  :commands scratch)

(use-package eshell-syntax-highlighting
  :hook (eshell-mode . eshell-syntax-highlighting-global-mode))

(use-package esh-autosuggest
  :hook (eshell-mode . esh-autosuggest-mode))

(use-package magit
  :commands magit)

;;; COMPLETION
(use-package ivy
  :hook (after-init . ivy-mode)
  :config
  (setq ivy-use-virutal-buffers t)
  (setq enable-recursive-minibuffers t)
  (setq ivy-height (cond ((display-graphic-p) 20) (t 13)))
  (setq ivy-initial-inputs-alist nil)
  (setq ivy-count-format "[%d/%d]")
  (setq ivy-re-builders-alist `((t . ivy--regex-ignore-order))))

(use-package ivy-posframe
  :when (display-graphic-p)
  :hook (ivy-mode . ivy-posframe-mode)
  :custom-face
  (ivy-posframe-border ((t (:inherit cursor :background unspecified :foreground unspecified))))
  :config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-window-center)))
  (setq ivy-posframe-parameters '((left-fringe . 12) (right-fringe . 12))))

(use-package counsel
  :hook (ivy-mode . counsel-mode)
  :bind
  (("M-g r" . counsel-rg)))

(use-package swiper
  :after ivy
  :bind (([remap isearch-forward] . swiper-isearch)))

(use-package amx
  :hook (ivy-mode . amx-mode))

(use-package wgrep
  :after ivy
  :config
  (setq wgrep-auto-save-buffer t))

(use-package ivy-rich
  :hook (ivy-mode . ivy-rich-mode))

(use-package nerd-icons-ivy-rich
  :hook (ivy-mode . nerd-icons-ivy-rich-mode))

(use-package company
  :hook (prog-mode . global-company-mode)
  :config
  (setq company-idle-delay 0.2)
  (setq company-tooltip-idle-delay 10)
  (setq company-require-match nil)
  (setq company-tooltip-align-annotations t)
  (setq company-tooltip-annotation-padding 4)
  (setq company-tooltip-margin 2)
  (setq company-tooltip-limit 12)
  (setq company-format-margin-function 'company-vscode-dark-icons-margin)
  (setq company-icon-margin 4)
  (setq company-text-icons-add-background t)
  (setq company-minimum-prefix-length 1)
  (setq company-global-modes '(not
                               shell-mode
                               eshell-mode
                               minibuffer-inactive-mode))
  (setq company-backends '((company-capf :with company-yasnippet)
                           (company-lsp :with company-yasnippet)
                           company-dabbrev-code
                           company-dabbrev
                           company-files
                           company-keywords)))

(use-package company-quickhelp
  :when (display-graphic-p)
  :hook (company-mode . company-quickhelp-mode))

(use-package company-posframe
  :when (display-graphic-p)
  :hook (company-mode . company-posframe-mode))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode))

(use-package yasnippet-snippets
  :after yasnippet)

;;; LANGUAGE
(use-package lua-mode
  :config
  (setq lua-indent-level 2)
  (setq lua-indent-nested-block-content-align nil)
  (setq lua-indent-close-paren-align nil))

(use-package pyvenv)
(use-package uv-mode)
(use-package cmake-mode)
(use-package clojure-mode)
(use-package csv-mode)
(use-package dotenv-mode)
(use-package json-mode)
(use-package toml-mode)
(use-package markdown-mode)
(use-package yaml-mode)
(use-package vimrc-mode)
(use-package nix-mode)
(use-package web-mode)
(use-package emmet-mode)
(use-package typescript-mode)
(use-package go-mode)
(use-package rust-mode)
(use-package powershell)

;;; SYNTAX CHECKING
(use-package flycheck
  :hook (prog-mode . global-flycheck-mode)
  :bind
  (("M-n" . flycheck-next-error)
   ("M-p" . flycheck-previous-error)))

(use-package flycheck-posframe
  :when (display-graphic-p)
  :hook (flycheck-mode . flycheck-posframe-mode)
  :custom-face
  (flycheck-posframe-border-face ((t (:inherit nerd-icons-red :background unspecified :foreground unspecified))))
  :config
  (setq flycheck-posframe-border-width 1))

;;; LSP & DAP
(use-package lsp-mode)
(use-package lsp-ui)
(use-package dap-mode)
(use-package dape)

;;; FORMATTER
(use-package format-all
  :commands format-all-mode)

(provide 'init)
;;; init.el ends here
