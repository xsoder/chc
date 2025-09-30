CC      ?= gcc
CFLAGS  := -Wall -Wextra

SRC     := chc.c
OBJ     := $(SRC:.c=.o)
NOB     := nob.h
BIN     := chc

DESTDIR ?= /usr
PREFIX  ?= local

.phony: all clean install uninstall

all: $(BIN)

.c.o:
	$(CC) $(CFLAGS) -c $<

$(BIN): $(OBJ)
	$(CC) $(CFLAGS) -o $@ $(OBJ)

clean:
	rm -f $(BIN) $(OBJ)

install: all
	mkdir -p $(DESTDIR)/$(PREFIX)/include
	mkdir -p $(DESTDIR)/$(PREFIX)/bin

	cp -f $(BIN) $(DESTDIR)/$(PREFIX)/bin;
	cp -f $(NOB) $(DESTDIR)/$(PREFIX)/include

	chmod 755 $(DESTDIR)/$(PREFIX)/bin/$(BIN)

uninstall:
	rm -f $(DESTDIR)/$(PREFIX)/bin/$(BIN)
	rm -f $(DESTDIR)/$(PREFIX)/include/$(NOB)
