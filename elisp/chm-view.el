<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><head><title>EmacsWiki: chm-view.el</title><link rel="alternate" type="application/wiki" title="Edit this page" href="http://www.emacswiki.org/emacs?action=edit;id=chm-view.el" /><link type="text/css" rel="stylesheet" href="/emacs/wiki.css" /><meta name="robots" content="INDEX,FOLLOW" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki" href="http://www.emacswiki.org/emacs?action=rss" /><link rel="alternate" type="application/rss+xml" title="EmacsWiki: chm-view.el" href="http://www.emacswiki.org/emacs?action=rss;rcidonly=chm-view.el" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content"
      href="http://www.emacswiki.org/emacs/full.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki with page content and diff"
      href="http://www.emacswiki.org/emacs/full-diff.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Emacs Wiki including minor differences"
      href="http://www.emacswiki.org/emacs/minor-edits.rss" />
<link rel="alternate" type="application/rss+xml"
      title="Changes for chm-view.el only"
      href="http://www.emacswiki.org/emacs?action=rss;rcidonly=chm-view.el" /><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/></head><body class="http://www.emacswiki.org/emacs"><div class="header"><a class="logo" href="http://www.emacswiki.org/emacs/SiteMap"><img class="logo" src="/emacs_logo.png" alt="[Home]" /></a><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs/Suggestions">Suggestions</a> </span>
<!-- Google CSE Search Box Begins  -->
<form class="tiny" action="http://www.google.com/cse" id="searchbox_004774160799092323420:6-ff2s0o6yi"><p>
<input type="hidden" name="cx" value="004774160799092323420:6-ff2s0o6yi" />
<input type="text" name="q" size="25" />
<input type="submit" name="sa" value="Search" />
</p></form>
<script type="text/javascript" src="http://www.google.com/coop/cse/brand?form=searchbox_004774160799092323420%3A6-ff2s0o6yi"></script>
<!-- Google CSE Search Box Ends -->
<br /><span class="specialdays">Philippines, Independence Day, Russia, National Day</span><h1><a title="Click to search for references to this page" rel="nofollow" href="http://www.google.com/cse?cx=004774160799092323420:6-ff2s0o6yi&amp;q=%22chm-view.el%22">chm-view.el</a></h1></div><div class="wrapper"><div class="content browse"><p class="download"><a href="download/chm-view.el">Download</a></p><pre class="code"><span class="linecomment">;;; chm-view.el --- View CHM file.</span>

<span class="linecomment">;; Filename: chm-view.el</span>
<span class="linecomment">;; Description: View CHM file.</span>
<span class="linecomment">;; Author: Andy Stewart &lt;lazycat.manatee@gmail.com&gt;</span>
<span class="linecomment">;; Maintainer: Andy Stewart &lt;lazycat.manatee@gmail.com&gt;</span>
<span class="linecomment">;; Copyright (C) 2009, Andy Stewart, all rights reserved.</span>
<span class="linecomment">;; Created: 2009-01-28 21:35:26</span>
<span class="linecomment">;; Version: 0.2.2</span>
<span class="linecomment">;; Last-Updated: 2009-04-16 10:48:52</span>
<span class="linecomment">;;           By: Andy Stewart</span>
<span class="linecomment">;; URL: http://www.emacswiki.org/emacs/download/chm-view.el</span>
<span class="linecomment">;; Keywords: chm, chm-view</span>
<span class="linecomment">;; Compatibility: GNU Emacs 23.0.60.1</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Features that might be required by this library:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; This file is NOT part of GNU Emacs</span>

<span class="linecomment">;;; License</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; This program is free software; you can redistribute it and/or modify</span>
<span class="linecomment">;; it under the terms of the GNU General Public License as published by</span>
<span class="linecomment">;; the Free Software Foundation; either version 3, or (at your option)</span>
<span class="linecomment">;; any later version.</span>

<span class="linecomment">;; This program is distributed in the hope that it will be useful,</span>
<span class="linecomment">;; but WITHOUT ANY WARRANTY; without even the implied warranty of</span>
<span class="linecomment">;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the</span>
<span class="linecomment">;; GNU General Public License for more details.</span>

<span class="linecomment">;; You should have received a copy of the GNU General Public License</span>
<span class="linecomment">;; along with this program; see the file COPYING.  If not, write to</span>
<span class="linecomment">;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth</span>
<span class="linecomment">;; Floor, Boston, MA 02110-1301, USA.</span>

