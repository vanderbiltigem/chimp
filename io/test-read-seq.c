#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "err.h"

const size_t BLOCK_FACTOR = 10;

int main(int argc __attribute__((unused)), char ** argv) {
  struct stat fileinfo;
  ERR(stat(argv[1], &fileinfo));
  blksize_t block_size = fileinfo.st_blksize;
  fprintf(stderr, "block size: %ld\n", block_size);
  int fd                 = open(argv[1], O_RDONLY);
  size_t read_block_size = block_size * BLOCK_FACTOR;
  char * buf             = malloc(read_block_size);
  ssize_t cur_num_bytes;
  size_t cur_ind;
  size_t num_ones = 0;
  while ((cur_num_bytes = read(fd, buf, read_block_size))) {
    ERR();
    for (cur_ind = 0; cur_ind < (size_t) cur_num_bytes; ++cur_ind) {
      if (buf[cur_ind] > 0) { ++num_ones; }
    }
  }
  printf("%s: %zu\n", "number > 0", num_ones);
  ERR(close(fd));
  free(buf);
}
