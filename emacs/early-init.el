;;; early-init.el --- Early initialization. -*- coding: utf-8; lexical-binding: t -*-
;;; Commentary:
;;; Code:

(set-language-environment "UTF-8")
(when (or (featurep 'esup-child)
          (fboundp 'profile-dotemacs)
          (daemonp)
          (boundp 'startup-now)
          noninteractive)
  (setq package-enable-at-startup nil))
(setq gc-cons-percentage 0.6)
(setq gc-cons-threshold most-positive-fixnum)
(setq inhibit-startup-message t)
(setq frame-inhibit-implied-resize t)
(setq initial-major-mode 'fundamental-mode)
(setq custom-file (locate-user-emacs-file "custom.el"))
(setq default-frame-alist
      '((menu-bar-lines . 0)
        (tool-bar-lines . 0)
        (horizontal-scroll-bars)
        (vertical-scroll-bars)))

(provide 'early-init)
;;; early-init.el ends here
