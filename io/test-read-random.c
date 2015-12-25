#include <sys/types.h>
#include <sys/stat.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include "err.h"
#include "parse-indices.h"

int main(int argc __attribute__((unused)), char ** argv) {
  int fd     = open(argv[1], O_RDONLY);
  char * buf = malloc(BLOCK_LENGTH);
  ssize_t cur_num_bytes;
  size_t num_ones = 0;
  size_t cur_off_in_buf;
  for (size_t cur_ind = 0; cur_ind < NUM_INDICES; ++cur_ind) {
    ERR(lseek(fd, indices_arr[cur_ind], SEEK_SET));
    ERR(cur_num_bytes = read(fd, buf, BLOCK_LENGTH));
    for (cur_off_in_buf = 0; cur_off_in_buf < (size_t) cur_num_bytes;
         ++cur_off_in_buf) {
      if (buf[cur_off_in_buf] > 0) { ++num_ones; }
    }
  }
  printf("%s: %zu\n", "number > 0", num_ones);
  ERR(close(fd));
  free(buf);
}
