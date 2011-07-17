#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pcap.h>

struct packet {
  struct pcap_pkthdr h;
  unsigned char *d;
};

// sort pcap_pkthdr by timestamp
int compar(const void *a, const void *b)
{
  struct timeval *tv_a = &((*(struct packet **)a)->h.ts);
  struct timeval *tv_b = &((*(struct packet **)b)->h.ts);
  if (tv_a->tv_sec > tv_b->tv_sec) {
    return 1;
  } else if (tv_a->tv_sec < tv_b->tv_sec) {
    return -1;
  } else {
    if (tv_a->tv_usec > tv_b->tv_usec) {
      return 1;
    } else if (tv_a->tv_usec < tv_b->tv_usec) {
      return -1;
    } else {
      return 0;
    }
  }
}

int main(int argc, char **argv)
{
  if (argc != 3) {
    fprintf(stderr, "Usage: pcap_sort input.cap output.cap\n");
    return -1;
  }

  // read input
  char errbuf[PCAP_ERRBUF_SIZE];
  pcap_t *p = pcap_open_offline(argv[1], errbuf);
  if (p == NULL) {
    fprintf(stderr, "pcap_open_offline() failed: %s\n", errbuf);
    return -1;
  }

  const unsigned char *d;
  int pkt_count = 0;
  int array_len = 10000;
  struct pcap_pkthdr ph;
  struct packet **pkt_array = malloc(sizeof(struct packet *) * array_len);
  while ((d = pcap_next(p, &ph)) != NULL) {
    struct packet *pkt = malloc(sizeof *pkt);
    pkt->d = malloc(ph.len);
    memcpy(pkt->d, d, ph.len);
    memcpy(&pkt->h, &ph, sizeof ph);
    pkt_array[pkt_count++] = pkt;
    if (pkt_count >= array_len) {
      array_len += 10000;
      pkt_array = realloc(pkt_array, sizeof(struct packet *) * array_len);
    }
  }
  printf("Finished reading %d packets\n", pkt_count);

  // sort
  qsort(pkt_array, pkt_count, sizeof *pkt_array, compar);
  printf("Finished sorting\n");

  // write output
  pcap_t *p_out = pcap_open_dead(pcap_datalink(p), 65535);
  pcap_dumper_t *dumper = pcap_dump_open(p_out, argv[2]);
  if (dumper == NULL) {
    fprintf(stderr, "pcap_dump_open() failed: %s\n", pcap_geterr(p_out));
    return -1;
  }

  for (int i=0; i<pkt_count; i++) {
    struct packet *pkt = pkt_array[i];
    pcap_dump((u_char *)dumper, &pkt->h, pkt->d);
  }

  if (pcap_dump_flush(dumper) == -1) {
    fprintf(stderr, "pcap_dump_flush() failed\n");
    return -1;
  }

  pcap_dump_close(dumper);
  printf("Finished writing output\n");

  pcap_close(p_out);
  pcap_close(p);
  return 0;
}
