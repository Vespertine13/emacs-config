;; My lightweight emacs init
;; Should work on emacs 26.1
;; Should not require any packages, additional files or internet connection.
;; Eivind Kjeka Broen
;; eivind.kb@hotmail.com

;; ---------------------------------------------------------------------------------------------------------------
;; UI
;; ---------------------------------------------------------------------------------------------------------------
(setq inhibit-startup-message t)    ;; Hide the startup message
(setq debug-on-error t)             ;; enable in-depth message on error
(setq ring-bell-function 'ignore)   ;; ignore annoying bell sounds while in emacs
(tool-bar-mode -1)                  ;; removes tool bar
(menu-bar-mode -1)                  ;; removes menubar
(scroll-bar-mode -1)                ;; removes scroll bar
(blink-cursor-mode 0)               ;; stop cursor from blinking
(global-hl-line-mode 1)             ;; shows what line you are on

;; ---------------------------------------------------------------------------------------------------------------
;; Backup and temp
;; ---------------------------------------------------------------------------------------------------------------
(setq FOLDER_TEMP "~/.emacs.d/my_temp/")
(unless (file-exists-p FOLDER_TEMP)
  (make-directory FOLDER_TEMP))
;; backup and temp
(setq backup-directory-alist
      `((".*" . ,FOLDER_TEMP)))
(setq auto-save-file-name-transforms
      `((".*" ,FOLDER_TEMP t)))
(setq temporary-file-directory
      FOLDER_TEMP)

;; ---------------------------------------------------------------------------------------------------------------
;; Text and Writing
;; ---------------------------------------------------------------------------------------------------------------
(electric-pair-mode t)
;; sentences does not end in double space anymore
(setq sentence-end-double-space nil)
;; when something is selected it will now be deleted if typed over
(delete-selection-mode t)
;; global visual line mode
(global-visual-line-mode t)
;; Line numbers
;; Use linum mode for old version of Emacs and line numbers mode for new versions of Emacs
(global-display-line-numbers-mode t)
;;(global-linum-mode t)
;; disables electric indent mode
(electric-indent-mode -1)

;; ---------------------------------------------------------------------------------------------------------------
;; ORG
;; ---------------------------------------------------------------------------------------------------------------
(require 'org)
(setq-default org-log-done t
	      org-adapt-indentation nil
	      org-return-follows-link  t
	      org-return-follows-link  t
	      org-use-tag-inheritance t
	      org-support-shift-select 1
	      org-hide-emphasis-markers 1
              org-hide-emphasis-markers t
              org-startup-with-inline-images t
              org-image-actual-width '(300))

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
;; bullet points
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

;; ---------------------------------------------------------------------------------------------------------------
;; OTHER
;; ---------------------------------------------------------------------------------------------------------------
;; eshell
(add-hook 'eshell-mode-hook
	  (lambda ()
	    (remove-hook 'completion-at-point-functions 'pcomplete-completions-at-point t)))
(setenv "LANG" "en_US.UTF-8")
(setq eshell-scroll-to-bottom-on-input t)

;; Scratch
(setq initial-scratch-message "")
;; open files functions
;; open init
(defun open-init ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
;; open fancy about screen
(defun open-fancy-about-screen ()
  (interactive)
  (fancy-about-screen))

;; Calendar
(add-hook 'calendar-load-hook
	  (lambda ()
	    (calendar-set-date-style 'iso)))
;; start week on mondays
(setq calendar-week-start-day 1)
;; Add week numbers to the calendar
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



;; Auto-revert
;; files reload from disc when reopened
(global-auto-revert-mode t)
;; dired
(setq dired-auto-revert-buffer t)

;; ---------------------------------------------------------------------------------------------------------------
;; CUSTOM FUNCTIONS
;; ---------------------------------------------------------------------------------------------------------------
;; works with highlight symbol at point
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

;; open scratch
(defun open-scratch ()
  (interactive)
  (switch-to-buffer "*scratch*"))
;; open init
(defun open-init ()
  (interactive)
  (find-file "~/.emacs.d/init.el"))
;; open fancy about screen
(defun open-fancy-about-screen ()
  (interactive)
  (fancy-about-screen))

;; INSERT FUNCTIONS
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
;; write total time used to calculate flexitid
(defun write-total-time (days)
  "Calculate the total hours based on DAYS and HOURS-PER-DAY."
  (interactive "nEnter the number of days: ")
  (let ((days 23)
	(hours (ceiling (* days 7.5))))
    (insert (format "%dd %d:00" (/ hours 24) (% hours 24))))
  )

;; pin entry
(setq epg-pinentry-mode 'loopback)

;; NORMAL BACKSPACE
(defun ryanmarcus/backward-kill-word ()
  "Remove all whitespace if the character behind the cursor is whitespace, otherwise remove a word."
  (interactive)
  (if (looking-back "[ \n]")
      ;; delete horizontal space before us and then check to see if we
      ;; are looking at a newline
      (progn (delete-horizontal-space 't)
	     (while (looking-back "[ \n]")
	       (backward-delete-char 1)))
    ;; otherwise, just do the normal kill word.
    (backward-kill-word 1)))

;; Toggle transparent frame
(defun set-frame-solid ()
  (set-frame-parameter (selected-frame) 'alpha-background '100)
  (message "Solid frame"))
(defun set-frame-transparent ()
  (set-frame-parameter (selected-frame) 'alpha-background '80)
  (message "Transparent frame"))
(defun toggle-frame-solidity ()
  "Toggle between solid and transparent frame for the current buffer."
  (interactive)
  (when (not (boundp 'transparent-frame-enabled))
    (setq transparent-frame-enabled nil))
  (setq transparent-frame-enabled (not transparent-frame-enabled))
  (if transparent-frame-enabled
      (set-frame-transparent)
    (set-frame-solid)))

;; regexp highlight
(defun operations-highlight()
  (interactive)
  (highlight-regexp "wgs[0-9][0-9][0-9]" "hi-green")
  (highlight-regexp "EKG[0-9][0-9][0-9][0-9][0-9][0-9]" "hi-yellow")
  (highlight-regexp "trio[a-z][a-z][a-z]" "hi-blue")
  (highlight-regexp "trio" "hi-blue")
  (highlight-regexp "reanalyse" "hi-brown")
  )

;; ---------------------------------------------------------------------------------------------------------------
;; Random utility
;; ---------------------------------------------------------------------------------------------------------------

(defun tail-nsc-exporter ()
  (shell)
  (rename-buffer "tail-nsc-exporter")
  (operations-highlight)
  (insert "tail-nsc-exporter"))

(defun tail-lims-exporter ()
  (shell)
  (rename-buffer "tail-lims-exporter")
  (operations-highlight)
  (insert "tail-lims-exporter"))

(defun tail-logs ()
  (interactive)
  (tail-nsc-exporter)
  (split-window-below)
  (tail-lims-exporter))

;; ---------------------------------------------------------------------------------------------------------------
;; THEMES
;; ---------------------------------------------------------------------------------------------------------------
(defun disable-all-themes ()
  "Disable all currently active themes."
  (dolist (i custom-enabled-themes)
    (disable-theme i)))
;; set theme function
(defun set-theme (theme)
  (disable-all-themes)
  (load-theme theme t)
  (message "Theme '%s' set" theme))

;; ---------------------------------------------------------------------------------------------------------------
;; KEYBINDINGS
;; ---------------------------------------------------------------------------------------------------------------
;; use C-h b to list current keybindings
(global-set-key (kbd "C-c g") 'rgrep)
(global-set-key (kbd "C-c h") 'highlight-symbol-at-point)
(global-set-key (kbd "C-c H") 'unhighlight-all)
(global-set-key (kbd "C-c j") 'operations-highlight)
(global-set-key (kbd "C-c k") 'delete-current-file)
(global-set-key (kbd "C-c l") 'org-insert-link)
(global-set-key (kbd "C-c m") 'kmacro-end-or-call-macro)
(global-set-key (kbd "C-c n") 'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "C-c o") 'write-current-time)
(global-set-key (kbd "C-c p") 'write-current-path)
(global-set-key (kbd "C-c q") 'query-replace)
(global-set-key (kbd "C-c r") 'visual-line-mode)
(global-set-key (kbd "C-c s") 'shell)
(global-set-key (kbd "C-c t") 'org-timer-set-timer)
(global-set-key (kbd "C-c v") 'goto-line)
(global-set-key (kbd "C-c w") 'read-only-mode)
(global-set-key (kbd "C-c z") 'delete-trailing-whitespace)

;; Arrow keys
(global-set-key (kbd "C-x <up>") 'make-frame-command)
(global-set-key (kbd "C-x <down>") 'delete-frame)

;; Other keybindings
(global-set-key (kbd "C-.") 'other-window)
(global-set-key (kbd "C-:") 'other-frame)
(global-set-key  [C-backspace] 'ryanmarcus/backward-kill-word)
(global-set-key "\M- " 'hippie-expand)

;; ---------------------------------------------------------------------------------------------------------------
;; Bookmarks
;; ---------------------------------------------------------------------------------------------------------------
(global-set-key (kbd "C-c b f") 'bookmark-jump)
(global-set-key (kbd "C-c b b") 'bookmark-set)
(global-set-key (kbd "C-c b l") 'list-bookmarks)
(global-set-key (kbd "C-c b s") 'bookmark-save)
(global-set-key (kbd "C-c b d") 'bookmark-delete)
(global-set-key (kbd "C-c b D") 'bookmark-delete-all)
