;; -*- mode: emacs-lisp; lexical-binding: t; -*-

;;; editor.el --- General editor configuration

;;; General defaults
(use-package emacs
  :init
  (defalias 'yes-or-no-p 'y-or-n-p)
  (pixel-scroll-precision-mode)
  (global-auto-revert-mode t)

  :custom
  (initial-major-mode 'fundamental-mode)
  (sentence-end-double-space nil)
  (explicit-shell-file-name (executable-find "fish"))
  (auto-revert-check-vc-info t)
  (switch-to-buffer-obey-display-actions t)
  (make-backup-files nil)

  ;; line and column display
  (line-number-mode t)
  (column-number-mode t)
  (fill-column 80)
  (display-fill-column-indicator-column 80)

  ;; completion
  (completion-cycle-threshold 1)
  (completions-detailed t)
  (tab-always-indent 'complete)
  (completion-styles '(basic initials substring))
  (completion-auto-help 'always)
  (completions-max-height 20)
  (completions-format 'one-column)
  (completions-group t)
  (completion-auto-select 'second-tab)

  :config
  (global-display-line-numbers-mode 1)
  (global-display-fill-column-indicator-mode 1)
  (global-unset-key (kbd "C-z")))
  (setq dired-dwim-target t)

;;; Autosaves
(defvar autosave-dir (expand-file-name "~/.emacs-autosaves/"))
(unless (file-exists-p autosave-dir) (make-directory autosave-dir t))
(setq auto-save-filename-transforms `((".*" ,autosave-dir t)))

;;; Custom functions
(defun reload-emacs-conf ()
  "Reload the Emacs config."
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory))
  (message "Reloaded emacs config"))

(defun toggle-window-split ()
  "Toggle between horizontal and vertical split for two windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges) (car next-win-edges))
                                     (<= (cadr this-win-edges) (cadr next-win-edges)))))
             (splitter (if (= (car this-win-edges) (car (window-edges (next-window))))
                          'split-window-horizontally
                        'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

;;; Keybinds
(define-key global-map (kbd "C-x C-o") (kbd "C-x o"))       ;; switch window
(define-key global-map (kbd "C-o") (kbd "C-e RET"))          ;; new line below
(define-key global-map (kbd "C-S-o") (kbd "C-p C-e RET"))    ;; new line above
(define-key global-map (kbd "M-j") (kbd "C-u M-^"))          ;; join line
(global-set-key (kbd "C-x |") 'toggle-window-split)

;;; Packages

(use-package vertico
  :init (vertico-mode)
  :custom (vertico-cycle t))

(use-package savehist
  :init (savehist-mode 1))

(use-package marginalia
  :init (marginalia-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

(use-package consult
  :bind (("C-s"   . consult-line)
         ("C-x b" . consult-buffer)
         ("M-y"   . consult-yank-pop)))

(use-package avy
  :bind ("C-<tab>" . avy-goto-char-timer)
  :config (setq avy-timeout-seconds 0.3))

(use-package smartparens
  :bind (("<localleader>("   . sp-wrap-round)
         ("<localleader>{"   . sp-wrap-curly)
         ("<localleader>["   . sp-wrap-square)
         ("<localleader>DEL" . sp-splice-sexp-killing-backward)))

(use-package multiple-cursors
  :bind (("M-<down>" . mc/mark-next-like-this)
         ("M-<up>"   . mc/mark-previous-like-this)))

(use-package which-key
  :ensure t
  :diminish which-key-mode
  :init (which-key-mode)
  :config (setq which-key-idle-delay 0.3))

(use-package move-text
  :config (move-text-default-bindings))

(provide 'editor)
;;; editor.el ends here
