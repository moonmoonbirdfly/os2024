#ifndef BOOT_H
#define BOOT_H

void waitDisk(void);

void readSect(void *dst, int offset);

/* I/O functions */
static inline char inByte(short port) { //usage: r[d]-->r[a] byte
	char data;
	asm volatile("in %1,%0" : "=a" (data) : "d" (port)); //output -only as output: input
	return data;
}

static inline int inLong(short port) { //usage: r[d]-->r[a] long=32b
	int data;
	asm volatile("in %1, %0" : "=a" (data) : "d" (port));
	return data;
}

static inline void outByte(short port, char data) { //usage r[a]-->r[d]  data is written into port
	asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

#endif
