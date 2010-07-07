<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN"><HTML>
<HEAD>
<!-- hennerik CVSweb $Revision: 1.112 $ -->
<TITLE>gnus/contrib/ssl.el - view - 7.6</TITLE></HEAD>
<BODY BGCOLOR="#eeeeee">
<table width="100%" border=0 cellspacing=0 cellpadding=1 bgcolor="#9999ee"><tr valign=bottom><td><a href="ssl.el#rev7.6"><IMG SRC="/icons/back.gif" ALT="[BACK]" BORDER="0" WIDTH="20" HEIGHT="22"></a> <b>Return to <A HREF="ssl.el#rev7.6">ssl.el</A>
 CVS log</b> <IMG SRC="/icons/text.gif" ALT="[TXT]" BORDER="0" WIDTH="20" HEIGHT="22"></td><td align=right><IMG SRC="/icons/dir.gif" ALT="[DIR]" BORDER="0" WIDTH="20" HEIGHT="22"> <b>Up to  <a href="/cgi-bin/cvsweb.cgi/#dirlist">[(ding)]</a> / <a href="/cgi-bin/cvsweb.cgi/gnus/#dirlist">gnus</a> / <a href="/cgi-bin/cvsweb.cgi/gnus/contrib/#dirlist">contrib</a></b></td></tr></table><HR noshade><table width="100%"><tr><td bgcolor="#ffffff">File:  <a href="/cgi-bin/cvsweb.cgi/#dirlist">[(ding)]</a> / <a href="/cgi-bin/cvsweb.cgi/gnus/#dirlist">gnus</a> / <a href="/cgi-bin/cvsweb.cgi/gnus/contrib/#dirlist">contrib</a> / <a href="/cgi-bin/cvsweb.cgi/gnus/contrib/ssl.el">ssl.el</a>&nbsp;(<A HREF="/cgi-bin/cvsweb.cgi/~checkout~/gnus/contrib/ssl.el?rev=7.6" target="cvs_checkout" onClick="window.open('/cgi-bin/cvsweb.cgi/~checkout~/gnus/contrib/ssl.el?rev=7.6','cvs_checkout','resizeable,scrollbars');"><b>download</b></A>)<BR>
Revision <B>7.6</B>, <i>Thu Dec 29 03:46:41 2005 UTC</i> (4 years, 5 months ago) by <i>miles</i>
<BR>CVS Tags: <b>n0-6, n0-5, n0-4</b><BR>Changes since <b>7.5: +2 -0
 lines</b><PRE>