<span class="linecomment">;;; Commentary:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; View CHM file.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; This package is view CHM file in Emacs.</span>
<span class="linecomment">;; This package use `archmage' decompress</span>
<span class="linecomment">;; CHM file and view in browser.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Below are commands you can use:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;      `chm-view-file'         View CHM file.</span>
<span class="linecomment">;;      `chm-view-dired'        View dired marked CHM files.</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; Installation:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; This package is base on `archmage', so make sure</span>
<span class="linecomment">;; `archmage' have install in your system, like me</span>
<span class="linecomment">;; (I use Debian), install `archmage':</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;      sudo aptitude install archmage -y</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; And then put chm-view.el to your load-path.</span>
<span class="linecomment">;; The load-path is usually ~/elisp/.</span>
<span class="linecomment">;; It's set in your ~/.emacs like this:</span>
<span class="linecomment">;; (add-to-list 'load-path (expand-file-name "~/elisp"))</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; And the following to your ~/.emacs startup file.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; (require 'chm-view)</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; That's all, enjoy! :)</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; Note:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; Because “archmage” need time to extract CHM file,</span>
<span class="linecomment">;; if browser (such as emacs-w3m) open special port before “archmage” extract completed,</span>
<span class="linecomment">;; it will got error “Cannot retrieve URL: http://localhost:531560 (exit status: 0)”,</span>
<span class="linecomment">;; then you just refresh current page in browser, problem will be fix.</span>
<span class="linecomment">;; If you always get error when open CHM file,</span>
<span class="linecomment">;; you need setup a bigger value to option `chm-view-delay' (default is 0.3 second).</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; Customize:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; `chm-view-delay'</span>
<span class="linecomment">;;      The delay time before view CHM file.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; All of the above can customize by:</span>
<span class="linecomment">;;      M-x customize-group RET chm-view RET</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; Change log:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; 2009/04/16</span>
<span class="linecomment">;;      * Fix `absolute path' problem with file.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; 2009/04/10</span>
<span class="linecomment">;;      * Fix doc.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; 2009/01/29</span>
<span class="linecomment">;;      * Add option `chm-view-delay'.</span>
<span class="linecomment">;;</span>
<span class="linecomment">;; 2009/01/28</span>
<span class="linecomment">;;      * First released.</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; Acknowledgements:</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; TODO</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>
<span class="linecomment">;;</span>

<span class="linecomment">;;; Require</span>


