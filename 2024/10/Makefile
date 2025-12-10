CC=gcc
CFLAGS=-Wall -Wextra -O2 -std=c99
TARGET=run

all: $(TARGET)

$(TARGET): run.c
	$(CC) $(CFLAGS) -o $(TARGET) run.c

clean:
	rm -f $(TARGET)

test: $(TARGET)
	./$(TARGET) sample_input

.PHONY: all clean test
