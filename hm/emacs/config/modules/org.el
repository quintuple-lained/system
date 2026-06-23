;; -*- mode: emacs-lisp; lexical-binding: t; -*-

;;; ─── Core org ───────────────────────────────────────────────────────────────

(use-package org
  :hook ((org-mode . visual-line-mode)
         (org-mode . flyspell-mode))
  :config
  (add-to-list 'org-export-backends 'md)
  (setq org-export-with-smart-quotes t)
  (setq org-image-actual-width nil)
  (setq org-todo-keywords
        '((sequence "TODO" "PROG" "WAIT" "|" "DONE" "CNCL" "VOID")))
  (setq org-todo-keyword-faces
        '(("TODO" . "red")
          ("PROG" . "magenta")
          ("WAIT" . "orange")
          ("DONE" . "green")
          ("CNCL" . "olive drab")
          ("VOID" . "dim gray")))
  (setq org-tag-alist '((:startgroup) ("home" . ?h) ("work" . ?w) ("school" . ?s) (:endgroup)
                        (:newline)
                        (:startgroup) ("one-shot" . ?o) ("project" . ?j) ("tiny" . ?t) (:endgroup)
                        ("meta") ("review") ("reading")))
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (shell . t)
     (python . t)
     ))
  (setq org-agenda-files '("~/.emacs.d/org/")))

;;; ─── org-roam ───────────────────────────────────────────────────────────────

(use-package org-roam
  :config
  (setq org-roam-directory (file-truename "~/org-roam"))
  (setq org-roam-dailies-directory "daily/")
  (setq org-roam-dailies-capture-templates
        '(("d" "default" plain
           "%(my/org-daily-time-skeleton)"
           :target (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n#+filetags: :daily:\n\n")
           :unnarrowed t)))
  (org-roam-db-autosync-mode))

(use-package epresent)
;;; ─── Daily journal: time skeleton ───────────────────────────────────────────

(defun my/org-daily-time-skeleton ()
  "Generate 15-min time blocks from 0800 to 1800 inclusive.
Each hour is a level-1 heading. Each 15-min slot within the hour
is a level-2 child. 1800 gets only a heading, no children."
  (let ((result "")
        (hour 8))
    (while (<= hour 18)
      (setq result (concat result (format "* %02d00\n" hour)))
      (when (< hour 18)
        (setq result
              (concat result
                      (format "** %02d00\n" hour)
                      (format "** %02d15\n" hour)
                      (format "** %02d30\n" hour)
                      (format "** %02d45\n" hour))))
      (setq hour (1+ hour)))
    result))

;;; ─── Daily journal: week helpers ────────────────────────────────────────────

(defun my/journal-week-monday (decoded-time)
  "Return decoded-time for the Monday of the week containing DECODED-TIME."
  (let* ((dow (nth 6 decoded-time))
         ;; dow: 0=Sun 1=Mon 2=Tue 3=Wed 4=Thu 5=Fri 6=Sat
         (days-back (if (= dow 0) 6 (1- dow))))
    (decode-time (time-subtract (encode-time decoded-time)
                                (days-to-time days-back)))))

