;; My lightweight emacs init
;; Should work on emacs 26.1
;; Requires no packages, additional files or internet connection
;; Eivind Kjeka Broen
;; eivind.kb@hotmail.com

;; Basics
  (setq inhibit-startup-message t)    ;; Hide the startup message
  (setq debug-on-error t)             ;; enable in-depth message on error
  (setq ring-bell-function 'ignore)   ;; ignore annoying bell sounds while in emacs
  (tool-bar-mode -1)                  ;; removes ugly tool bar
  (menu-bar-mode -1)                  ;; removes menubar

;; Encoding
  (set-language-environment "utf-8")
  (prefer-coding-system 'utf-8)
  (set-default-coding-systems 'utf-8)
  (set-terminal-coding-system 'utf-8)
  (set-keyboard-coding-system 'utf-8)
  (set-selection-coding-system 'utf-8)
  (setq-default buffer-file-coding-system 'utf-8)

;; Text and Writing
  ;; Electric pair for closing parentheses etc
  (electric-pair-mode t)
  ;; Linum mode
  (global-display-line-numbers-mode t)
  ;; hide emphasis markers (bold, italics etc)
  (setq org-hide-emphasis-markers t)
  ;; sentences does not end in double space anymore
  (setq sentence-end-double-space nil)
  ;; when something is selected it will now be deleted if typed over
  (delete-selection-mode t)

;; flyspell
  (when (string= system-type "gnu/linux")
    (add-hook 'text-mode-hook 'flyspell-mode)
    (add-hook 'prog-mode-hook 'flyspell-prog-mode)
    (eval-after-load "flyspell"
      '(define-key flyspell-mode-map (kbd "C-.") nil)))

;; Time  
(setq-default org-display-custom-times t)
(setq org-time-stamp-custom-formats '("<%e.%m.%Y>" . "<%e.%m.%Y %H:%M>"))

;; Auto-revert
  ;; files reload from disc when reopened
  (global-auto-revert-mode t)
  ;; dired automatically updates  
  (setq dired-auto-revert-buffer t)

;; ORG  
(require 'org)
  (electric-indent-mode -1)       ;; disables electric indent mode
  (setq org-log-done t)
  ;; RETURN will follow links in org-mode files
  (setq org-return-follows-link  t)
  ;; remove stupid indent
  (setq org-adapt-indentation nil)
     ;; enable tag inheritance
     (setq org-use-tag-inheritance t)
  ;; images
  (setq org-image-actual-width nil) ;; do not display images in actual size
  ;; enables pictures in org files
  (defun org-show-images ()
    (interactive)
    (message "Show images")
    (org-toggle-inline-images t)
    )
  (add-hook 'org-mode-hook 'org-show-images)
  ;; inserts a image in org syntax given path
  (defun org-insert-image (image-path)
    "Insert standardized image text for org given path."
    (interactive "FPath to image: ") ; "F" specifies a file path input
    (insert "#+ATTR_ORG: :width 500\n[[" image-path "]]"))
  ;; dynamic blocks
  (add-hook 'org-mode-hook 'org-update-all-dblocks)
     (add-hook 'before-save-hook 'org-update-all-dblocks)

  ;; related custom functins
  (defun checkbox-all ()
    (interactive)
    (mark-whole-buffer)
    (org-toggle-checkbox)
    (message "check/uncheck all"))
  ;; hide leading stars in org mode
  (setq org-hide-leading-stars 1)
  ;; shift select
  (setq org-support-shift-select 1)


;; Eshell
  (add-hook 'eshell-mode-hook
	    (lambda ()
	      (remove-hook 'completion-at-point-functions 'pcomplete-completions-at-point t)))
  (setenv "LANG" "en_US.UTF-8")
  (setq eshell-scroll-to-bottom-on-input t)

;; Scratch
  (setq initial-scratch-message "")
  (defun open-scratch ()
    (interactive)
    (switch-to-buffer "*scratch*"))


;; Calendar
  (copy-face font-lock-constant-face 'calendar-iso-week-face)
  (set-face-attribute 'calendar-iso-week-face nil
		      :height 0.7)
  (setq calendar-intermonth-text
	'(propertize
	  (format "%2d"
		  (car
		   (calendar-iso-from-absolute
		    (calendar-absolute-from-gregorian (list month day year)))))
	  'font-lock-face 'calendar-iso-week-face))
  (add-hook 'calendar-load-hook
	    (lambda ()
	  (calendar-set-date-style 'european)))
  (setq calendar-week-start-day 1)

;; Custom functions
  ;; open scratch
  (defun open-scratch ()
    (interactive)
    (switch-to-buffer "*scratch*"))
  ;; other custom functions
  (defun unhighlight-all ()
    (interactive)
    (unhighlight-regexp t)
    (message "Removed all highlights"))
  (defun save-text-as-file (text filename)
  "Save TEXT as a file named FILENAME."
  (with-temp-buffer
     (insert text)
     (write-file filename))
     (message (format "'%s' saved." filename)))
  (defun replace-file-contents (file-path new-content)
    "Replace the contents of the FILE-PATH with NEW-CONTENT."
    (with-temp-file file-path
      (insert new-content)))
  (defun create-empty-file (file-path)
    "Create an empty file at FILE-PATH."
    (write-region "" nil file-path))
  (defun file-content-equal-to-string (file string)
      "Check if the content of FILE is equal to STRING."
      (with-temp-buffer
	(insert-file-contents file)
	(string= (buffer-string) string)))
  (defun delete-current-file ()
    "Deletes the current file being viewed in the buffer"
    (interactive)
    (let ((filename (buffer-file-name)))
      (when filename
    (if (yes-or-no-p (format "Are you sure you want to delete %s?" filename))
	(progn
	  (delete-file filename)
	  (message "File '%s' deleted." filename)
	  (kill-buffer))
      (message "File '%s' not deleted." filename)))))
  (defun backward-kill-word-or-whitespace ()
    "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
    (interactive)
    (if (looking-back "\\s-")
    (progn
      (delete-region (point) (save-excursion (skip-chars-backward " \t\n") (point))))
      (backward-kill-word 1)))
  ;; write functions
  (defun write-current-time ()
    "Writes the current time at the cursor position."
    (interactive)
    (insert (current-time-string)))
  (defun write-current-date ()
    "Writes current date at current position"
    (interactive)
    (insert (format-time-string "%d-%m-%Y")))
  (defun write-current-path ()
    "Writes the path to current buffer at the cursor position."
    (interactive)
    (insert (buffer-file-name)))
  (defun write-read-only ()
    "Write the syntax necessary for activating read only on top of file"
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (insert "# -*- buffer-read-only: t -*-\n")))
  (defun paste-fix ()
    "Replace characters with specific code points with other letters in the current buffer."
    (interactive)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward "[\x3FFF92]" nil t)
	(replace-match "'" nil nil))
      (while (re-search-forward "[\x3FFFE5]" nil t)
	(replace-match "å" nil nil))
      (goto-char (point-min)) ; Reset to the beginning of the buffer
      (while (re-search-forward "[\x3FFFE6]" nil t)
	(replace-match "æ" nil nil))
      (goto-char (point-min)) ; Reset to the beginning of the buffer
      (while (re-search-forward "[\x3FFFF8]" nil t)
	(replace-match "ø" nil nil))
      (goto-char (point-min)) ; Reset to the beginning of the buffer
      (while (re-search-forward "[\x3FFFC5]" nil t)
	(replace-match "Å" nil nil))
      (goto-char (point-min)) ; Reset to the beginning of the buffer
      (while (re-search-forward "[\x3FFFC6]" nil t)
	(replace-match "Æ" nil nil))
      (goto-char (point-min)) ; Reset to the beginning of the buffer
      (while (re-search-forward "[\x3FFFD8]" nil t)
	(replace-match "Ø" nil nil))))
  (add-hook 'before-save-hook 'paste-fix)


;; Keybindings
;; 0-9
;;  (global-set-key (kbd "C-c 1") 'dashboard-open)
;;  (global-set-key (kbd "C-c 2") 'open-config)
;;  (global-set-key (kbd "C-c 3") 'open-mega)
;;  (global-set-key (kbd "C-c 4") 'open-org)
;;  (global-set-key (kbd "C-c 5") 'mastodon)
;;  (global-set-key (kbd "C-c 6") 'run-libera-chat)
;;  (global-set-key (kbd "C-c 7") 'open-token)
;;  (global-set-key (kbd "C-c 8") 'open-bookmarks)
;;  (global-set-key (kbd "C-c 9") 'elfeed)
  (global-set-key (kbd "C-c 0") 'open-scratch)

;; a-z
;;  (global-set-key (kbd "C-c a") 'org-agenda)
  (global-set-key (kbd "C-c b") 'checkbox-all) ;; Clear checkboxes
;;  (global-set-key (kbd "C-c c") 'org-capture)
;;  (global-set-key (kbd "C-c d") 'xxxxx) ;; d is for zettelkasten and deft
;;  (global-set-key (kbd "C-c e") 'xxxxx)
;;  (global-set-key (kbd "C-c f") 'font-inconsolata)
;;  (global-set-key (kbd "C-c g") 'xxxxx)
;;  (global-set-key (kbd "C-c h") 'roam-home)
;;  (global-set-key (kbd "C-c i") 'ispell)
;;  (global-set-key (kbd "C-c j") 'xxxxx)
  (global-set-key (kbd "C-c k") 'delete-current-file)
  (global-set-key (kbd "C-c l") 'org-insert-link)
;;  (global-set-key (kbd "C-c m") 'xxxxx)
;;  (global-set-key (kbd "C-c n") 'nyan-mode)
  (global-set-key (kbd "C-c o") 'write-current-time)
  (global-set-key (kbd "C-c p") 'write-current-path)
  (global-set-key (kbd "C-c q") 'query-replace)
  (global-set-key (kbd "C-c r") 'visual-line-mode)
  (global-set-key (kbd "C-c s") 'shell)
  (global-set-key (kbd "C-c t") 'org-timer-set-timer)
;;  (global-set-key (kbd "C-c u") 'flyspell-mode) ;; underline
  (global-set-key (kbd "C-c v") 'goto-line)
;;  (global-set-key (kbd "C-c w") 'zetteldeft-wander)
;;  (global-set-key (kbd "C-c x") 'cycle-themes)
;;  (global-set-key (kbd "C-c y") 'my-save-word)
  (global-set-key (kbd "C-c z") 'eshell)


;; æ-å
  (global-set-key (kbd "C-c ø") 'write-read-only)
  (global-set-key (kbd "C-c æ") 'read-only-mode)
;;  (global-set-key (kbd "C-c å") 'pandoc-convert)
  (global-set-key (kbd "C-ø") 'make-frame-command)
  (global-set-key (kbd "C-æ") 'delete-frame)
;;  (global-set-key (kbd "C-å") 'toggle-frame-solidity)
  (global-set-key (kbd "C-c M-ø") 'highlight-symbol-at-point)
  (global-set-key (kbd "C-c M-æ") 'unhighlight-all)
  (global-set-key (kbd "C-c M-å") 'org-insert-image)
  (global-set-key (kbd "M-ø") 'kmacro-start-macro-or-insert-counter)
  (global-set-key (kbd "M-æ") 'kmacro-end-or-call-macro)
  (global-set-key (kbd "M-å") 'org-show-images)
  (global-set-key (kbd "C-M-ø") 'replace-regexp)
  (global-set-key (kbd "C-M-æ") 'occur)
;;  (global-set-key (kbd "C-M-å") 'my-func)


;; Theme
(load-theme 'tsdh-dark)