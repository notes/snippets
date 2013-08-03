How to use /proc filesysytem
============================

Show process status

    # cat /proc/1234/status
    Name:    bash                    # executable name
    State:   S (sleeping)            # process state
    Tgid:    1234                    # process ID (thread group ID)
    Pid:     1234                    # thread ID
    PPid:    1229                    # parent process ID
    TracerPid:    0                  # tracer process ID (0 means not traced)
    Uid:     222 222 222 222         # real, effective, saved, fs UID
    Gid:     500 500 500 500         # real, effective, saved, fs GID
    FDSize:  256                     # allocated size of fd table
    Groups:  10 500                  # supplementary groups IDs
    VmPeak:  110436 kB               # VM peak size
    VmSize:  110436 kB               # VM current size
    VmLck:   0 kB                    # size locked on the physical RAM
    VmPin:   0 kB                    # 
    VmHWM:   1996 kB                 # RSS peak size
    VmRSS:   1996 kB                 # RSS current size
    VmData:  348 kB                  # heap size
    VmStk:   136 kB                  # stack size
    VmExe:   836 kB                  # code segment size
    VmLib:   1916 kB                 # shared lib code segment size
    VmPTE:   60 kB                   # page table size
    VmSwap:  0 kB                    # 
    Threads: 1                       # number of threads
    SigQ:    0/13070                 # current/max number of queued signals
    SigPnd:  0000000000000000        # thread pending signals
    ShdPnd:  0000000000000000        # process pending signals
    SigBlk:  0000000000010000        # blocked signals
    SigIgn:  0000000000384004        # ignored signals
    SigCgt:  000000004b813efb        # caught signals
    CapInh:  0000000000000000        # inheritance capabilities
    CapPrm:  0000000000000000        # permitted capabilities
    CapEff:  0000000000000000        # effeictive capabilities
    CapBnd:  ffffffffffffffff        # capability bounding set
    Cpus_allowed:      1             # allowed cpus mask
    Cpus_allowed_list: 0             # allowed cpus list
    Mems_allowed:  00000000,00000001 # allowed memory nodes mask
    Mems_allowed_list: 0             # allowed memory nodes list
    voluntary_ctxt_switches: 153     # voluntary context switches
    nonvoluntary_ctxt_switches: 27   # forced context switches
