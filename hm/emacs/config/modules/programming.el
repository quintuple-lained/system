;; -*- mode: emacs-lisp; lexical-binding: t; -*-

(use-package eglot
  :ensure nil
  :hook ((python-mode . eglot-ensure)
	 (python-ts-mode . eglot-ensure)
	 (rust-mode . eglot-ensure)
	 (clojure-mode . eglot-ensure))
  :config
  (add-to-list 'eglot-server-programs
               '((python-mode python-ts-mode) . ("ruff" "server")))
  (add-to-list 'eglot-server-programs
               '(clojure-mode . ("clojure-lsp")))
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nixd")))

  ;; let corfu handle completion UI, not eglot's default
  (setq eglot-stay-out-of '(eldoc))
  ;; faster completions — don't wait for server idle
  (setq eglot-send-changes-idle-time 0.1))

;;; Ruff formatting on save (separate from eglot's code actions)
(defun my/ruff-format-buffer ()
  "Format the current buffer with ruff format via shell command."
  (when (and (derived-mode-p 'python-mode 'python-ts-mode)
             (executable-find "ruff"))
    (let ((point-pos (point))
          (window-start-pos (window-start)))
      (shell-command-on-region (point-min) (point-max)
                               "ruff format --stdin-filename buffer.py -"
                               (current-buffer) t
                               "*ruff-format-errors*" t)
      (goto-char point-pos)
      (set-window-start (selected-window) window-start-pos))))

(add-hook 'python-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'my/ruff-format-buffer nil t)))
(add-hook 'python-ts-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'my/ruff-format-buffer nil t)))

;;; Completion — corfu + cape for a better capf pipeline
(use-package corfu
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.15)
  (corfu-auto-prefix 2)
  (corfu-cycle t)
  (corfu-quit-no-match 'separator)
  (corfu-preselect 'prompt)
  :init
  (global-corfu-mode))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-default-face 'corfu-default)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

(use-package cape
  :after eglot
  :config
  (add-hook 'eglot-managed-mode-hook
            (lambda ()
              (setq-local completion-at-point-functions
                          (list (cape-capf-super
                                 #'eglot-completion-at-point
                                 #'cape-dabbrev)
                                #'cape-file)))))

;;; Eldoc — hover at point instead of random floating box
(use-package eldoc-box
  :hook (eglot-managed-mode . eldoc-box-hover-at-point-mode))

;;; Terminal
(use-package vterm
  :config
  (setq vterm-shell (executable-find "fish"))
  )

(use-package markdown-mode
  :hook (markdown-mode . visual-line-mode)
  )

(use-package rustic
  :config
  (setq rust-format-on-save t)
  :custom
  (rustic-cargo-use-last-stored-arguments t))

(use-package aggressive-indent
  :config
  (global-aggressive-indent-mode 1))

(use-package yaml-mode)
(use-package json-mode)

; holy FUCK this is not how i want my code to look, maybe another day
;(use-package elisp-autofmt
; :commands (elisp-autofmt-mode elisp-autofmt-buffer)
;  :hook (emacs-lisp-mode . elisp-autofmt-mode)
;  )

;; kubernetes stuff here
(use-package k8s-mode
  :ensure t
  :hook (k8s-mode . yas-minor-mode)
  )
;; python stuff here
(use-package python
  :ensure nil
  :mode ("\\.py\\'" . python-mode)
  :interpreter ("python" . python-mode))

(use-package paredit
  :hook (prog-mode . paredit-mode)
  )
;; neat idea but i dont want to deal with you anymore
;;(use-package uv-mode
;;  :hook (python-mode . uv-auto-activate-hook)
;;  )

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; clojure support
(use-package clojure-mode
  :mode ("\\.clj\\'" . clojure-mode))

(use-package cider
  :hook (clojure-mode . cider-mode)
  :config
  (setq cider-repl-display-help nil
        cider-repl-pop-to-buffer-on-connect t
        cider-repl-use-pretty-printing t
        cider-font-lock-dynamically t
        cider-save-file-on-load t
        cider-repl-history-file (expand-file-name "cider-history" user-emacs-directory))
  (add-hook 'cider-mode-hook #'eldoc-mode))

;;; Kubernetes
(use-package k8s-mode
  :ensure t
  :hook (k8s-mode . yas-minor-mode))

;;; File tree
(use-package treemacs
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)
	)
  )

(use-package breadcrumb
  :config (breadcrumb-mode 1)
  )

(use-package consult-lsp
  :bind (("M-S l" . consult-lsp-symbols))
  )

;; nix support — parity with the nixvim setup (nixd LSP + nixfmt on save)
(use-package nix-mode
  :mode "\\.nix\\'")

(defun my/nixfmt-format-buffer ()
  "Format the current buffer with nixfmt via shell command."
  (when (and (derived-mode-p 'nix-mode)
             (executable-find "nixfmt"))
    (let ((point-pos (point))
          (window-start-pos (window-start)))
      (shell-command-on-region (point-min) (point-max)
                               "nixfmt"
                               (current-buffer) t
                               "*nixfmt-errors*" t)
      (goto-char point-pos)
      (set-window-start (selected-window) window-start-pos))))

(add-hook 'nix-mode-hook
          (lambda ()
            (add-hook 'before-save-hook #'my/nixfmt-format-buffer nil t)))

(provide 'programming)
;; many more to come
