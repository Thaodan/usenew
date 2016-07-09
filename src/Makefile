include ../rules.mk
# app config
APPNAME			= usenew
USE_VER	     	 	= $(shell ./../tools/git_revgen)
USE_SHELL		= sh
WSYSTEMRC		= 0
SYSTEMRC		= /etc/$(APPNAME)rc
WUSERRC			= 0
USERRC			= '$$\{XDG_CONFIG_HOME:-\$$HOME/.config\}'
SCRIPTS			= usenew\
	 		  restore


all: $(SCRIPTS) libuse

$(SCRIPTS): ${SCRIPTS:=.in.sh} config.shh
	$(SHPP) $(SHPPFLAGS) $(@).in.sh  -o $@

config.shh: 
	@echo $@: generating 
	@echo '#\\define use_ver=$(USE_VER)' > $@
	@echo '#\\define prefix=$(PREFIX)' >> $@
	@echo '#\\define SHELL=${USE_SHELL}' >> $@
ifneq ($(WSYSTEMRC),0)
	@echo '#\\\\define SYSTEMRC$(SYSTEMRC)' >> $@
endif
ifneq ($(WUSERRC),0)
	@echo '#\\define USERRC=$(USERRC)' >> $@
endif

usenew_static: usenew.in.sh libuse/base.in.sh libuse/wine_misc.in.sh config.shh
	$(SHPP) $(SHPPFLAGS) -DSTATIC -I./libuse $(<) -o $(@) 

libuse: 
	$(MAKE) -C libuse

install: install_bin usenew_comp.zsh
	$(INSTALL) -m644 usenew_comp.zsh $(zsh_compdir)/_usenew
install_bin: $(SCRIPTS)
	$(INSTALL) -dm755 $(bindir)
	$(INSTALL) -m755 $(^) $(bindir) 
	$(MAKE) -C libuse install
clean:
	rm -f $(SCRIPTS)
	rm -f config.shh
	$(MAKE) -C libuse clean
.PHONY: all clean libuse install
