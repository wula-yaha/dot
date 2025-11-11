;;; early-init.el --- -*- lexical-binding: t no-byte-compile: t -*-
;;; Commentary:
;;; Code:

(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq-default buffer-file-coding-system 'utf-8-unix)
(setq load-prefer-newer noninteractive)
(when (or (daemonp) (boundp 'startup-now) (featurep 'esup-child) noninteractive)
  (setq package-enable-at-startup nil))
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum)
(setq inhibit-startup-message t)
(setq inhibit-startup-screen t)
(setq frame-inhibit-implied-resize t)
(setq initial-major-mode 'fundamental-mode)
(setq file-name-handler-alist nil)
(setq default-frame-alist '((width . 180)
                            (height . 55)
                            (menu-bar-lines . 0)
                            (tool-bar-lines . 0)
                            (horizontal-scroll-bars)
                            (vertical-scroll-bars)))

(provide 'early-init)
;;; early-init.el ends here