Add arch tagline
</PRE>
</td></tr></table><HR noshade><PRE>;;; ssl.el,v --- ssl functions for Emacsen without them builtin
;; Author: William M. Perry &lt;<A HREF="mailto:wmperry@cs.indiana.edu">wmperry@cs.indiana.edu</A>&gt;
;; $Revision: 1.5 $
;; Keywords: comm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Copyright (c) 1995, 1996 by William M. Perry &lt;<A HREF="mailto:wmperry@cs.indiana.edu">wmperry@cs.indiana.edu</A>&gt;
;;; Copyright (c) 1996, 97, 98, 99, 2001 Free Software Foundation, Inc.
;;;
;;; This file is part of GNU Emacs.
;;;
;;; GNU Emacs is free software; you can redistribute it and/or modify
;;; it under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 2, or (at your option)
;;; any later version.
;;;
;;; GNU Emacs is distributed in the hope that it will be useful,
;;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. &nbsp;See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Emacs; see the file COPYING. &nbsp;If not, write to the
;;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;;; Boston, MA 02111-1307, USA.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(eval-when-compile (require 'cl))
(require 'base64)
(require 'url) &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;; for `url-configuration-directory'

(defgroup ssl nil
 &nbsp;&quot;Support for `Secure Sockets Layer' encryption.&quot;
 &nbsp;:group 'comm)
 &nbsp;
(defcustom ssl-certificate-directory &quot;~/.w3/certs/&quot;
 &nbsp;&quot;*Directory in which to store CA certificates.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type 'directory)

(defcustom ssl-rehash-program-name &quot;c_rehash&quot;
 &nbsp;&quot;*Program to run after adding a cert to a directory .
Run with one argument, the directory name.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type 'string)

(defcustom ssl-view-certificate-program-name &quot;x509&quot;
 &nbsp;&quot;*The program to run to provide a human-readable view of a certificate.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type 'string)

(defcustom ssl-view-certificate-program-arguments '(&quot;-text&quot; &quot;-inform&quot; &quot;DER&quot;)
 &nbsp;&quot;*Arguments that should be passed to the certificate viewing program.
The certificate is piped to it.
Maybe a way of passing a file should be implemented&quot;
 &nbsp;:group 'ssl
 &nbsp;:type '(repeat string))

(defcustom ssl-certificate-directory-style 'ssleay
 &nbsp;&quot;*Style of cert database to use, the only valid value right now is `ssleay'.
This means a directory of pem encoded certificates with hash symlinks.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type '(choice (const :tag &quot;SSLeay&quot; :value ssleay)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (const :tag &quot;OpenSSL&quot; :value openssl)))

(defcustom ssl-certificate-verification-policy 0
 &nbsp;&quot;*How far up the certificate chain we should verify.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type '(choice (const :tag &quot;No verification&quot; :value 0)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (const :tag &quot;Verification required&quot; :value 1)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (const :tag &quot;Reject connection if verification fails&quot; :value 3)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (const :tag &quot;SSL_VERIFY_CLIENT_ONCE&quot; :value 5)))

(defcustom ssl-program-name &quot;openssl&quot;
 &nbsp;&quot;*The program to run in a subprocess to open an SSL connection.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type 'string)

(defcustom ssl-program-arguments
 &nbsp;'(&quot;s_client&quot;
 &nbsp; &nbsp;&quot;-quiet&quot;
 &nbsp; &nbsp;&quot;-host&quot; host
 &nbsp; &nbsp;&quot;-port&quot; service
 &nbsp; &nbsp;&quot;-verify&quot; (int-to-string ssl-certificate-verification-policy)
 &nbsp; &nbsp;&quot;-CApath&quot; ssl-certificate-directory
 &nbsp; &nbsp;)
 &nbsp;&quot;*Arguments that should be passed to the program `ssl-program-name'.
This should be used if your SSL program needs command line switches to
specify any behaviour (certificate file locations, etc).
The special symbols 'host and 'port may be used in the list of arguments
and will be replaced with the hostname and service/port that will be connected
to.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type 'list)

(defcustom ssl-view-certificate-program-name ssl-program-name
 &nbsp;&quot;*The program to run to provide a human-readable view of a certificate.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type 'string)

(defcustom ssl-view-certificate-program-arguments
 &nbsp;'(&quot;x509&quot; &quot;-text&quot; &quot;-inform&quot; &quot;DER&quot;)
 &nbsp;&quot;*Arguments that should be passed to the certificate viewing program.
The certificate is piped to it.
Maybe a way of passing a file should be implemented.&quot;
 &nbsp;:group 'ssl
 &nbsp;:type 'list)

(defun ssl-certificate-information (der)
 &nbsp;&quot;Return an assoc list of information about a certificate in DER format.&quot;
 &nbsp;(let ((certificate (concat &quot;-----BEGIN CERTIFICATE-----\n&quot;
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (base64-encode-string der)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;\n-----END CERTIFICATE-----\n&quot;))
 &nbsp; &nbsp; &nbsp; &nbsp;(exit-code 0))
 &nbsp; &nbsp;(save-excursion
 &nbsp; &nbsp; &nbsp;(set-buffer (get-buffer-create &quot; *openssl*&quot;))
 &nbsp; &nbsp; &nbsp;(erase-buffer)
 &nbsp; &nbsp; &nbsp;(insert certificate)
 &nbsp; &nbsp; &nbsp;(setq exit-code
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(condition-case ()
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(call-process-region (point-min) (point-max)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ssl-program-name
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; t (list (current-buffer) nil) t
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;x509&quot;
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;-subject&quot; ; Print the subject DN
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;-issuer&quot; ; Print the issuer DN
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;-dates&quot; ; Both before and after dates
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;-serial&quot; ; print out serial number
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;-noout&quot; ; Don't spit out the certificate
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; )
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(error -1)))
 &nbsp; &nbsp; &nbsp;(if (/= exit-code 0)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;nil
 &nbsp; &nbsp; &nbsp; &nbsp;(let ((vals nil))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(goto-char (point-min))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(while (re-search-forward &quot;^\\([^=\n\r]+\\)\\s *=\\s *\\(.*\\)&quot; nil t)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(push (cons (match-string 1) (match-string 2)) vals))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;vals)))))
 &nbsp;
(defun ssl-accept-ca-certificate ()
 &nbsp;&quot;Ask if the user is willing to accept a new CA certificate.
The buffer name should be the intended name of the certificate, and
the buffer should probably be in DER encoding&quot;
 &nbsp;;; TODO, check if it is really new or if we already know it
 &nbsp;(let* ((process-connection-type nil)
 &nbsp; &nbsp; &nbsp; &nbsp; (tmpbuf (generate-new-buffer &quot;X509 CA Certificate Information&quot;))
 &nbsp; &nbsp; &nbsp; &nbsp; (response (save-excursion
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (and (eq 0
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(apply 'call-process-region
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (point-min) (point-max)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ssl-view-certificate-program-name
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; nil tmpbuf t
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ssl-view-certificate-program-arguments))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(switch-to-buffer tmpbuf)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(goto-char (point-min))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(or (recenter) t)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(yes-or-no-p
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &quot;Accept this CA to vouch for secure server identities? &quot;)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(kill-buffer tmpbuf)))))
 &nbsp; &nbsp;(if (not response)
 &nbsp; &nbsp; &nbsp; &nbsp;nil
 &nbsp; &nbsp; &nbsp;(if (not (file-directory-p ssl-certificate-directory))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(make-directory ssl-certificate-directory))
 &nbsp; &nbsp; &nbsp;(case ssl-certificate-directory-style
 &nbsp; &nbsp; &nbsp; &nbsp;(ssleay
 &nbsp; &nbsp; &nbsp; &nbsp; (base64-encode-region (point-min) (point-max))
 &nbsp; &nbsp; &nbsp; &nbsp; (goto-char (point-min))
 &nbsp; &nbsp; &nbsp; &nbsp; (insert &quot;-----BEGIN CERTIFICATE-----\n&quot;)
 &nbsp; &nbsp; &nbsp; &nbsp; (goto-char (point-max))
 &nbsp; &nbsp; &nbsp; &nbsp; (insert &quot;-----END CERTIFICATE-----\n&quot;)
 &nbsp; &nbsp; &nbsp; &nbsp; (let ((f (expand-file-name
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (concat (file-name-sans-extension (buffer-name)) &quot;.pem&quot;)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; ssl-certificate-directory)))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (write-file f)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (call-process ssl-rehash-program-name
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; nil nil nil
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (expand-file-name ssl-certificate-directory))))))))

(defvar ssl-exec-wrapper nil)

(defun ssl-get-command ()
 &nbsp;(if (memq system-type '(ms-dos ms-windows axp-vms vax-vms))
 &nbsp; &nbsp; &nbsp;;; Nothing to do on DOS, Windows, or VMS!
 &nbsp; &nbsp; &nbsp;(cons ssl-program-name ssl-program-arguments)
 &nbsp; &nbsp;(if (not ssl-exec-wrapper)
 &nbsp; &nbsp; &nbsp; &nbsp;(let ((script
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; (expand-file-name &quot;exec_ssl_quietly&quot; url-configuration-directory)))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(if (not (file-executable-p script))
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;;; Need to create our handy-dandy utility script to shut OpenSSL
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;;; up completely.
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(progn
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(write-region &quot;#!/bin/sh\n\nexec \&quot;$@\&quot; 2&gt; /dev/null\n&quot; nil
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;script nil 5)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(set-file-modes script 493))) ; (rwxr-xr-x)
 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;(setq ssl-exec-wrapper script)))
 &nbsp; &nbsp;(cons ssl-exec-wrapper (cons ssl-program-name ssl-program-arguments))))

(defun open-ssl-stream (name buffer host service)
 &nbsp;&quot;Open a SSL connection for a service to a host.
Returns a subprocess-object to represent the connection.
Input and output work as for subprocesses; `delete-process' closes it.
Args are NAME BUFFER HOST SERVICE.
NAME is name for process. &nbsp;It is modified if necessary to make it unique.
BUFFER is the buffer (or buffer name) to associate with the process.
Process output goes at end of that buffer, unless you specify
an output stream or filter function to handle the output.
BUFFER may be also nil, meaning that this process is not associated
with any buffer.
Third arg is name of the host to connect to, or its IP address.
Fourth arg SERVICE is name of the service desired, or an integer
specifying a port number to connect to.&quot;
 &nbsp;(if (integerp service) (setq service (int-to-string service)))
 &nbsp;(let* ((process-connection-type nil)
 &nbsp; &nbsp; &nbsp; &nbsp; (port service)
 &nbsp; &nbsp; &nbsp; &nbsp; (proc (eval `(start-process name buffer ,@(ssl-get-command)))))
 &nbsp; &nbsp;(process-kill-without-query proc)
 &nbsp; &nbsp;proc))

(provide 'ssl)

;; arch-tag: 659fae92-1c67-4055-939f-32153c2f5114
</PRE>