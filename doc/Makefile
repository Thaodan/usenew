include ../rules.mk
EMACS 			= emacs
EMACS_EXPORT_SCRIPT 	= ../tools/emacs_jorg.el
EMACS_ARGS		= --batch --script $(EMACS_EXPORT_SCRIPT)  \
	--visit=$^ --funcall org-man-export-to-man
ORG_FILES		= usenew.org\
			  libuse.org

all: $(ORG_FILES:.org=.1)

libuse.org: libuse.in.org
	sed "s|@libdir@|$(libdir)|" $< > $@

%.1: %.org
	$(EMACS) $(EMACS_ARGS)
	mv ${@:1=man} $(@:man=1)

install: $(ORG_FILES:.org=.1)
	$(INSTALL) -dm755  $(mandir)/man1
	$(INSTALL) -m644 $(^) $(mandir)/man1

clean:
	rm -f $(ORG_FILES:.org=.1)

.PHONY: clean install
