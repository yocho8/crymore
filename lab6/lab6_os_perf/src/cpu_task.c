#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
  int task_id = 1;
  uint64_t iterations = 80000000ULL;

  if (argc >= 2) {
    task_id = atoi(argv[1]);
    if (task_id <= 0) task_id = 1;
  }
  if (argc >= 3) {
    iterations = strtoull(argv[2], NULL, 10);
    if (iterations == 0) iterations = 80000000ULL;
  }

  volatile double acc = 0.0;
  double x = 1.0 + (double)task_id / 1000.0;

  for (uint64_t i = 1; i <= iterations; ++i) {
    double a = (double)(i % 1000) + x;
    acc += sqrt(a) * sin(a) * cos(a / 3.0);
    if ((i & 1023ULL) == 0ULL) {
      x += 0.000001;
    }
  }

  printf("task=%d result=%.10f\n", task_id, acc);
  return 0;
}
