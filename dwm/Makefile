# NilWM - OXWM-compatible window manager based on DWM
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c dwm.c util.c
OBJ = ${SRC:.c=.o}

all: nilwm

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

nilwm: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f nilwm ${OBJ}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f nilwm ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/nilwm

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/nilwm

.PHONY: all clean install uninstall
