#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include "err.h"

int main(int argc __attribute__((unused)), char ** argv) {
  struct stat fileinfo;
  ERR(stat(argv[1], &fileinfo));
  off_t file_size = fileinfo.st_size;
  int fd = open(argv[1], O_RDWR);
  char * fcontents =
      mmap(NULL, file_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (MAP_FAILED == fcontents) { ERR(); }
  /* this doesn't appear to do anything */
  ERR(madvise(fcontents, file_size, MADV_SEQUENTIAL));
  size_t num_ones = 0;
  for (off_t cur_off = 0; cur_off < file_size; ++cur_off) {
    if (fcontents[cur_off] > 0) { ++num_ones; }
  }
  printf("%s: %zu\n", "num > 0", num_ones);
  ERR(munmap(fcontents, file_size));
  ERR(close(fd));
  return 0;
}
