include ../rules.mk
EMACS 			= emacs
EMACS_EXPORT_SCRIPT 	= ../tools/emacs_jorg.el
EMACS_ARGS		= --batch --script $(EMACS_EXPORT_SCRIPT)  \
	--visit=$@ --funcall org-man-export-to-man
ORG_FILES		= usenew.org\
			  libuse.org

all: $(ORG_FILES:.org=.1)
#libuse.org: libuse.in.org
#	sed "s|@libdir@|$(libdir)|" $< > $@
#$(ORG_FILES:.org=.1): $(ORG_FILES)
#	$(EMACS) $(EMACS_ARGS)
#	mv $(@:.1=.man) $(@:.org=.1)


install: $(ORG_FILES:.org=.1)
	$(INSTALL) -dm755  $(mandir)/man1
	$(INSTALL) -m755 $(^) $(mandir)/man1

clean: $(ORG_FILES:.org=.1)
	rm -f $(^)

.PHONY: clean install
