Install Zabbix on Amazon Linux
==============================

Compile and install:

    $ sudo yum install gcc libcurl-devel mysql-devel net-snmp-devel
    $ ./configure --prefix=/usr/local/zabbix-2.0.7 \
        --enable-server --enable-agent \
        --with-mysql --with-net-snmp --with-libcurl
    $ make
    $ sudo make install

Install tree looks like:

    $ find /usr/local/zabbix-2.0.7 -type f
    /usr/local/zabbix-2.0.7/etc/zabbix_agent.conf
    /usr/local/zabbix-2.0.7/etc/zabbix_agentd.conf
    /usr/local/zabbix-2.0.7/etc/zabbix_server.conf
    /usr/local/zabbix-2.0.7/sbin/zabbix_server
    /usr/local/zabbix-2.0.7/sbin/zabbix_agentd
    /usr/local/zabbix-2.0.7/sbin/zabbix_agent
    /usr/local/zabbix-2.0.7/share/man/man8/zabbix_agentd.8
    /usr/local/zabbix-2.0.7/share/man/man8/zabbix_server.8
    /usr/local/zabbix-2.0.7/share/man/man1/zabbix_get.1
    /usr/local/zabbix-2.0.7/share/man/man1/zabbix_sender.1
    /usr/local/zabbix-2.0.7/bin/zabbix_sender
    /usr/local/zabbix-2.0.7/bin/zabbix_get

Edit agent configuration:

    $ sudo vim /usr/local/zabbix-2.0.7/etc/zabbix_agentd.conf
    ...
    LogFile=/var/log/zabbix_agentd.log
    Server=127.0.0.1
    ...

Edit server configuration:

    $ sudo vim /usr/local/zabbix-2.0.7/etc/zabbix_server.conf
    ...
    LogFile=/var/log/zabbix_server.log
    DBPassword=hogehoge
    ...

Insert DB schema:

    $ mysql -uroot -phogehoge
    mysql> create user 'zabbix'@'localhost' identified by 'hogehoge';
    mysql> grant all on zabbix.* to 'zabbix'@'localhost' with grant option;
    mysql> quit;
    $ mysql -uzabbix -phogehoge
    mysql> create database zabbix character set utf8 collate utf8_bin;
    mysql> quit;
    $ mysql -uzabbix -phogehoge zabbix < database/mysql/schema.sql
    $ mysql -uzabbix -phogehoge zabbix < database/mysql/images.sql
    $ mysql -uzabbix -phogehoge zabbix < database/mysql/data.sql

Setup OS user:

    $ sudo groupadd zabbix
    $ sudo useradd -g zabbix zabbix
    $ sudo touch /var/log/zabbix_{agentd,server}.log
    $ sudo chown zabbix:zabbix /var/log/zabbix_{agentd,server}.log

Start server:

    $ sudo /usr/local/zabbix-2.0.7/sbin/zabbix_server
