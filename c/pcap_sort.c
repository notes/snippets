#include <stdio.h>
#include <pcap.h>

struct packet {
  struct pcap_pkthdr h;
  char *d;
};

int main(int argc, char **argv)
{
  char errbuf[PCAP_ERRBUF_SIZE];
  pcap_t *p = pcap_open_offline(argv[1], errbuf);
  if (p == NULL) {
    fprintf(stderr, "pcap_open_offline() failed: %s\n", errbuf);
    return -1;
  }

  char *d;
  struct pcap_pkthdr ph;
  while ((d = pcap_next(p, &ph)) != NULL) {
    struct timeval *t = &ph.ts;
    printf("%lu.%06lu\n", t->tv_sec, (unsigned long)t->tv_usec);
  }

  pcap_close(p);
  return 0;
}
