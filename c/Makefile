CC = gcc
CFLAGS = -std=gnu99 -fnested-functions -Wall -I/opt/local/include
LDFLAGS = -L/opt/local/lib

pcre: pcre.c
	$(CC) $(CFLAGS) -o pcre pcre.c $(LDFLAGS) -lpcre

clean:
	rm -f pcre
