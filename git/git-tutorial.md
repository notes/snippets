Git Tutorial
============

Initialize a repository:

    $ mkdir t
    $ cd t
    $ git init
    Initialized empty Git repository in /Users/admin/t/.git/

Check default configuration:

    $ git config --list
    core.editor=vim
    user.name=notes
    user.email=notes@localhost.localdomain

Update any configuration you need to change:

    $ git config --local user.name "My Name"
    $ git config --global user.email "myname@example.jp"

where options mean:

  * --system: system global configuration
  * --global: current user global configuration
  * --local: repository local configuration

Add a file to the repository:

    $ echo test > test
    $ git add test
    $ git commit

Fire up a web interface:

    $ git instaweb --httpd=lighttpd --port=10080
    $ firefox http://localhost:10080/
    ...
    $ git instaweb --stop

