CC = gcc
CFLAGS = -std=gnu99 -fnested-functions -Wall -I/opt/local/include
LDFLAGS = -L/opt/local/lib

pcre: pcre.c
	$(CC) $(CFLAGS) -o pcre pcre.c $(LDFLAGS) -lpcre

pcap: pcap.c
	$(CC) $(CFLAGS) -o pcap pcap.c $(LDFLAGS) -lpcap

pcap_sort: pcap_sort.c
	$(CC) $(CFLAGS) -o pcap_sort pcap_sort.c $(LDFLAGS) -lpcap

clean:
	rm -f pcre pcap pcap_sort
