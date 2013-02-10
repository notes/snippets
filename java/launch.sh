#!/bin/sh

java \
 # print computed values for basic options.
 # heap size, young/old generation space, GC algorithms.
 -XX:+PrintCommandLineFlags \
 # print all flags value extensively.
 -XX:+PrintFlagsFinal \
 # ...including debug/experimanetal options.
 -XX:+UnlockDiagnosticVMOptions \
 -XX:+UnlockExperimentalVMOptions \
 # print JVM version number
 -version \
 # prefer throughput over startup speed
 -server \
 # use 64-bit VM for larger virtual memory
 -d64 \
 -classpath foo.jar:bar.jar \
 -Dproperty.name=value \
 # dump heap memory image on OutOfMemoryError thrown
 -XX:+HeapDumpOnOutOfMemoryError \

 # initial heap size
 -Xms2G \
 -XX:InitialHeapSize=2G \
 # maximum heap size
 -Xmx2G \
 -XX:MaxHeapSize=2G \
 # young generation space initial size
 -XX:NewSize=1G \
 # young generation space maximum size
 -XX:MaxNewSize=1G \
 # you can use this shortcut if -XX:NewSize == -XX:MaxNewSize
 -Xmn1G \
 # if total heap size changes dynamically (i.e. -Xms != -Xmx),
 # this option allows young generation space to follow accordingly.
 # -XX:NewRatio=3 means young:old = 1:3.
 -XX:NewRatio=3 \
 # old generation space (usually not needed)
 -XX:OldSize=1G \

 # permanent generation space initial size
 -XX:PermSize=512M \
 # permanent generation space maximum size
 -XX:MaxPermSize=512M \

 # use single-threaded GC (DefNew) in young space
 -XX:+UseSerialGC
 # use multi-threaded throughput GC (PSYoungGen) in young space.
 # "PS" of PSYoungGen means "Parallel Scavenge".
 # automatically enabled by -XX:+UseParallelOldGC.
 -XX:+UseParallelGC \
 # use multi-threaded throughput GC (PSOldGen)
 -XX:+UseParallelOldGC \
 # use multi-threaded GC (ParNew) in young space.
 # automatically enalbed by -XX:+UseConcMarkSweepGC.
 -XX:+UseParNewGC
 # use concurrent mark & sweep (CMS)
 -XX:+UseConcMarkSweepGC \
 # adjust survivor space size in young generation.
 # -XX:SurvivorRatio=5 means eden:survivor1:survivor2 = 5:1:1.
 -XX:SurvivorRatio=5 \
 # the maximum value of generation threshold, above which objects
 # are promoted to old space.  note that this is a maximum value,
 # not an actual threshold, which is adjusted automatically by VM.
 -XX:MaxTenuringThreshold=15 \
 # logging objects age in survivor spaces
 -XX:+PrintTenuringDistribution \
 # if survivor occupancy exceeds this value after minor GC,
 # tenuring threshold will be adjusted adversely.
 -XX:TargetSurvivorRatio=60 \
 # initial occupancy threshold at which CMS cycle starts
 -XX:CMSInitiatingOccupancyFraction=65 \
 # don't adjust occupancy threshold for CMS cycle
 -XX:+UseCMSInitiatingOccupancyOnly \
 # calling System.gc() starts CMS cycle
 -XX:+ExplicitGCInvokesConcurrent \
 -XX:+ExplicitGCInvokesConcurrentAndUnloadsClasses \
 # the number of threads in throughput GC or CMS remark phase
 -XX:ParallelGCThreads=10 \
 # do minor GC just before CMS remark phase
 -XX:+CMSScavengeBeforeRemark \

 # always use interpreter (disable JIT compile)
 -Xint \
 # logging JIT compile activity
 -XX:+PrintCompilation \
 # disable JIT compile for the specific methods
 -XX:CompileCommand=exclude,java.util.HashMap,* \
 # logging method inlining activity
 -XX:+PrintInlining \
 # the method size in bytes above which inlining is disabled
 -XX:MaxInlineSize=100 \

 # logging GC activity verbosely
 -verbose:gc \
 # write GC activity to the file as opposed to stdout
 -Xloggc:/var/tmp/gc.log \
 # logging GC activity more verbosely
 -XX:+PrintGCDetails \
 # disable the effect of System.gc() method
 -XX:+DisableExplicitGC \
 # prepend timestamps to GC log in seconds since the startup
 -XX:+PrintGCTimeStamps \
 # prepend timestamps to GC log in human readable format
 -XX:+PrintGCDateStamps \
 # print each time span when application stops
 -XX:+PrintGCApplicationStoppedTime \
 # print each time span when application is running
 -XX:+PrintGCApplicationConcurrentTime \
 # logging class loading activity
 -XX:+TraceClassLoading \
 # logging class unloading activity
 -XX:+TraceClassUnloading \

 # jar file containing application main class
 -jar foo.jar


