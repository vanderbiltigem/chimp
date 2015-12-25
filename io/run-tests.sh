#!/bin/bash

random_input=out-bin

# uncomment this to create a new one
# DON'T FORGET THAT THE FIRST TIME TOUCHING THIS FILE IS SLOW
# echo "creating random file $random_input..."
# create random file
# dd if=/dev/urandom of="$random_input" count=100MB iflag=count_bytes
# for i in $(seq 3); do
#   echo -n "iteration $i: start..."
#   cat out-bin >> out-bin2
#   echo 'end'
#   cat out-bin2 >> out-bin
# done
# echo 'done'

num_indices=10000
block_length=400
random_indices=parse-indices.h
cp parse-indices-stub.h "$random_indices"
echo -n "creating random indices $random_indices..."
coffee create-random-indices.coffee "$random_input" "$random_indices" \
       "$num_indices" "$block_length"
echo 'done'

echo -n 'compiling all files...'
for file in *.c; do
  gcc -DNUM_INDICES="$num_indices" -DBLOCK_LENGTH="$block_length" "$file" \
      -o "$(basename -s .c $file)" -Ofast -Wall -Wextra -Werror
done
echo 'done'

echo -n 'touching file...'
./test-fread-seq "$random_input" >/dev/null 2>/dev/null
echo 'done'

echo '----'
echo 'Sequential Testing:'
echo 'mmap:'
time ./test-mmap-seq "$random_input"
echo 'read:'
time ./test-read-seq "$random_input"
echo 'fread:'
time ./test-fread-seq "$random_input"

echo '----'
echo 'Random Testing:'
echo 'mmap:'
time ./test-mmap-random "$random_input"
echo 'read:'
time ./test-read-random "$random_input"
echo 'fread:'
time ./test-fread-random "$random_input"

# rm out-bin

# results
# $ ./run-tests.sh
# creating random file out-bin...
# creating random indices parse-indices.h...done
# compiling all files...done
# touching file...done
# ----
# Sequential Testing:
# mmap:
# num > 0: 3820696859

# real	1m19.284s
# user	0m3.883s
# sys	0m1.920s
# read:
# block size: 4096
# number > 0: 3820696859

# real	1m19.070s
# user	0m2.823s
# sys	0m2.563s
# fread:
# block size: 4096
# number > 0: 3820696859

# real	1m11.124s
# user	0m2.867s
# sys	0m2.330s
# ----
# Random Testing:
# mmap:
# number > 0: 1984105

# real	0m40.350s
# user	0m0.017s
# sys	0m0.260s
# read:
# number > 0: 1984105

# real	0m0.165s
# user	0m0.003s
# sys	0m0.003s
# fread:
# number > 0: 1984105

# real	0m0.071s
# user	0m0.003s
# sys	0m0.007s
# ./run-tests.sh  12.80s user 9.88s system 5% cpu 6:30.51 total

# so it looks like mmap is fine for sequential, but dies on random small reads
