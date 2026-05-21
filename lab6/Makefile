CC=gcc
CFLAGS=-O0 -Wall -Wextra -std=c11
LDFLAGS=-lm

BIN_DIR=bin
SRC_DIR=src

all: $(BIN_DIR)/cpu_task $(BIN_DIR)/io_task

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BIN_DIR)/cpu_task: $(SRC_DIR)/cpu_task.c | $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)

$(BIN_DIR)/io_task: $(SRC_DIR)/io_task.c | $(BIN_DIR)
	$(CC) $(CFLAGS) -o $@ $<

clean:
	rm -rf $(BIN_DIR) plots/*.png results/*.csv results/*.txt work/*.txt

.PHONY: all clean
