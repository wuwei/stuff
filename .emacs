;; Need more comments! :P

(setq backup-directory-alist (quote ((".*" . "~/.emacs.d/backups"))))
(setq erc-hide-list '("JOIN" "NICK" "PART" "QUIT"))
(add-to-list 'load-path "~/elisp/")
(add-to-list 'load-path "~/elisp/color-theme-6.6.0")
(menu-bar-mode 1)
(require 'zenburn)
(zenburn)
(require 'smart-compile)
(set-background-color "black")
(set-foreground-color "white")

(global-font-lock-mode t)
(defun linux-c-mode ()
  "C mode with adjusted defaults for use with the Linux kernel."
  (interactive)
  (c-mode)
  (c-set-style "K&R")
  (global-set-key "\C-u" 'c-electric-delete)
  (setq tab-width 8)
  (setq indent-tabs-mode t)
  (setq c-basic-offset 2))

(setq kill-whole-line t)
(setq c-hungry-delete-key t)
;; (setq c-auto-newline 0)
(add-hook 'c-mode-common-hook
          '(lambda ()
             (turn-on-auto-fill)
             (setq fill-column 75)
             (setq comment-column 60)
             (modify-syntax-entry ?_ "w") ; now '_' is not considered a word-delimiter
             (c-set-style "ellemtel") ; set indentation style
             (local-set-key [(control tab)] ; move to next tempo mark
                            'tempo-forward-mark)
             ))

(global-set-key "\C-o" 'dabbrev-expand)
(global-set-key "`" 'other-window)
(global-set-key "\M-g" 'goto-line)

(transient-mark-mode)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(blink-cursor-mode nil)
 '(column-number-mode t)
 '(debug-on-error t)
 '(display-battery-mode t)
 '(display-time-mode t)
 '(inhibit-startup-screen t)
 '(show-paren-mode t)
 '(speedbar-frame-parameters (quote ((minibuffer) (width . 20) (border-width . 0) (menu-bar-lines . 0) (tool-bar-lines . 0) (unsplittable . t) (set-background-color "black")))))
(add-to-list 'auto-mode-alist '("\\.js\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.c\\'" . linux-c-mode))
(add-to-list 'auto-mode-alist '("\\.h\\'" . linux-c-mode))
(add-to-list 'auto-mode-alist '("\\.m\\'" . octave-mode))
(autoload 'javascript-mode "javascript" nil t)

(global-set-key "\C-u" 'delete-backward-char)

(add-hook 'octave-mode-hook
(lambda()
(setq octave-auto-indent 1)
(setq octave-blink-matching-block 1)
(setq octave-block-offset 8)
(setq octave-send-line-auto-forward 0)
(abbrev-mode 1)
(auto-fill-mode 1)
(if (eq window-system 'x)
(font-lock-mode 1))))
;(load-file "~/elisp/emacs-for-python/epy-init.el")

;(setq tags-directory "~/.emacs.d/tags/")
;(setq tags-table-list '("~/emacs.d/tag/"))

(add-to-list 'load-path "~/elisp/emacs-codepad") ;; replace PATH with the path to codepad.el
(autoload 'codepad-paste-region "codepad" "Paste region to codepad.org." t)
(autoload 'codepad-paste-buffer "codepad" "Paste buffer to codepad.org." t)
(autoload 'codepad-fetch-code "codepad" "Fetch code from codepad.org." t)

(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; Calendar.
;; {{{
(setq view-diary-entries-initially t
      mark-diary-entries-in-calendar t
      number-of-diary-entries 7)
(add-hook 'diary-display-hook 'fancy-diary-display)
(add-hook 'today-visible-calendar-hook 'calendar-mark-today)

(add-hook 'fancy-diary-display-mode-hook
'(lambda ()
(alt-clean-equal-signs)))

(defun alt-clean-equal-signs ()
  "This function makes lines of = signs invisible."
  (goto-char (point-min))
  (let ((state buffer-read-only))
    (when state (setq buffer-read-only nil))
    (while (not (eobp))
      (search-forward-regexp "^=+$" nil 'move)
      (add-text-properties (match-beginning 0)
(match-end 0)
'(invisible t)))
    (when state (setq buffer-read-only t))))

(define-derived-mode fancy-diary-display-mode fundamental-mode
  "Diary"
  "Major mode used while displaying diary entries using Fancy Display."
  (set (make-local-variable 'font-lock-defaults)
       '(fancy-diary-font-lock-keywords t))
  (define-key (current-local-map) "q" 'quit-window)
  (define-key (current-local-map) "h" 'calendar))

(defadvice fancy-diary-display (after set-mode activate)
  "Set the mode of the buffer *Fancy Diary Entries* to
 fancy-diary-display-mode'."
  (save-excursion
    (set-buffer fancy-diary-buffer)
    (fancy-diary-display-mode)))

(require 'generic)
(define-generic-mode 'fancy-diary-display-mode
  nil
  (list "Exception" "Location" "Desc")
  '(
    ("\\(.*\\)\n\\(=+\\)" ;; Day title / separator lines
     (1 'font-lock-keyword-face) (2 'font-lock-preprocessor-face))
    ("^\\(todo [^:]*:\\)\\(.*\\)$" ;; To do entries
     (1 'font-lock-string-face) (2 'font-lock-reference-face))
    ("\\(\\[.*\\]\\)" ;; Category labels
     1 'font-lock-constant-face)
    ("^\\(0?\\([1-9][0-9]?:[0-9][0-9]\\)\\([ap]m\\)?\\(-0?\\([1-9][0-9]?:[0-9][0-9]\\)\\([ap]m\\)?\\)?\\)"
     1 'font-lock-type-face)) ;; Time intervals at start of lines.
  nil
  (list
   (function
    (lambda ()
      (turn-on-font-lock))))
  "Mode for fancy diary display.")

(defun diary-schedule (m1 d1 y1 m2 d2 y2 dayname)
  "Entry applies if date is between dates on DAYNAME.
    Order of the parameters is M1, D1, Y1, M2, D2, Y2 if
    european-calendar-style' is nil, and D1, M1, Y1, D2, M2, Y2 if
    european-calendar-style' is t. Entry does not apply on a history."
  (let ((date1 (calendar-absolute-from-gregorian
(if european-calendar-style
(list d1 m1 y1)
(list m1 d1 y1))))
(date2 (calendar-absolute-from-gregorian
(if european-calendar-style
(list d2 m2 y2)
(list m2 d2 y2))))
(d (calendar-absolute-from-gregorian date)))
    (if (and
(<= date1 d)
(<= d date2)
(= (calendar-day-of-week date) dayname)
(not (check-calendar-holidays date))
)
entry)))

;; Countdown!

(defun diary-countdown (m1 d1 y1 n)
  "Reminder during the previous n days to the date.
    Order of parameters is M1, D1, Y1, N if
    european-calendar-style' is nil, and D1, M1, Y1, N otherwise."
  (diary-remind '(diary-date m1 d1 y1) (let (value) (dotimes (number n value) (setq value (cons number value))))))

;; }}}

;; {{{ Gnus

(setq gnus-home-directory "~/gnus/")
(setq gnus-startup-file (concat gnus-home-directory ".newsrc"))
(setq gnus-cache-directory (concat gnus-home-directory "cache/"))
(setq message-directory (concat gnus-home-directory "Mail/"))
(setq gnus-directory (concat gnus-home-directory "News/"))
(setq gnus-agent-directory (concat gnus-directory "agent/"))
(setq message-auto-save-directory (concat message-directory "drafts/"))
(setq gnus-dribble-directory gnus-home-directory)
(setq nnml-directory (concat gnus-home-directory "nnml/"))
(setq nnmail-crash-box (concat nnml-directory "mit-gnus-crash-box/"))
(setq nnml-newsgroups-file (concat nnml-directory "newsgroup/"))
(setq nntp-authinfo-file "~/.authinfo")
;; }}}

;; {{{
;; Autocomplete Stuff.

;; (require 'auto-complete-config)
;; (add-to-list 'ac-dictionary-directories "~/elisp/auto-complete-1.3//ac-dict")
;; (ac-config-default)

;; dirty fix for having AC everywhere
;; (define-globalized-minor-mode real-global-auto-complete-mode
;; auto-complete-mode (lambda ()
;; (if (not (minibufferp (current-buffer)))
;; (auto-complete-mode 1))
;; ))
;; (real-global-auto-complete-mode t)

;; }}}

;; {{{
;; mpd
(defun mpd-erc-np ()
  (interactive)
  (erc-send-message
   (concat "NP: "
(let* ((string (shell-command-to-string "mpc")))
(string-match "[^/]*$" string)
(match-string 0 string)))))
;; }}}

(require 'erc-nick-colors)

(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#3f3f3f" :foreground "#dcdccc" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 92 :width normal :foundry "xos4" :family "Terminus"))))
 '(background "blue")
 '(font-lock-builtin-face ((((class color) (background dark)) (:foreground "Turquoise"))))
 '(font-lock-comment-face ((t (:foreground "MediumAquamarine"))))
 '(font-lock-constant-face ((((class color) (background dark)) (:bold t :foreground "DarkOrchid"))))
 '(font-lock-doc-string-face ((t (:foreground "green2"))))
 '(font-lock-function-name-face ((t (:foreground "SkyBlue"))))
 '(font-lock-keyword-face ((t (:bold t :foreground "CornflowerBlue"))))
 '(font-lock-preprocessor-face ((t (:italic nil :foreground "CornFlowerBlue"))))
 '(font-lock-reference-face ((t (:foreground "DodgerBlue"))))
 '(font-lock-string-face ((t (:foreground "LimeGreen"))))
 '(font-lock-type-face ((t (:foreground "#9290ff"))))
 '(font-lock-variable-name-face ((t (:foreground "PaleGreen"))))
 '(font-lock-warning-face ((((class color) (background dark)) (:foreground "yellow" :background "red"))))
 '(highlight ((t (:background "CornflowerBlue"))))
 '(list-mode-item-selected ((t (:background "gold"))))
 '(makefile-space-face ((t (:background "wheat"))))
 '(mode-line ((t (:background "Navy"))))
 '(paren-match ((t (:background "darkseagreen4"))))
 '(region ((t (:background "DarkSlateBlue"))))
 '(show-paren-match ((t (:foreground "black" :background "wheat"))))
 '(show-paren-mismatch ((((class color)) (:foreground "white" :background "red"))))
 '(speedbar-button-face ((((class color) (background dark)) (:foreground "green4"))))
 '(speedbar-directory-face ((((class color) (background dark)) (:foreground "khaki"))))
 '(speedbar-file-face ((((class color) (background dark)) (:foreground "cyan"))))
 '(speedbar-tag-face ((((class color) (background dark)) (:foreground "Springgreen"))))
 '(vhdl-speedbar-architecture-selected-face ((((class color) (background dark)) (:underline t :foreground "Blue"))))
 '(vhdl-speedbar-entity-face ((((class color) (background dark)) (:foreground "darkGreen"))))
 '(vhdl-speedbar-entity-selected-face ((((class color) (background dark)) (:underline t :foreground "darkGreen"))))
 '(vhdl-speedbar-package-face ((((class color) (background dark)) (:foreground "black"))))
 '(vhdl-speedbar-package-selected-face ((((class color) (background dark)) (:underline t :foreground "black"))))
 '(widget-field ((((class grayscale color) (background light)) (:background "DarkBlue")))))

(add-to-list 'load-path "~/elisp/mozrepl")
;;; js-mode is javascript major mode
 (autoload 'js-mode "js-mode")
 (add-to-list 'auto-mode-alist '("\\.js$" . js-mode))
 (autoload 'moz-minor-mode "moz" "Mozilla Minor and Inferior Mozilla Modes" t)
 (add-hook 'js-mode-hook 'js-mozrepl-custom-setup)
 (defun js-mozrepl-custom-setup ()
   (moz-minor-mode 1))

(add-to-list 'load-path "~/elisp/twittering-mode")
(require 'twittering-mode)

(defun mpd-erc-np ()
      (interactive)
      (erc-send-message
       (concat "NP: "
(let* ((string (shell-command-to-string "mpc")))
(string-match "[^/]*$" string)
(match-string 0 string)))))

(setq jabber-username "adm" ;;
      jabber-server "jabber.ccc.de"     ;; this is a part of your user ID, not a part of the server you will connect to.
      jabber-network-server "jabber.ccc.de"  ;; this is the actual server to connect to
      jabber-port 5223
      jabber-connection-type 'ssl)
