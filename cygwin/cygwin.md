Cygwin
======

List installed packages:

    $ cygcheck -c -d

Search packages on cygwin.com:

    $ cygcheck -p zsh

List files included in a package:

    $ cygcheck -l php-mbstring

Find the package to which a file belongs:

    $ cygcheck -f /bin/ls.exe

Launch setup.exe with cygwinports repository:

    $ setup -K http://cygwinports.org/ports.gpg
    // proceed following GUI instructions
    // add ftp://ftp.cygwinports.org/pub/cygwinports as a download URL

