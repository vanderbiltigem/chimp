#ifndef __ERR_H__
#define __ERR_H__

#define ERR(something)    \
  do {                    \
    something;            \
    if (errno) {          \
      perror("failed: "); \
      _exit(1);           \
    }                     \
  } while (0)

#endif /* __ERR_H__ */
