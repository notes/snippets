#include <stdio.h>
#include <regex.h>

regex_t reComment;
regex_t reKeyValue;

__attribute__((constructor))
static void init(void)
{
  regcomp(&reComment, "^[[:space:]]*#", REG_EXTENDED);
  regcomp(&reKeyValue, "^[[:space:]]*([[:alnum:]]+)[[:space:]]*=[[:space:]]*(.+)[[:space:]]*$", REG_EXTENDED);
}

int main(int argc, const char **argv)
{
  char buf[BUFSIZ+1];
  while (fgets(buf, BUFSIZ, stdin)) {
    regmatch_t match[3];
    if (regexec(&reComment, buf, 1, match, 0) == 0) {
      continue;
    }

    if (regexec(&reKeyValue, buf, 3, match, 0) == 0) {
      char *key = &buf[match[1].rm_so];
      char *value = &buf[match[2].rm_so];
      int keylen = match[1].rm_eo - match[1].rm_so;
      int valuelen = match[2].rm_eo - match[2].rm_so;
      printf("Key:%.*s, Value:%.*s\n", keylen, key, valuelen, value);
    }
  }
  return 0;
}

