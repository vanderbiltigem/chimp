#include <sys/mman.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <stdlib.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include "err.h"
#include "parse-indices.h"

int main(int argc __attribute__((unused)), char ** argv) {
  struct stat fileinfo;
  ERR(stat(argv[1], &fileinfo));
  off_t file_size = fileinfo.st_size;
  int fd = open(argv[1], O_RDWR);
  char * fcontents =
      mmap(NULL, file_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  if (MAP_FAILED == fcontents) { ERR(); }
  size_t num_ones      = 0;
  off_t cur_off;
  off_t cur_base;
  for (size_t rand_ind = 0; rand_ind < NUM_INDICES; ++rand_ind) {
    cur_base = indices_arr[rand_ind];
    for (cur_off = cur_base; cur_off - cur_base < BLOCK_LENGTH; ++cur_off) {
      if (fcontents[cur_off] > 0) { ++num_ones; }
    }
  }
  printf("%s: %zu\n", "number > 0", num_ones);
  ERR(munmap(fcontents, file_size));
  ERR(close(fd));
  return 0;
}
