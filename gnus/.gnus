;; pass:72cb60
;; Gnus startup file.
(require 'cl)
(require 'nnrss)
(require 'browse-url)
(setq gnus-select-method '(nntp "news.gmane.org"))
(setq gnus-agent nil)
(setq gnus-ignored-newsgroups "")

(setq starttls-use-gnutls t
      starttls-gnutls-program "gnutls-cli"
      starttls-extra-arguments nil)

(setq gnus-message-archive-group "nnml:sent")
(setq gnus-gcc-mark-as-read t)
(setq mm-discouraged-alternatives '("text/html"))
(setq mm-coding-system-priorities '(iso-8859-1 utf-8))
(setq gnus-buttonized-mime-types
  '("multipart/alternative" "multipart/encrypted" "multipart/signed"
    ".*/signed"))

;; ---------------------------------------------------------------------
;; Message signing and signature verification through EasyPG.

(require 'epa)

(setq mml2015-use 'epg)
(setq mml2015-encrypt-to-self t)
(setq mml2015-verbose nil)
(setq mml2015-always-trust nil)
(setq mml2015-passphrase-cache-expiry '7200)

;; My default key for signing email messages.
;; (setq epg-user-id "D60F941A318603B6")

(add-hook 'message-setup-hook 'keramida/get-mml2015-signers)
(defun keramida/get-mml2015-signers ()
  (when gnus-newsgroup-name
    (let ((signers (gnus-group-get-parameter gnus-newsgroup-name
					     'mml2015-signers t)))
       (when signers
 	(set (make-local-variable 'mml2015-signers) signers)))))

(setq gnus-message-replysign t
      gnus-message-replyencrypt t
      gnus-message-replysignencrypted t
      gnus-treat-x-pgp-sig t
      mm-verify-option 'always
      mm-decrypt-option 'always)
;; ---------------------------------------------------------------------

;; Where my global score rules are saved.
(setq gnus-home-score-file
      "~/gnus/News/gnus.SCORE")

;; Load nnmairix when Gnus fires up.  I like the way it can search very
;; fast through a great deal of email data.
; (require 'nnmairix)

;; Mairix options & defaults.
; (setq-default nnmairix-mairix-update-options (list "-F" "-p"))

;; Display and index buffer formats.
(require 'timezone)
(defun gnus-user-format-function-d (header)
  "Render article date in (dd-mm-YY) format."
    (let* ((date (mail-header-date header))
	     (tz (timezone-parse-date date)))
		 (format "%02d-%02d-%02d"
			 (string-to-int (aref tz 2))
			 (string-to-int (aref tz 1))
			 (string-to-int (aref tz 0)))))

(setq gnus-group-line-format "%M%S%8y: %G\n")
(setq gnus-summary-line-format "%U%R%z%ud %B%(%[%4L: %-20,20n%]%) %s\n")



;; Message reply & followup citation line format.
(defun gker-message-insert-citation-line ()
  "Insert a simple citation line."
  (when message-reply-headers
    (insert "On "
	    (mail-header-date message-reply-headers)
	    ", "
            ?\n
	    (mail-header-from message-reply-headers)
	    " wrote:")
    (newline)))
;; Bind my own citation line function, thus enabling it.
(setq message-citation-line-function 'gker-message-insert-citation-line)

;; Prompt just once before saving many articles.
(setq gnus-prompt-before-saving t)

;; How to save articles, by default.
(setq gnus-default-article-saver 'gnus-summary-save-in-mail
      gnus-mail-save-name 'gnus-plain-save-name)

;; Use alt.foo.bar style names for folders
(setq gnus-use-long-file-name t)

;; When entering a folder, don't automagically select the first message
;; and show it in an article buffer.
(setq gnus-autoselect-first nil)

;; Display each article in it's own buffer (so that one can read several
;; groups at the same time).
(setq gnus-single-article-buffer nil)

;; The headers that are shown for messages or news-articles.
(setq gnus-visible-headers '("^Date:" "^From:" "^Reply-To:"
				"^Followup-To:" "^Subject:" "^To:"
				"^Cc:" "^Newsgroups:" "^Message-Id:"))
;; The order of headers shown in article buffers.
(setq gnus-sorted-header-list '("^Date:" "^From:" "^Reply-To:"
				"^Followup-To:" "^Subject:" "^To:"
				"^Cc:" "^Newsgroups:" "^Message-Id:"))

;; Customizations for article display.
(setq gnus-treat-date-local 'head)
(setq gnus-treat-display-face nil)
(setq gnus-treat-display-x-face nil)
(setq gnus-treat-display-smileys nil)

;; If displaying "text/html" is discouraged, images or other material
;; inside a "multipart/related" part might be overlooked when the
;; `gnus-mime-display-multipart-related-as-mixed' variable is `nil'.
(setq gnus-mime-display-multipart-related-as-mixed t)

;;; Threading customizations.

;; Use my own thread-gathering function.
(setq gnus-summary-thread-gathering-function 'gnus-gather-threads-by-references)

;; Sort thread by date when in threaded mode, and articles by date again
;; when in unthreaded mode.
(setq gnus-thread-sort-functions '(gnus-thread-sort-by-date))
(setq gnus-article-sort-functions '(gnus-article-sort-by-number gnus-article-sort-by-date))



;;; Mail splitting with Gnus:
(setq nnmail-split-methods 'nnmail-split-fancy)
(setq nnmail-split-fancy
      '(| ;; First messages tagged as spammy are saved to "mail.junk"

	  ("x-spam-flag" "yes" "mail.junk")
	  ("subject" ".*{Spam not delivered}.*" "mail.junk")
	  ("subject" ".*{Possible Spam}.*" "mail.junk")

	  ;; Finally, the fallback folder for all messages that are *still*
	  ;; undelivered, is the main `INBOX'.
	  "mail.INBOX"))

;; Show all articles by default for all buffers
(setq gnus-parameters
      '((".*"
         (display . all))
        ("^nnimap"
         (gnus-show-threads nil)
         (gnus-use-scoring nil))
        ("^nntp"
         (gnus-show-threads t)
         (gnus-use-scoring t))))


;; The message buffer will be killed after sending a message. 
(setq message-kill-buffer-on-exit t)

;; Crude gfx

;; (setq gnus-sum-thread-tree-root "►")
;; (setq gnus-sum-thread-tree-leaf-with-other "├─►")
;; (setq gnus-sum-thread-tree-single-leaf "└─►")
;; (setq gnus-sum-thread-tree-vertical "│")
;; (setq gnus-sum-thread-tree-single-indent " ")
;; (setq gnus-sum-thread-tree-false-root "")



;; Privacy settings
(require 'gnushush)

(setq gnushush-user-agent-header 'none)
(setq gnushush-uid 'random)

(setq yg-system-name system-name)


(defun set-smtp-values (server user port domain)
  (setq smtpmail-smtp-server server
        smtpmail-smtp-service port
        system-name domain
        smtpmail-auth-credentials (list (list server port user nil))
        smtpmail-starttls-credentials (list (list server port nil nil)))
  (setq gnushush-fqdn domain)
  (message "Setting SMTP server to `%s:%s' for user `%s'." server port user))
  

(defun browse-nnrss-url (arg)
  (interactive "p")
  (let ((url (assq nnrss-url-field
		   (mail-header-extra
		    (gnus-data-header
		     (assq (gnus-summary-article-number)
			   gnus-newsgroup-data))))))
    (if url
        (progn
          (gnus-summary-mark-as-read)
          (browse-url (cdr url)))
      (gnus-summary-scroll-up arg))))


;; Fix for reddit
(setq nnrss-ignore-article-fields
      '(slash:comments thr:total lj:reply-count description))

;; Pressing tab by accident gets old, this disables the command completely
(put 'gnus-topic-indent 'disabled "It is disabled because you disabled it.")

;; Mode hooks
(add-hook 'gnus-group-mode-hook 'gnus-topic-mode)
(add-hook 'message-setup-hook '(lambda () (flyspell-mode 1)))

(add-hook 'gnus-summary-mode-hook
          (lambda ()
            (local-unset-key [M-right])
            (local-unset-key [M-left])
            (local-unset-key [M-down])
            (local-unset-key [M-up])
            (define-key gnus-summary-mode-map
              (kbd "C-<return>")
	      'browse-nnrss-url)
            (if (string-match "^nnrss:.*" gnus-newsgroup-name)
                (progn
                  (make-local-variable 'gnus-show-threads)
                  (make-local-variable 'gnus-article-sort-functions)
                  (make-local-variable 'gnus-use-adaptive-scoring)
                  (make-local-variable 'gnus-use-scoring)
                  (make-local-variable 'gnus-score-find-score-files-function)
                  (make-local-variable 'gnus-summary-line-format)
                  (setq gnus-show-threads nil)
                  (setq gnus-article-sort-functions '((not gnus-article-sort-by-date)))
                  (setq gnus-use-adaptive-scoring nil)
                  (setq gnus-use-scoring t)
                  (setq gnus-score-find-score-files-function 'gnus-score-find-single)
                  (setq gnus-summary-line-format "%U%R%z%d %I%(%[ %s %]%)\n")
                  ))))


(add-to-list 'nnmail-extra-headers nnrss-url-field)

(add-hook 'message-send-hook 'switch-smtp)
(add-hook 'message-sent-hook (lambda ()
                               (setq system-name yg-system-name)))

(setq gnus-activate-level 1)

;; Scoring

(setq gnus-summary-expunge-below -999)
