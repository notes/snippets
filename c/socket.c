#include <iostream>
#include <cstdlib>
#include <cstring>
#include <cerrno>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netdb.h>
#include <netinet/in.h>
#include <arpa/inet.h>

struct connect_result {
  int fd;
  int gai_errno;
  int sys_errno;
  struct sockaddr_in sin;
};

bool socket_connect(const char *hostname, const char *portname, connect_result& result)
{
  result.fd = -1;
  result.sys_errno = 0;
  result.gai_errno = 0;

  struct addrinfo gai_hints, *gai_results;
  memset(&gai_hints, 0, sizeof gai_hints);
  gai_hints.ai_family = AF_INET;
  gai_hints.ai_socktype = SOCK_STREAM;

  int gai_errno = getaddrinfo(hostname, portname, &gai_hints, &gai_results);
  if (gai_errno != 0) {
    result.gai_errno = gai_errno;
    if (gai_errno == EAI_SYSTEM) {
      result.sys_errno = errno;
    }
    return false;
  }

  bool done = false;
  for (struct addrinfo *ai = gai_results; ai && !done; ai = ai->ai_next) {
    result.sys_errno = 0;
    result.sin = *(struct sockaddr_in *)ai->ai_addr;

    int fd = socket(ai->ai_family, ai->ai_socktype, ai->ai_protocol);
    if (fd == -1) {
      result.sys_errno = errno;
      continue;
    }

    int connect_ret = connect(fd, ai->ai_addr, ai->ai_addrlen);
    if (connect_ret == -1) {
      result.sys_errno = errno;
      close(fd);
      continue;
    }

    result.fd = fd;
    done = true;
  }

  freeaddrinfo(gai_results);
  return done;
}

int main(int argc, char **argv)
{
  if (argc != 3) {
    std::cout << "Usage: xxx hostname portname" << std::endl;
    std::exit(1);
  }

  const char *hostname = argv[1];
  const char *portname = argv[2];

  connect_result result;
  bool connect_ret = socket_connect(hostname, portname, result);
  if (!connect_ret) {
    std::cout << "Failed to connect " << hostname << ":" << portname << std::endl;
    if (result.gai_errno) {
      std::cout << "getaddrinfo: " << gai_strerror(result.gai_errno) << std::endl;
    } else if (result.sys_errno) {
      std::cout << gai_strerror(result.sys_errno) << std::endl;
    }
    std::exit(2);
  }

  std::cout << "Connected to " << inet_ntoa(result.sin.sin_addr) << std::endl;
  return 0;
}

