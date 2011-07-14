#include <stdio.h>
#include <string.h>
#include <netdb.h>
#include <sys/socket.h>
#include <pcap.h>

int main(int argc, char **argv)
{
  pcap_if_t *if_list = NULL;
  char errbuf[PCAP_ERRBUF_SIZE] = {0};
  int find_ret = pcap_findalldevs(&if_list, errbuf);
  if (find_ret == -1) {
    fprintf(stderr, "pcap_findalldevs() failed: %s", errbuf);
    return -1;
  }

  for (pcap_if_t *if_cur = if_list; if_cur; if_cur = if_cur->next) {
    printf("name: %s\n", if_cur->name);
    if (if_cur->description) {
      printf("description: %s\n", if_cur->description);
    }
    if (if_cur->flags & PCAP_IF_LOOPBACK) {
      printf("flags: LOOPBACK\n");
    }
    for (pcap_addr_t *addr = if_cur->addresses; addr; addr = addr->next) {
      struct sockaddr *sa = addr->addr;
      switch (sa->sa_family) {
      case AF_INET:
      case AF_INET6:
        printf("family: %s\n", sa->sa_family == AF_INET ? "inet" : "inet6");
        char hbuf[NI_MAXHOST];
        int gni_ret = getnameinfo(sa, sa->sa_len, hbuf, sizeof hbuf, NULL, 0, NI_NUMERICHOST);
        if (gni_ret != 0) {
          fprintf(stderr, "getnameinfo() failed: %s\n", gai_strerror(gni_ret));
          return -1;
        }
        printf("address: %s\n", hbuf);
        break;
      default:
        break;
      }
    }
    printf("----------------------------------------------------------\n");
  }

  pcap_freealldevs(if_list);
  return 0;
}
