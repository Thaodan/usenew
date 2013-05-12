include ../rules.mk

SCRIPTS 	= backup winix_app wine_misc base libuse binput
GIT_REV      	= $(shell ./../../tools/git_revgen)
all: $(SCRIPTS) 

$(SCRIPTS): ${SCRIPTS:=.in.sh} ../config.shh
	$(SHPP) -Dgit_rev=$(GIT_REV) -Dprefix=$(PREFIX) $(@).in.sh -o $(@)


../config.shh:
	$(MAKE) -C .. config.shh

install: $(SCRIPTS)	
	$(INSTALL) -dm755 $(libdir)/libuse
	$(INSTALL) -Dm644 $(^) $(libdir)/libuse
clean: 
	rm -f $(SCRIPTS)

.PHONY: all clean install

