;; -*- mode: emacs-lisp; lexical-binding: t; -*-

;; good ol gruvbox
(use-package base16-theme)
(load-theme 'base16-gruvbox-dark-soft t)

(blink-cursor-mode 0)
(scroll-bar-mode 0)
(tool-bar-mode 0)
(menu-bar-mode 0)
(global-hl-line-mode 1)
(global-display-line-numbers-mode 1)
(setq visible-bell t)


(use-package nyan-mode
  :if (display-graphic-p)
  :config
  (setq nyan-wavy-trail t)
  (nyan-mode 1))

;; modeline stuff
(setq line-number-mode t)
(setq column-number-mode t)

;; things that are neat
(setq x-underline-at-descent-line nil)
(setq-default show-trailing-whitespace t)

;; git highlights my beloved
(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

(use-package dashboard
  :ensure t
  :config
  (defvar my-custom-strings '("there is more in life than work, like working on your emacs config!"
                              "have you considered that it might be a skill issue?"
                              "There you go, it was a skill issue!"
                              "Only three things are inevitable in life: death, taxes and emacs config changes"
                              "I use gentoo btw"
                              "But what are the civilian appications?"
                              "Needs more ricing"
                              "I killed that buffer a long time ago"
                              "i made a new emacs tutorial video, its around one and a half... years long, i can send it to you via ftp"
                              "but emacs is not a text editor"
                              "DNA sequencing? emacs!"
                              "with jupiter you're modifying the states of the program, with emacs youre modifying the state of the art"
                              "saying emacs will die is like saying turing complete will die"
                              "ive also been diagnosed with severe hostility to vim users, but thats not a real disease of course, the real disease is vim"
                              "i dont have an ego! i killed that buffer a long time ago"
                              "i think stictly in elisp"
                              "you control undo the undo"
                              "i treat my whole life like a text buffer"
                              "lex freedman doesnt use emacs anymore? where is my deathnote..."
                              "vim is for dark people"
                              "space emacs? what are you, 5?"
                              "yeah you can do this in emacs, i mean i cant imagine wanting this but a mans emacs is his castle"
                              "you can bind the keybindings to shorter keybindings"
                              "but i will always use magit tho"
                              "oh that deletes the region, it doesnt kill it"
                              "no i want to keep modding so its fun when i start working"
                              "the only thing i do in this department is fix peoples emacs"
                              "people never quit emacs, they just die at some point"))

  (defvar my-banner-images (list (expand-file-name "assets/gentoo_logo500.png" user-emacs-directory)
                                 (expand-file-name "assets/emacs_logo.png" user-emacs-directory)
                                 (expand-file-name "assets/gnu_logo.png" user-emacs-directory)
                                 (expand-file-name "assets/lisp_logo.png" user-emacs-directory)))
  (setq dashboard-icon-file-height 0.5)

  (defvar my-banner-titles '("My Emacs config: writing a clusterfuck, one commit at a time"
                             "Emacs: The only IDE that's also an operating system"
                             "Emacs: Because why use many tools when one can do it all?"
                             "Emacs: Making simple tasks complex since 1976"
                             "Emacs: ofcourse theres a package for that"
                             "Emacs: almost an operating system"
                             "Emacs: Where 'scratch' is a buffer, not just an itch"))

  (defun random-element (list)
    "Return a random element from LIST."
    (nth (random (length list)) list))

  (defun set-random-dashboard-elements ()
    "Set random elements for the dashboard."
    (setq dashboard-banner-logo-title (random-element my-banner-titles))
    (setq dashboard-startup-banner (random-element my-banner-images)))

  (add-hook 'dashboard-mode-hook #'set-random-dashboard-elements)

  (setq dashboard-set-footer t
        dashboard-footer-messages my-custom-strings)
  (setq dashboard-items '((recents . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)
                          (registers . 5)))
  ;; Ensure all-the-icons is installed for this to work
  ;; M-x all-the-icons-install-fonts
  (setq dashboard-icon-type 'all-the-icons)
  (setq dashboard-center-content t)
  (dashboard-setup-startup-hook))

(use-package magit)
