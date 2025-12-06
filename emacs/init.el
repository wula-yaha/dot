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
  :init
  (when (eq system-type 'windows-nt)
    (defun package-user-all-dir ()
      (file-name-concat package-user-dir "all"))
    (define-advice package-unpack (:around (ofun pkg-desc) ADV)
      (let ((pkg-dir (funcall ofun pkg-desc)))
	      (when-let* (pkg-dir
                    (pkg-file (format "%s-pkg.el" (package-desc-name pkg-desc)))
                    (files (seq-difference (directory-files pkg-dir)
                                           '("." "..") 'string=))
                    (target-dir (file-name-as-directory (package-user-all-dir))))
          (make-directory target-dir t)
          (unless (seq-intersection files (directory-files target-dir) #'string=)
            (with-current-buffer (find-file-noselect (file-name-concat pkg-dir pkg-file))
              (goto-char (point-max))
              (when (re-search-backward ")" nil t)
		            (newline-and-indent)
		            (insert (format ":files '%S" (remove pkg-file files)))
		            (save-buffer))
              (kill-buffer))
            (dolist (file files)
              (rename-file (expand-file-name file pkg-dir) target-dir))
            (delete-directory pkg-dir)
            (setf (package-desc-dir (car (alist-get (package-desc-name pkg-desc)
                                                    package-alist)))
                  target-dir)
            (setq pkg-dir target-dir)))
	      pkg-dir))
    (define-advice package-load-all-descriptors (:after () ADV)
      (when-let* ((pkg-dir (package-user-all-dir))
                  ((file-directory-p pkg-dir)))
	      (dolist (pkg-file (directory-files pkg-dir t ".*-pkg.el"))
          (cl-letf (((symbol-function 'package--description-file)
                     (lambda (_) pkg-file)))
            (package-load-descriptor pkg-dir)))))
    (define-advice package-delete (:around (ofun pkg-desc &optional force nosave) ADV)
      (if (string-prefix-p (package-user-all-dir)
                           (package-desc-dir pkg-desc))
          (cl-letf* ((default-directory (package-user-all-dir))
                     (pkg-file (format "%s-pkg.el" (package-desc-name pkg-desc)))
                     ((symbol-function 'package--delete-directory)
                      (lambda (x)
			                  (with-current-buffer (find-file-noselect pkg-file)
                          (goto-char (point-min))
                          (when (re-search-forward ":files '\\((.*)\\)" nil t)
                            (dolist (file (read (match-string 1)))
                              (delete-file file))))
			                  (delete-file pkg-file))))
            (funcall ofun pkg-desc force nosave))
	      (funcall ofun pkg-desc force nosave))))
  :config
  (setq-default gc-cons-threshold most-positive-fixnum)
  (setq-default gc-cons-percentage 0.6)
  (setq-default use-short-answers t)
  (setq-default display-line-numbers 'relative)
  (setq-default bidi-display-reordering nil)
  (setq-default bidi-inhibit-bpa t)
  (setq-default long-line-threshold 1000)
  (setq-default large-hscroll-threshold 1000)
  (setq-default default-text-properties '(line-spacing 0.2 line-height 1.2))
  (setq-default debug-on-error t)
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

(use-package winner-mode
  :ensure nil
  :hook (after-init . winner-mode))

(use-package whitespace
  :ensure nil
  :hook ((prog-mode markdown-mode conf-mode) . whitespace-mode)
  :config
  (setq whitespace-style '(face trailing)))

(use-package so-long
  :ensure nil
  :hook (after-init . global-so-long-mode))

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

(use-package isearch
  :ensure nil
  :config
  (setq isearch-lazy-count t)
  (setq lazy-highlight-cleanup nil)
  (setq lazy-count-prefix-format "[%s/%s]"))

(use-package subword
  :ensure nil
  :hook (after-init . global-subword-mode))

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
							                                          ((eq system-type 'windows-nt) 110)
							                                          (t 100))))
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

(use-package evil-matchit
  :hook (evil-mode . global-evil-matchit-mode))

(use-package color-theme-sanityinc-tomorrow
  :hook (after-init . (lambda () (load-theme 'sanityinc-tomorrow-bright t))))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package vertico
  :hook (after-init . vertico-mode)
  :config
  (setq vertico-scroll-margin 0)
  (setq vertico-count 10)
  (setq vertico-resize t)
  (setq vertico-cycle t))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-defaults nil)
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :bind
  (("C-s" . consult-line)
   ("C-c h". consult-history)
   ("C-c r". consult-ripgrep)
   ("C-c o". consult-outline)
   ("C-x b" . consult-buffer)))

(use-package corfu
  :hook
  ((prog-mode shell-mode eshell-mode) . corfu-mode)
  (corfu-mode . corfu-popupinfo-mode)
  (corfu-mode . corfu-history-mode)
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

(use-package colorful-mode
  :hook
  (prog-mode . colorful-mode))

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

(use-package diff-hl
  :hook
  (after-init . global-diff-hl-mode)
  (dired-mode . diff-hl-dired-mode))

(use-package xclip
  :hook (after-init . xclip-mode))

(use-package gcmh
  :hook (after-init . gcmh-mode))

(provide 'init)
;; Local Variables:
;; no-byte-compile: nil
;; End:
;;; init.el ends here
