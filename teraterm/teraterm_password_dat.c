/*
 * TeraTerm macro password.dat decoder.
 * Decode an obfuscated password string in password.dat.
 *
 * Some of the source code in this file is copied from TeraTerm
 * source repository on the site http://ttssh2.sourceforge.jp/,
 * specifically teraterm/ttpmacro/ttmenc.c file.  The original
 * copyright is duplicated below.
 */

/*
Copyright (c) T.Teranishi.
Copyright (c) TeraTerm Project.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification,
are permitted provided that the following conditions are met:

  1. Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.
  2. Redistributions in binary form must reproduce the above copyright notice,
     this list of conditions and the following disclaimer in the documentation
     and/or other materials provided with the distribution.
  3. The name of the author may not be used to endorse or promote products derived
     from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES,
INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA,
OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

typedef char *PCHAR;
typedef unsigned char BYTE;
typedef BYTE *LPBYTE;

static void DecCombine(PCHAR Str, int *i, BYTE b)
{
  int cptr, bptr;
  unsigned int d;

  cptr = *i / 8;
  bptr = *i % 8;
  if (bptr==0) {
    Str[cptr] = 0;
  }

  d = ((BYTE)Str[cptr] << 8) |
    (b << (10 - bptr));

  Str[cptr] = (BYTE)(d >> 8);
  Str[cptr+1] = (BYTE)(d & 0xff);
  *i = *i + 6;
  return;
}

static BYTE DecCharacter(BYTE c, LPBYTE b)
{
  BYTE d;

  if (c < *b) {
    d = ((BYTE)0x5e) + c - *b;
  } else {
    d = c - *b;
  }
  d = d & 0x3f;

  if (*b<0x30) {
    *b = 0x30;
  } else if (*b<0x40) {
    *b = 0x40;
  } else if (*b<0x50) {
    *b = 0x50;
  } else if (*b<0x60) {
    *b = 0x60;
  } else if (*b<0x70) {
    *b = 0x70;
  } else {
    *b = 0x21;
  }

  return d;
}

int main(int argc, char **argv)
{
  PCHAR InStr = argv[1];
  int i, j, k;
  BYTE b;
  BYTE Temp[512];
  PCHAR OutStr = malloc(100);

  OutStr[0] = 0;
  j = strlen(InStr);
  if (j==0) {
    return 0;
  }
  b = 0x21;
  for (i=0 ; i < j ; i++) {
    Temp[i] = DecCharacter(InStr[i],&b);
  }
  if ((Temp[0] ^ Temp[j-1]) != (unsigned)0x3f) {
    return 0;
  }
  i = 1;
  k = 0;
  while (i < j-2) {
    Temp[i] = ((BYTE)Temp[i] - (BYTE)Temp[i+1]) & (BYTE)0x3f;
    DecCombine(OutStr,&k,Temp[i]);
    i = i + 2;
  }

  puts(OutStr);
  return 1;
}

