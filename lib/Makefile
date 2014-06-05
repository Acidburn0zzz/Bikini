# Copyright (C) 2014 Heather

CC=g++

CFLAGS=-O3 -Wall -std=c++1y
CSRC=./Tests/Eternal.cpp
INCLUDES = -I .

all:  test | run

windows: test-win | run-win

test:	$(CSRC)
	$(CC) ${INCLUDES} -o test $^ ${CFLAGS}
    
test-win:	$(CSRC)
	$(CC) ${INCLUDES} -o test.exe $^ ${CFLAGS}

.PHONY: all test test-win

run:
	./test
    
run-win:
	./test.exe