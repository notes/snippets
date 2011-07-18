#include <stdio.h>

int return_int(void) {
  // call/callq instruction uses %eax as a return value
  __asm__("movl $10, %eax");
}

int main(int argc, char **argv)
{
  printf("%d\n", return_int());
  return 0;
}
