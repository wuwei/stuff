;; -*- coding: utf-8-emacs; -*-
(setq nnrss-group-data '((10 (19487 58007 463843) "http://feedproxy.google.com/~r/commandliners/~3/nFXufWxmts4/" "hex2bin preserving endianness in C" "pfortuny" "Fri, 11 Jun 2010 12:35:58 +0000" "<p>I cannot help copying this snippet. Assume <code>f</code> is a <code>(char *)</code> of length <code>L</code>, containing an hex string like <code>'0aabdda'</code> (without the leading “0x”, like something coming from a sha function —or like the sha1 stored by Leopard in the password files, which is the origin of this problem). You want to transform it into the corresponding sequence of bytes (that is, assuming the string is of even length, otherwise, we add a trailing, yes, trailing, at the end, ‘0′). We shall store the result in <code>t</code>, which points to a <code>(char *)</code> of length <code>L/2</code>.</p>
<p>The following C code does the trick: (first of all we <strong>must</strong> set <code>t</code> to <code>0</code>);</p>
<pre><code>int k = (L%2 ? L/2+1 : L/2);
memset(t, 0, L/2);
for(i=0; i<L; i++){
t[i/2] += ((i%2) ? 1 : 16) *
((f[i] > 'F') ? (f[i] - 'a' + 10) :
((f[i] > '9') ? (f[i] - 'A' + 10) :
(f[i] - '0')))
}
</code></pre>
<p>Thus, if <code>f</code> points to the string <code>100aff</code>, <code>t</code> points to the sequence of bytes <code>16, 10, 255</code> after the loop.</p>
<p>The reverse operation is well known:</p>
<pre><code>for(i=0; i<k; i++){
sprintf(f+2*i, \"%02X\", t[i]);
}
</code></pre>
<p>I just don’t want to forget it.</p>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/nFXufWxmts4\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/06/hex2bin-preserving-endianness-in-c/#comments" "5b1f19e2a20ed478e0bbe478e6b8a172") (9 (19487 58007 462412) "http://feedproxy.google.com/~r/commandliners/~3/pk-3oNHXiDM/" "echo -n woes" "pfortuny" "Thu, 20 May 2010 15:42:10 +0000" "<p>It took me quite a while to realize that the following line does <strong>not</strong> do what you think it does:</p>
<pre><code>$ echo '$1$CSmo96nX$G0PL/Cs/of5qDN2vMnyHp0' | openssl base64 | tr -d '\\n'</code></pre>
<p>You should <strong>always</strong> use the <code>-n</code> option if you want to make sure there is no spurious trailing newline:</p>
<pre><code>$ echo -n '$1$CSmo96nX$G0PL/Cs/of5qDN2vMnyHp0' | openssl base64 | tr -d '\\n'</code></pre>
<p>(By the way, the encrypted message says just <code>'patata0'</code> and it is <strong>not</strong> my password).</p>
<p>Or… is it?</p>
<p>Tested on two Linux systems (Fedora & Ubuntu) and one Snow Leopard.</p>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/pk-3oNHXiDM\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/05/echo-n-woes/#comments" "d0f1dde2736c52ad9f42fae0d6a44d97") (8 (19487 58007 461430) "http://feedproxy.google.com/~r/commandliners/~3/iHETjX-co3M/" "Setting variables in emacs at file header" "pfortuny" "Tue, 27 Apr 2010 07:00:08 +0000" "<p>When editing LaTeX files, I usually call the master file of a project <tt>00father.ltx</tt> for historical reasons. Moreover, the following line is part of my <tt>.emacs</tt>:</p>
<pre><code>(setq-default TeX-master \"00father.ltx\")</code></pre>
<p>because most of the time I am editing multifile projects.</p>
<p>However, from time to time I need to write a single-file document and in this case, naming it <tt>00father.ltx</tt> is not <i>that</i> useful, and I do not want to have to set the <tt>master-file</tt> variable each time I load the file.</p>
<p>There is an easy way to get this done. Just include a line at the top of the file -as a comment in the appropriate language- setting the variables. The syntax is as follows (in C, for example):</p>
<pre><code>/* -*- variable1: value1; variable2: value2; -*- */</code></pre>
<p>I am giving two examples. The first one in C again. Assume this is the header of a file called <tt>trial.c</tt></p>
<pre><code>/* *-* tab-width: 8; column-number-mode: 1; fill-column: 80; -*- */</code></pre>
<p>The line tells emacs to set the length of a tab to 8 spaces (usual in BSD), to show the column number in the information line and to wrap lines (if wrapping -fill-mode- is set) at 80 characters.</p>
<p>For my LaTeX issue, the first line of a single-file document <tt>letter_to_my_friend.ltx</tt> goes as follows (notice the difference in the comment syntax):</p>
<pre><code>% -*- TeX-master: \"letter_to_my_friend.ltx\"; -*-</code></pre>
<p>I have checked and if your file is a shell script, which usually begins with</p>
<pre><code>#!/bin/sh</code></pre>
<p>(or some similar line), you can place the variable-setting line just afterwards.</p>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/iHETjX-co3M\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/04/setting-variables-in-emacs-at-file-header/#comments" "bf3f3ff10815700793b9df7d3ba840ab") (7 (19487 58007 460122) "http://feedproxy.google.com/~r/commandliners/~3/smqfSdFp51U/" "Reverting to a previous version with svn (rollback)" "pfortuny" "Thu, 22 Apr 2010 07:20:38 +0000" "<p>To rollback (that is, revert to a previous version) some files/dirs… using subversion, you need <a href=\"http://aralbalkan.com/1381\">as Aral Balkan explains</a> to</p>
<ul>
<li> Merge the previous version
<li> Commit
</ul>
<p>Like this (assumming you want to roll back from version 61 to 58):</p>
<pre><code>pera $ svn merge r61:58 https://my.project.at.sourceforge/svnroot/project/dir1/src/
[... output ...]
pera $ svn ci -m \"Reverted to version 58\"
</code></pre>
<p>which is strange but works. Forget about the <i>revert</i> command, it has a different functionality.<br />
You may want to run</p>
<pre><code>pera $ svn merge --dry-run r61:58 ........
</code></pre>
<p>to check the changes which will take place before messing everything up.</p>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/smqfSdFp51U\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/04/reverting-to-a-previous-version-with-svn-rollback/#comments" "3f6883a0cb6d9c1504ecfd112693eac1") (6 (19487 58007 459119) "http://feedproxy.google.com/~r/commandliners/~3/JcV3tWRUTTw/" "IPCS" "n0str0m0" "Thu, 15 Apr 2010 18:30:28 +0000" "<p><code>ipcs</code> shows the status of SYSV inter process communication facilities.</p>
<pre><code>$ ipcs -s
------ Semaphore Arrays --------
key        semid      owner      perms      nsems
0xdd3adabd 0          fernape    600        1
</code></pre>
<p>I had forgotten about this command but I remembered it when we ran out of semaphores in our Linux system two days ago.</p>
<p>Other way of getting the same information is to <code>cat</code> the following files:</p>
<pre><code>$ ls /proc/sysvipc
msg        sem        shm
</code></pre>
<p>Enjoy!</p>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/JcV3tWRUTTw\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/04/ipcs/#comments" "a2fbef5af667ad751e5668d241e520fc") (5 (19487 58007 458165) "http://feedproxy.google.com/~r/commandliners/~3/8HIbPzohSvY/" "Setting a Timer" "rafacas" "Wed, 07 Apr 2010 07:55:04 +0000" "<p>Sometimes I need a timer to focus on something and to alert me when to stop. Remember, we are real commandliners, so we do not want those fancy applications with a lot of features, we <strong>need</strong> a script ;-) so here it is:</p>
<pre><code>#!/bin/bash
usage() {
name=`basename $0`
echo \"Usage: $name hh:mm:ss\"
echo \"Example: $name \\\"00:15:30\\\"\"
}
if [ $# != 1 ]
then
usage
exit
fi
IFS=:
set -- $*
secs=$(( ${1#0} * 3600 + ${2#0} * 60 + ${3#0} ))
while [ $secs -gt 0 ]
do
sleep 1 &
printf \"\\r%02d:%02d:%02d\" $((secs/3600)) $(((secs/60)%60)) $((secs%60))
secs=$(( $secs - 1 ))
wait
done
echo
</code></pre>
<p>It works in any POSIX shell.</p>
<p>I was writing one but I found <a href=\"http://www.unix.com/shell-programming-scripting/98889-display-runnning-countdown-bash-script.html\">this thread of the UNIX and linux forum</a> where the user cfajohnson solves it in a better way.</p>
<p>The code:</p>
<pre><code>sleep 1 &
...
wait
</code></pre>
<p>minimizes the skew of the loop, so every cycle is as close to 1 second as possible.</p>
<p>I have not included the final <em>beep</em> in the script. You can do it with the usual:</p>
<pre><code>printf (\"\\a\")</code></pre>
<p>which works on all unix-like systems.</p>
<p>In linux you can use the <code>beep</code> command that allows you to control pitch, duration, and repetitions, for example:</p>
<pre><code>$ beep -f 300.7 -r 2 -d 100 -l 400</code></pre>
<p>makes 2 repetitions of a beep at 300.7 Hz for 400 milliseconds and a delay between repetitions of 100 milliseconds.</p>
<p>In OS X you can play with the <code><a href=\"http://commandliners.com/tag/say/\">say</a></code> command:</p>
<pre><code>$ say \"You deserve some rest\"</code></pre>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/8HIbPzohSvY\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/04/setting-a-timer/#comments" "f6ff72fe67e39ea603a61ddd0d4ab05c") (4 (19487 58007 406396) "http://feedproxy.google.com/~r/commandliners/~3/xGQDO1HfJLE/" "Downloading a file with wget through a specific interface" "rafacas" "Sat, 27 Mar 2010 11:32:11 +0000" "<p>Sometimes I need to download a file from a computer with multiple net interfaces, but only one is connected to the Internet. In these cases I use the <code>bind-address</code> option of the <code>wget</code> command, which binds the connection to the <code>address</code> specified in the local machine.</p>
<pre><code>$ wget --bind-address=192.168.213.141 \\
> ftp://ftp.icm.edu.pl/vol/rzm1/linux-fedora-secondary/development/source/SRPMS/ppp-2.4.4-11.fc11.src.rpm
--2010-03-27 12:25:56--  ftp://ftp.icm.edu.pl/vol/rzm1/linux-fedora-secondary/development/source/SRPM/ppp-2.4.4-11.fc11.src.rpm
=> `ppp-2.4.4-11.fc11.src.rpm.1'
Resolving ftp.icm.edu.pl... 193.219.28.140
Connecting to ftp.icm.edu.pl|193.219.28.140|:21... connected.
Logging in as anonymous ... Logged in!
==> SYST ... done.    ==> PWD ... done.
==> TYPE I ... done.  ==> CWD /vol/rzm1/linux-fedora-secondary/development/source/SRPMS ... done.
==> SIZE ppp-2.4.4-11.fc11.src.rpm ... 724348
==> PASV ... done.    ==> RETR ppp-2.4.4-11.fc11.src.rpm ... done.
Length: 724348 (707K)
100%[========================================>] 724,348      173K/s   in 4.1s
2010-03-27 12:26:03 (173 KB/s) - `ppp-2.4.4-11.fc11.src.rpm.1' saved [724348]
</code></pre>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/xGQDO1HfJLE\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/03/downloading-a-file-with-wget-through-a-specific-interface/#comments" "f3580861bba2f75ff9063e5485131d07") (3 (19487 58007 405069) "http://feedproxy.google.com/~r/commandliners/~3/-WsIiIp_Ztw/" "Shell scripting for Nautilus" "n0str0m0" "Thu, 18 Mar 2010 22:08:47 +0000" "<p>It has been a while since I wrote my last post. Sorry for the delay, but I was a bit busy lately. In this post, I shall explain how to get the most of your nautilus file manager by using shell scripts.</p>
<p>Nautilus provides some facilities available from shell scripts. Combining them with a small utility called zenity can improve your daily tasks.</p>
<p>Nautilus has the ability of executing shell scripts applying them to the selected files. The executable scripts are those present in the following directory:</p>
<pre><code>~/.gnome2/nautilus-scripts</code></pre>
<p>Every script present in that directory will be shown in the “Scripts” entry of the contextual menu that shows up by right-clicking on a file. If that entry is not shown, navigate into the directory mentioned above in Nautilus and you will see a message indicating that all the scripts in the folder will be available from now on.<br />
Nautilus sets up four environment variables for the process executing the script which are:</p>
<pre><code>NAUTILUS_SCRIPT_SELECTED_FILE_PATHS: selected file paths.
NAUTILUS_SCRIPT_SELECTED_URIS: URIs delimited by \\n
NAUTILUS_SCRIPT_CURRENT_URI: Current URI
NAUTILUS_SCRIPT_WINDOW_GEOMETRY: size and location of the current window
</code></pre>
<p>In addition, the names (without the full path) of all the selected items are passed to the script as input parameters.</p>
<p>These scripts will be executed silently (not in a terminal window) so it seems reasonable to be able to communicate with the user. Enter zenity.</p>
<p><strong><u>Introducing zenity</u></strong><br />
zenity is a program for displaying GTK+ dialogs. It reads data from stdin and returns user input through stdou. It is an easy way of gathering and showing information from a shell script on a desktop environment. Here are some examples on how to use zenity:</p>
<p>Show an information window:</p>
<pre><code>$ zenity --info --title=InfoWindow --text=\"This is an information text\"
<img class=\"alignnone size-full wp-image-1829\" src=\"http://commandliners.com/wp-content/uploads/2010/03/zenity-info-window.png\" alt=\"zenity-info-window\" width=\"254\" height=\"149\" />
</code></pre>
<p>Get some user input:</p>
<pre><code>$zenity --entry --title=EntryWindow --text=\"Type a text, please\"
<img class=\"alignnone size-full wp-image-1828\" src=\"http://commandliners.com/wp-content/uploads/2010/03/zenity-entry-window.png\" alt=\"zenity-entry-window\" width=\"208\" height=\"137\" />
Hello World!
$
</code></pre>
<p>As you can see, zenity provides an easy way to interact with the user in a graphical environment.</p>
<p>With this little information, it is possible to write a small debugging script. I called it <code>test.sh</code></p>
<pre><code>#! /bin/bash
# Use /usr/local/bin/bash on FreeBSD
ZENITY=$(which zenity)
$ZENITY --info --text=\"$*\"
$ZENITY --info --text=\"NAUTILUS_SCRIPT_SELECTED_FILE_PATHS = $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS\"
$ZENITY --info --text=\"NAUTILUS_SCRIPT_SELECTED_URIS = $NAUTILUS_SCRIPT_SELECTED_URIS\"
$ZENITY --info --text=\"NAUTILUS_SCRIPT_CURRENT_URI  = $NAUTILUS_SCRIPT_CURRENT_URI\"
$ZENITY --info --text=\"NAUTILUS_SCRIPT_WINDOW_GEOMETRY = $NAUTILUS_SCRIPT_WINDOW_GEOMETRY\"
</code></pre>
<p>This script shows the contents of the parameters and the Nautilus variables.</p>
<p>zenity is really easy to use, and with a little effort and some bash scripting knowledge (that I will not explain, because it is out of the scope of this post) you can write a convenience script like the one below (I named it <code>packit.sh</code>):</p>
<pre><code>#! /bin/bash
# Use /usr/local/bin/bash on FreeBSD
#
# Small script intended to be used from Nautilus.
# It compresses the selected files and/or directories
# in several formats
# Requires: zenity, tar, gzip, bzip2, zip, mkisofs
FORMATS=\"tar tgz tbz2 zip iso9660\"
ZENITY=$(which zenity)
# Check if we have selected any files...
if [ -z \"$NAUTILUS_SCRIPT_SELECTED_FILE_PATHS\" ]; then
$ZENITY --error --text=\"No files selected\"
exit 0;
fi
# Ask for output file name
output_filename=packit-$(date +%s)
output_filename=$($ZENITY --entry --title=\"Output file name\" --text=\"Type file name\" --entry-text=\"$output_filename\")
# Ask the user to select a compressing format
selected_format=$($ZENITY --title=\"Select format\" --list --column=Format $FORMATS)
if [ -z \"$selected_format\" ]; then
$ZENITY --error --text=\"No format selected\"
exit 0;
fi
# Select the compressing utility to use
case $selected_format in
\"tar\")
COMP_COMMAND=\"tar cvf\"
;;
\"tgz\")
COMP_COMMAND=\"tar czvf\"
;;
\"tbz2\")
COMP_COMMAND=\"tar cjvf\"
;;
\"zip\")
COMP_COMMAND=\"zip -9\"
;;
\"iso9660\")
COMP_COMMAND=\"mkisofs -R -o\"
;;
esac
# Execute the command while showing a progress bar.
(echo \"0\" ;
$COMP_COMMAND \"$output_filename\" $NAUTILUS_SCRIPT_SELECTED_FILE_PATHS
echo \"100\") | $ZENITY --progress --pulsate --title=Working...
</code></pre>
<p>The script above works for me, but it assumes the existence of several commands. If you want to use it you might need modify some lines.</p>
<p>Enjoy!</p>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/-WsIiIp_Ztw\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/03/shell-scripting-for-nautilus/#comments" "e4d968ad09aecea8744d10864c208592") (2 (19487 58007 402468) "http://feedproxy.google.com/~r/commandliners/~3/IFzn2H8pHP0/" "Running e2fsck on a mounted filesystem" "rafacas" "Wed, 24 Feb 2010 12:43:15 +0000" "<p>I know, running <code>fsck</code> on a mounted filesystem is utterly unrecommended. The command warns you (it actually <i>frightens</i> you) with the following message:</p>
<pre><code># fsck /dev/VolGroup00/LogVol00
fsck 1.41.4 (27-Jan-2009)
e2fsck 1.41.4 (27-Jan-2009)
/dev/VolGroup00/LogVol00 is mounted.
WARNING!!!  Running e2fsck on a mounted filesystem may cause
SEVERE filesystem damage.
Do you really want to continue (y/n)? no
check aborted.
</code></pre>
<p>But sometimes I need to check a filesystem in a remote host, so I cannot boot from a liveCD to run <code>fsck</code> in the unmounted device. Looking for an option allowing me to overcome this nuisance I found the following in e2fsck’s man page:</p>
<pre><code>Note  that  in general it is not safe to run e2fsck on mounted filesys-
tems.  The only exception is if the -n option is specified, and -c, -l,
or  -L  options  are not specified.
</code></pre>
<p>Using <code>e2fsck</code> instead of <code>fsck</code> is not a problem because it checks ext2 and ext3 filesystems and mine are ext3 (<code>fsck</code> checks and optionally repairs a lot of filesystem types).</p>
<p>Let us see what the man page says about the <code>-n</code> option:</p>
<pre><code>-n     Open the filesystem read-only, and assume an answer of  `no'  to
all  questions.   Allows  e2fsck  to  be used non-interactively.
(Note: if the -c, -l, or -L options are specified in addition to
the -n option, then the filesystem will be opened read-write, to
permit the bad-blocks list to be  updated.   However,  no  other
changes will be made to the filesystem.)  This option may not be
specified at the same time as the -p or -y options.
</code></pre>
<p>So it seems to be safe running it with that option. But the <code>e2fsck</code> man page also states (dealing with the safe check):</p>
<pre><code>However, even if it is safe to do
so, the results printed by e2fsck are not valid if  the  filesystem  is
mounted.    If e2fsck asks whether or not you should check a filesystem
which is mounted, the only correct answer is ``no''.  Only experts  who
really know what they are doing should consider answering this question
in any other way.
</code></pre>
<p>So, I use it only when I want to know if there is something wrong with the filesystem. I run it with the <code>-f</code> option too which forces checking even if the file system seems clean.</p>
<pre><code># e2fsck -fn /dev/VolGroup00/LogVol00
e2fsck 1.41.4 (27-Jan-2009)
Warning!  /dev/VolGroup00/LogVol00 is mounted.
Warning: skipping journal recovery because doing a read-only filesystem check.
Pass 1: Checking inodes, blocks, and sizes
Pass 2: Checking directory structure
Pass 3: Checking directory connectivity
Pass 4: Checking reference counts
Pass 5: Checking group summary information
F10-i686-Live: 123335/475136 files (3.8% non-contiguous), 876070/1900544 blocks
</code></pre>
<p>If the output is like above all is OK, but if the device has errors, then you will need to run <code>fsck</code> with the filesystem unmounted.</p>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/IFzn2H8pHP0\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/02/running-e2fsck-on-a-mounted-filesystem/#comments" "5f3993ec00d4794223883638adf4f245") (1 (19487 58007 400696) "http://feedproxy.google.com/~r/commandliners/~3/Txgd26e5BlA/" "Force fsck at next boot" "rafacas" "Tue, 23 Feb 2010 09:31:51 +0000" "<pre><code># touch /forcefsck</code></pre>
<p>Creating an empty <code>forcefsck</code> file in the root directoy will force <code>fsck</code> to run at the next boot.</p>
<img src=\"http://feeds.feedburner.com/~r/commandliners/~4/Txgd26e5BlA\" height=\"1\" width=\"1\"/>" nil "http://commandliners.com/2010/02/force-fsck-at-next-boot/#comments" "ca81ac9243e179931aa9e838b4e64f2c")))