;; -*- mode: emacs-lisp; lexical-binding: t; -*-

(defun my/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds" (float-time (time-subtract after-init-time before-init-time)))
           gcs-done))
(add-hook 'emacs-startup-hook #'my/display-startup-time)

;; customize management
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(when (file-exists-p custom-file)
  (load custom-file))

;; straight el bootstrap
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)
(straight-use-package 'org)
(set-face-attribute 'default nil :font "AnonymicePro Nerd Font-12")

;; module loading stuff
(defun load-module (name)
  (let ((file (expand-file-name (format "modules/%s.el" name) user-emacs-directory)))
    (if (file-exists-p file)
        (load file)
      (message "Module %s not found" name))))

;; core modules, although some might have to move to system specific ones
(load-module "editor")
(load-module "programming")
(load-module "org")
(load-module "ui")

(add-hook 'emacs-start
	  (lambda ()
	    (setq gc-cons-threshold (* 16 1024 1024)
		  gc-cons-percentage 0.1)))

;; emacs put these here so ig they should be here
(put 'downcase-region 'disabled nil)
