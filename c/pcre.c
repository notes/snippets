#include <stdio.h>
#include <string.h>
#include <pcre.h>

int main(int argc, char **argv)
{
  const char *errptr;
  int erroffset;
  // named subpattern is the most conservative in python style
  pcre *p = pcre_compile("^(?P<service>[^\\s#]+)\\s+(?P<port>\\d+)/(?P<transport>[^\\s#]+)",
                         PCRE_CASELESS, &errptr, &erroffset, NULL);
  if (p == NULL) {
    fprintf(stderr, "pcre_compile() failed: %s\n", errptr);
    return -1;
  }

  pcre_extra *pe = pcre_study(p, 0, &errptr);
  if (pe == NULL) {
    fprintf(stderr, "pcre_study() failed: %s\n", errptr);
    return -1;
  }

  // the most memory sufficient way to extract subpattern
  // if you don't mind copying overhead, use pcre_{get,copy}_named_substring[list] instead
  int service_num = pcre_get_stringnumber(p, "service");
  int port_num = pcre_get_stringnumber(p, "port");
  int transport_num = pcre_get_stringnumber(p, "transport");
  if (service_num == PCRE_ERROR_NOSUBSTRING || 
      port_num == PCRE_ERROR_NOSUBSTRING || 
      transport_num == PCRE_ERROR_NOSUBSTRING) {
    fprintf(stderr, "one of the named subpatterns not found\n");
    return -1;
  }

  FILE *f = fopen("/etc/services", "r");
  char line[BUFSIZ+1];
  while (fgets(line, BUFSIZ, f)) {
    // array size should be (num_of_subpatterns + 1) * 3
    // offset information is returned in the first 2/3, rest is the working space
    int ovector[12];
    int exec_ret = pcre_exec(p, pe, line, strlen(line), 0, 0, ovector, 12);
    if (exec_ret == PCRE_ERROR_NOMATCH) {
      continue;
    } else if (exec_ret < 0) {
      fprintf(stderr, "pcre_exec() failed: error code %d\n", exec_ret);
      return -1;
    } else {
      void locate_substring(const char *s, int num, int *ovector, const char **start, int *len) {
        *start = &s[ovector[num * 2]];
        *len = ovector[num * 2 + 1] - ovector[num * 2];
      }

      const char *s;
      int len;
      locate_substring(line, service_num, ovector, &s, &len);
      printf("service: %.*s\n", len, s);
      locate_substring(line, port_num, ovector, &s, &len);
      printf("port: %.*s\n", len, s);
      locate_substring(line, transport_num, ovector, &s, &len);
      printf("transport: %.*s\n", len, s);
      printf("-----------------------\n");
    }
  }
  fclose(f);

  return 0;
}
