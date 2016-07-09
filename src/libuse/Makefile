include ../../rules.mk

SCRIPTS 	= backup winix_app wine_misc base libuse binput
LIBUSE_VER	= $(GITREVGEN)
all: $(SCRIPTS) 

$(SCRIPTS): ${SCRIPTS:=.in.sh} ../config.shh
	$(SHPP) $(SHPPFLAGS) -DLIBUSE_VER=$(LIBUSE_VER) $(@).in.sh -o $(@)


../config.shh:
	$(MAKE) -C .. config.shh

install: $(SCRIPTS)	
	$(INSTALL) -dm755 $(libdir)/libuse
	$(INSTALL) -Dm644 $(^) $(libdir)/libuse
clean: 
	rm -f $(SCRIPTS)

.PHONY: all clean install

