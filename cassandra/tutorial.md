Cassandra Tutorial
==================

This is a manual installation/configuration procedure.  If you are looking for more prepared and sophisticated way, you should see [http://www.datastax.com/docs](http://www.datastax.com/docs).

Install:

    $ wget http://cassandra.apache.org/.../apache-cassandra-x.y.z-bin.tar.gz
    $ tar xvzf apache-cassandra-x.y.z-bin.tar.gz
    $ export CASSANDRA_HOME=$(pwd)/apache-cassandra-x.y.z

Configuration and some fixups:

    $ mkdir -p ~/cassandra/{log,data,commitlog,saved_caches}
    $ perl -pi -e "s|/var/lib/cassandra|$HOME/cassandra|" $CASSANDRA_HOME/conf/cassandra.yaml
    $ vim $CASSANDRA_HOME/conf/cassandra-env.sh
        ...
        # remove too restrictive "-Xss180k"
        JVM_OPTS="$JVM_OPTS -Xss180k"
        ...
    $ vim $CASSANDRA_HOME/conf/log4j-server.properties
        ...
        # remove "stdout" if you like
        log4j.rootLogger=INFO,stdout,R
        ...
        # change to $HOME/cassandra/log, for example
        log4j.appender.R.File=/var/log/cassandra/system.log
        ...

Startup:

    $ $CASSANDRA_HOME/bin/cassandra
    $ tail -f ~/cassandra/log/system.log

Create a keyspace

    $ $CASSANDRA_HOME/bin/cassandra-cli
    Connected to: "Test Cluster" on 127.0.0.1/9160
    Welcome to Cassandra CLI version 1.2.8
    
    Type 'help;' or '?' for help.
    Type 'quit;' or 'exit;' to quit.
    
    [default@unknown] create keyspace sampleKeyspace with
      placement_strategy='org.apache.cassandra.locator.SimpleStrategy' and
      strategy_options = {replication_factor:1};
    a46ada65-41bf-35d2-9195-5783f41a9d7d

Check the keyspace:

    [default@unknown] show keyspaces;    
    Keyspace: sampleKeyspace:
      Replication Strategy: org.apache.cassandra.locator.SimpleStrategy
      Durable Writes: true
        Options: [replication_factor:1]
      Column Families:

Use it:

    [default@unknown] use sampleKeyspace;
    Authenticated to keyspace: sampleKeyspace
    [default@sampleKeyspace]

Create a column family (sort of table):

    [default@sampleKeyspace] create column family hosts with
      key_validation_class='UTF8Type' and comparator='UTF8Type' and
      default_validation_class='UTF8Type';
    62591b7f-892d-34a1-98a6-d623785782fb

Insert values:

    [default@sampleKeyspace] set hosts[1][hostname] = 'www.example.jp';
    Value inserted.
    Elapsed time: 130 msec(s).
    [default@sampleKeyspace] set hosts[1][ip] = '192.168.0.1';
    Value inserted.
    Elapsed time: 2.52 msec(s).
    [default@sampleKeyspace] set hosts[2][hostname] = 'mail.example.jp';
    Value inserted.
    Elapsed time: 2.95 msec(s).
    [default@sampleKeyspace] set hosts[2][ip] = '192.168.0.2';
    Value inserted.
    Elapsed time: 2.45 msec(s).

Fetch and list values:

    [default@sampleKeyspace] get hosts[1];
    => (name=hostname, value=www.example.jp, timestamp=1376832062095000)
    => (name=ip, value=192.168.0.1, timestamp=1376832074794000)
    Returned 2 results.
    Elapsed time: 15 msec(s).
    [default@sampleKeyspace] list hosts;
    Using default limit of 100
    Using default cell limit of 100
    -------------------
    RowKey: 2
    => (name=hostname, value=mail.example.jp, timestamp=1376832088149000)
    => (name=ip, value=192.168.0.2, timestamp=1376832096746000)
    -------------------
    RowKey: 1
    => (name=hostname, value=www.example.jp, timestamp=1376832062095000)
    => (name=ip, value=192.168.0.1, timestamp=1376832074794000)
    
    2 Rows Returned.
    Elapsed time: 147 msec(s).

Truncate all values in a column family:

    [default@sampleKeyspace] truncate hosts;
    hosts truncated.
    [default@sampleKeyspace] list hosts;
    Using default limit of 100
    Using default cell limit of 100
    
    0 Row Returned.
    Elapsed time: 2.81 msec(s).

Drop the column family:

    [default@sampleKeyspace] drop column family hosts;
    9a03b98e-7f6c-3a3a-ad80-c85e5720356e

There is also an SQL-ish client:

    $ $CASSANDRA_HOME/bin/cqlsh
    Connected to Test Cluster at localhost:9160.
    [cqlsh 3.1.6 | Cassandra 1.2.8 | CQL spec 3.0.0 | Thrift protocol 19.36.0]
    Use HELP for help.
    cqlsh> help
    ...

Check the keyspace:

    cqlsh> describe keyspace sampleKeyspace
    
    CREATE KEYSPACE "sampleKeyspace" WITH replication = {
      'class': 'SimpleStrategy',
      'replication_factor': '1'
    };