(defun my/journal-week-days (monday-decoded)
  "Return a list of 5 decoded-times (Mon–Fri) starting from MONDAY-DECODED."
  (mapcar (lambda (offset)
            (decode-time (time-add (encode-time monday-decoded)
                                   (days-to-time offset))))
          '(0 1 2 3 4)))

(defun my/journal-reference-monday ()
  "Return the Monday to use as the reference week for the history pane.
On Monday: previous week (current week is mostly empty).
Any other day: current week."
  (let* ((today (decode-time))
         (dow (nth 6 today)))
    (if (= dow 1)
        (my/journal-week-monday
         (decode-time (time-subtract (encode-time today) (days-to-time 7))))
      (my/journal-week-monday today))))

;;; ─── Daily journal: file helpers ────────────────────────────────────────────

(defun my/journal-daily-dir ()
  "Return the absolute path to the org-roam dailies directory."
  (expand-file-name org-roam-dailies-directory org-roam-directory))

(defun my/journal-file-path (decoded-time)
  "Return the daily org file path for DECODED-TIME."
  (expand-file-name
   (format-time-string "%Y-%m-%d.org" (encode-time decoded-time))
   (my/journal-daily-dir)))

(defun my/journal-ensure-file (decoded-time)
  "Create the daily org file for DECODED-TIME if it doesn't exist yet.
Returns the file path."
  (let* ((path (my/journal-file-path decoded-time))
         (date-str (format-time-string "%Y-%m-%d" (encode-time decoded-time))))
    (unless (file-exists-p path)
      (make-directory (my/journal-daily-dir) t)
      (with-temp-file path
        (insert (format "#+title: %s\n#+filetags: :daily:\n\n" date-str))
        (insert (my/org-daily-time-skeleton))))
    path))

;;; ─── Daily journal: history buffer ──────────────────────────────────────────

(defvar-local my/journal-week-offset 0
  "Weeks back from the reference Monday currently shown in *Journal*.")

(defun my/journal-build (week-offset)
  "Build or rebuild the *Journal* buffer at WEEK-OFFSET weeks before reference.
Week offset 0 = reference week (current or previous depending on day).
Positive offsets go further into the past."
  (let* ((ref-monday (my/journal-reference-monday))
         (target-monday
          (decode-time
           (time-subtract (encode-time ref-monday)
                          (days-to-time (* 7 week-offset)))))
         (days (my/journal-week-days target-monday))
         (buf (get-buffer-create "*Journal*")))
    (with-current-buffer buf
      (let ((inhibit-read-only t))
        (erase-buffer)
        (org-mode)
        (setq my/journal-week-offset week-offset)

        (dolist (day days)
          (let* ((ts      (encode-time day))
                 (date-str (format-time-string "%Y-%m-%d" ts))
                 (dow-str  (format-time-string "%A" ts))
                 (path     (my/journal-file-path day)))
            ;; Day separator header
            (insert (propertize
                     (format "\n══════════════════════════════════════════════\n  %s  %s\n══════════════════════════════════════════════\n\n"
                             dow-str date-str)
                     'face '(:foreground "#a89984" :weight bold))) ; gruvbox fg4
            (if (file-exists-p path)
                (progn
                  (insert-file-contents path)
                  (goto-char (point-max)))
              (insert (propertize "  (no entry for this day)\n" 'face 'shadow)))
            (insert "\n")))

        (goto-char (point-min))
        (read-only-mode 1))

      ;; Header line shows current week range + key hints
      (let* ((monday-str (format-time-string "%Y-%m-%d" (encode-time target-monday)))
             (friday     (nth 4 days))
             (friday-str (format-time-string "%Y-%m-%d" (encode-time friday))))
        (setq-local header-line-format
                    (format "  Week: %s – %s    [C-c j p] prev week    [C-c j n] next week"
                            monday-str friday-str))))
    buf))

(defun my/journal-prev-week ()
  "Show the previous week in the *Journal* history buffer."
  (interactive)
  (my/journal-build (1+ my/journal-week-offset)))

(defun my/journal-next-week ()
  "Show the next week in the *Journal* history buffer (toward present)."
  (interactive)
  (when (> my/journal-week-offset 0)
    (my/journal-build (1- my/journal-week-offset))))

;;; ─── Daily journal: entry point ─────────────────────────────────────────────

(defun my/open-daily-journal ()
  "Open the two-pane daily journal layout.

Top pane: scrollable weekly history (*Journal* buffer, read-only).
Bottom pane: today's daily org file (editable).

On Monday, history shows last week. Any other day, shows current week."
  (interactive)
  (let* ((today       (decode-time))
         (today-path  (my/journal-ensure-file today))
         (journal-buf (my/journal-build 0)))

    (delete-other-windows)

    ;; Top: history pane
    (switch-to-buffer journal-buf)
    ;; Scroll history to bottom so the most recent day is visible
    (with-current-buffer journal-buf
      (let ((inhibit-read-only t))
        (goto-char (point-max))))

    ;; Bottom: today's file
    (split-window-below)
    (other-window 1)
    (find-file today-path)

    ;; Keybinds active in the journal buffer
    (with-current-buffer journal-buf
      (local-set-key (kbd "C-c j p") #'my/journal-prev-week)
      (local-set-key (kbd "C-c j n") #'my/journal-next-week))

    ;; Leave focus on today's buffer
    (other-window 1)))

(provide 'org-config)
;;; org.el ends here
