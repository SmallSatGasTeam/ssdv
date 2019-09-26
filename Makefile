CC=/usr/bin/afl-gcc
LD=/usr/bin/afl-gcc
CFLAGS=-O3
#LDFLAGS=-fsanitize=address

all: ssdv

ssdv: main.o ssdv.o rs8.o ssdv.h rs8.h
	$(CC) $(LDFLAGS) main.o ssdv.o rs8.o -o ssdv

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

install: all
	mkdir -p ${DESTDIR}/usr/bin
	install -m 755 ssdv ${DESTDIR}/usr/bin

clean:
	rm -f *.o ssdv

fuzz: all
	afl-fuzz -i test_cases/ -o findings/ -- ./ssdv -e @@
