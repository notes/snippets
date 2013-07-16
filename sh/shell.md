Shell Script
============

### getopts

You can use getopts() at the head of a script or a function.

    foo() {
      while getopts a:b:c opt; do
        case $opt in
          a)
            echo "-a ${OPTARG}"
            ;;
          b)
            echo "-b ${OPTARG}"
            ;;
          c)
            echo "-c"
            ;;
          *)
            echo "Usage: $0 [-a x] [-b y] [-c]"
            return 1
            ;;
        esac
      done
    
      shift $((OPTIND - 1))
      echo "Reminders: $*"
      return 0
    }

