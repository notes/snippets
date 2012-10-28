#!/bin/sh

# print all internal options
java \
 -XX:+PrintFlagsFinal \
 -XX:+UnlockDiagnosticVMOptions \
 -XX:+UnlockExperimentalVMOptions \
 -version

# important tuning options
java \
 -server \
 -classpath foo.jar:bar.jar \
 -Dproperty.name=value \
 -verbose:gc \
 -Xms2G \
 -Xmx2G \
 -Xloggc:/var/tmp/gc.log \
 -XX:NewSize=1G \
 -XX:MaxNewSize=1G \
 -XX:PermSize=512M \
 -XX:MaxPermSize=512M \
 -XX:+PrintCommandLineFlags \
 -XX:+PrintCompilation \
 -XX:+HeapDumpOnOutOfMemoryError \
 -XX:+DisableExplicitGC \
 -XX:+PrintGCDetails \
 -XX:+PrintGCTimeStamps \
 -XX:+PrintGCDateStamps \
 -XX:+PrintGCApplicationStoppedTime \
 -XX:+PrintGCApplicationConcurrentTime \
 -XX:+TraceClassLoading \
 -XX:+TraceClassUnloading \
