phpMyAdmin
==========

Install:

    $ sudo yum install httpd php phpMyAdmin

Startup:

    $ sudo service httpd start

Configuration:

    $ sudo vim $PHPMYADMIN/libraries/vendor_config.php
    Edit some global parameters.
    ...
    $ firefox http://localhost/phpMyAdmin/setup/
    Press the "New Server" button and setup default MySQL server.
    You have to setup at least connection type, username & password.
    Press the "Save" button in the end.
    ...
    $ sudo cp /var/lib/phpMyAdmin/config/config.php.inc /etc/phpMyAdmin/


Login:

    $ firefox http://localhost/phpMyAdmin/