<span class="linecomment">;;; Code:</span>

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Customize ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(defgroup chm-view nil
  "<span class="quote">Interface for chm-view.</span>"
  :group 'edit)

(defcustom chm-view-delay 0.3
  "<span class="quote">The delay time before view CHM file.
This is necessary spend time to start sub-process.</span>"
  :type 'number
  :group 'chm-view)

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Variable ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(defvar chm-view-last-filename nil
  "<span class="quote">The name of last visit CHM file.</span>")

(defvar chm-view-pid nil
  "<span class="quote">The PID of chm-view process.</span>")
(make-variable-buffer-local 'chm-view-pid)

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Interactive Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(defun chm-view-file (&optional file)
  "<span class="quote">View CHM FILE.</span>"
  (interactive)
  <span class="linecomment">;; Get file name.</span>
  (or file (setq file (read-file-name (format "<span class="quote">CHM file: (%s) </span>" (or chm-view-last-filename "<span class="quote"></span>"))
                                      nil chm-view-last-filename)))
  <span class="linecomment">;; Record last visit file name.</span>
  (setq chm-view-last-filename file)
  <span class="linecomment">;; View.</span>
  (chm-view-internal file))

(defun chm-view-dired ()
  "<span class="quote">View dired marked files.</span>"
  (interactive)
  (dolist (file (dired-get-marked-files))
    (chm-view-internal file)))

<span class="linecomment">;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Utilities Functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;</span>
(defun chm-view-internal (file)
  "<span class="quote">Internal function for view CHM FILE.</span>"
  (let ((random-number (chm-view-get-unique-number))
        proc)
    (with-current-buffer (get-buffer-create
                          <span class="linecomment">;; Need leave one whitespace before buffer name.</span>
                          (format "<span class="quote"> *chm-view&lt;%s&gt;*</span>" random-number))
      (setq proc (start-process (buffer-name) (current-buffer)
                                "<span class="quote">archmage</span>" "<span class="quote">-p</span>" random-number (expand-file-name file)))
      <span class="linecomment">;; Just wait a moment.</span>
      (sit-for chm-view-delay)
      <span class="linecomment">;; Browse.</span>
      (browse-url (format "<span class="quote">http://localhost:%s</span>" random-number))
      <span class="linecomment">;; Record PID of `chm-view' process.</span>
      (setq chm-view-pid (process-id proc))
      <span class="linecomment">;; Add interrupt process of buffer to kill-buffer-hook.</span>
      (add-hook 'kill-buffer-hook
                '(lambda ()
                   (when chm-view-pid
                     <span class="linecomment">;; Kill `chm-view' process,</span>
                     <span class="linecomment">;; and don't avoid output message.</span>
                     (flet ((message (&rest args)))
                       (shell-command (format "<span class="quote">kill -9 %s</span>" chm-view-pid)))
                     <span class="linecomment">;; Reset `chm-view-pid'.</span>
                     (setq chm-view-pid nil)))))))

(defun chm-view-get-unique-number ()
  "<span class="quote">Get a unique number.</span>"
  (let (time-now buffer)
    (setq time-now (current-time))
    (format "<span class="quote">%s</span>" (nth 2 time-now))))

(provide 'chm-view)

<span class="linecomment">;;; chm-view.el ends here</span>


<span class="linecomment">;;; LocalWords:  archmage pid args</span></span></pre></div><div class="wrapper close"></div></div><div class="footer"><hr /><span class="gotobar bar"><a class="local" href="http://www.emacswiki.org/emacs/SiteMap">SiteMap</a> <a class="local" href="http://www.emacswiki.org/emacs/Search">Search</a> <a class="local" href="http://www.emacswiki.org/emacs/ElispArea">ElispArea</a> <a class="local" href="http://www.emacswiki.org/emacs/HowTo">HowTo</a> <a class="local" href="http://www.emacswiki.org/emacs/RecentChanges">RecentChanges</a> <a class="local" href="http://www.emacswiki.org/emacs/News">News</a> <a class="local" href="http://www.emacswiki.org/emacs/Problems">Problems</a> <a class="local" href="http://www.emacswiki.org/emacs/Suggestions">Suggestions</a> </span><span class="translation bar"><br />  <a class="translation new" rel="nofollow" href="http://www.emacswiki.org/emacs?action=translate;id=chm-view.el;missing=de_en_es_fr_it_ja_ko_pt_ru_se_zh">Add Translation</a></span><span class="edit bar"><br /> <a class="edit" accesskey="e" title="Click to edit this page" rel="nofollow" href="http://www.emacswiki.org/emacs?action=edit;id=chm-view.el">Edit this page</a> <a class="history" rel="nofollow" href="http://www.emacswiki.org/emacs?action=history;id=chm-view.el">View other revisions</a> <a class="admin" rel="nofollow" href="http://www.emacswiki.org/emacs?action=admin;id=chm-view.el">Administration</a></span><span class="time"><br /> Last edited 2009-04-16 02:50 UTC by <a class="author" title="from 121.13.172.246" href="http://www.emacswiki.org/emacs/AndyStewart">AndyStewart</a> <a class="diff" rel="nofollow" href="http://www.emacswiki.org/emacs?action=browse;diff=2;id=chm-view.el">(diff)</a></span><div style="float:right; margin-left:1ex;">
<!-- Creative Commons License -->
<a href="http://creativecommons.org/licenses/GPL/2.0/"><img alt="CC-GNU GPL" style="border:none" src="/pics/cc-GPL-a.png" /></a>
<!-- /Creative Commons License -->
</div>

<!--
<rdf:RDF xmlns="http://web.resource.org/cc/"
 xmlns:dc="http://purl.org/dc/elements/1.1/"
 xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
<Work rdf:about="">
   <license rdf:resource="http://creativecommons.org/licenses/GPL/2.0/" />
  <dc:type rdf:resource="http://purl.org/dc/dcmitype/Software" />
</Work>

<License rdf:about="http://creativecommons.org/licenses/GPL/2.0/">
   <permits rdf:resource="http://web.resource.org/cc/Reproduction" />
   <permits rdf:resource="http://web.resource.org/cc/Distribution" />
   <requires rdf:resource="http://web.resource.org/cc/Notice" />
   <permits rdf:resource="http://web.resource.org/cc/DerivativeWorks" />
   <requires rdf:resource="http://web.resource.org/cc/ShareAlike" />
   <requires rdf:resource="http://web.resource.org/cc/SourceCode" />
</License>
</rdf:RDF>
-->

<p class="legal">
This work is licensed to you under version 2 of the
<a href="http://www.gnu.org/">GNU</a> <a href="/GPL">General Public License</a>.
Alternatively, you may choose to receive this work under any other
license that grants the right to use, copy, modify, and/or distribute
the work, as long as that license imposes the restriction that
derivative works have to grant the same rights and impose the same
restriction. For example, you may choose to receive this work under
the
<a href="http://www.gnu.org/">GNU</a>
<a href="/FDL">Free Documentation License</a>, the
<a href="http://creativecommons.org/">CreativeCommons</a>
<a href="http://creativecommons.org/licenses/sa/1.0/">ShareAlike</a>
License, the XEmacs manual license, or
<a href="/OLD">similar licenses</a>.
</p>
</div>
</body>
</html>
