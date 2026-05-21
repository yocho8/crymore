#define _POSIX_C_SOURCE 200809L
#include <errno.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

static long count_lines(const char *path) {
  FILE *f = fopen(path, "r");
  if (!f) {
    fprintf(stderr, "cant open %s for counting: %s\n", path, strerror(errno));
    exit(1);
  }

  long lines = 0;
  int ch;
  while ((ch = fgetc(f)) != EOF) {
    if (ch == '\n') ++lines;
  }
  fclose(f);
  return lines;
}

int main(int argc, char **argv) {
  if (argc < 2) {
    fprintf(stderr, "usage: %s file\n", argv[0]);
    return 2;
  }

  const char *path = argv[1];
  long initial_lines = count_lines(path);

  FILE *in = fopen(path, "r");
  if (!in) {
    fprintf(stderr, "cant open %s for reading: %s\n", path, strerror(errno));
    return 1;
  }

  FILE *out = fopen(path, "a");
  if (!out) {
    fprintf(stderr, "cant open %s for append: %s\n", path, strerror(errno));
    fclose(in);
    return 1;
  }

  setvbuf(out, NULL, _IONBF, 0);

  char line[128];
  long processed = 0;

  while (processed < initial_lines && fgets(line, sizeof(line), in)) {
    long value = strtol(line, NULL, 10);
    long doubled = value * 2L;
    fprintf(out, "%ld\n", doubled);
    ++processed;
  }

  fflush(out);
  fsync(fileno(out));

  fclose(out);
  fclose(in);

  printf("file=%s processed=%ld\n", path, processed);
  return 0;
}
