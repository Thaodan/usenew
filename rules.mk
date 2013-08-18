DIST_ROOT     = $(dir $(lastword $(MAKEFILE_LIST)))
TOOLSDIR      = ${DIST_ROOT}tools

DESTDIR       =
PREFIX        = /usr/local
INSTALL       = /usr/bin/install -D
MSGFMT        = /usr/bin/msgfmt
SED           = /bin/sed
bindir        = $(PREFIX)/bin
libdir        = $(PREFIX)/lib
sysconfdir    = $(PREFIX)/etc
datarootdir   = ${PREFIX}/share
datadir       = ${datarootdir}
mandir        = ${datarootdir}/man

SHPP	      = shpp
BUILTIN_SHPP  = ${TOOLSDIR}/shpp
WBUILTIN_SHPP = 0

ifneq ($(WBUILTIN_SHPP),0)
SHPP          = $(BUILTIN_SHPP)
endif
