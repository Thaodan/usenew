include rules.mk
# app config
APPNAME			= usenew
USE_VER	     	 	= 3.2
USE_SHELL		= sh
WSYSTEMRC		= 0
SYSTEMRC		= /etc/$(APPNAME)rc
WUSERRC			= 0
USERRC			= "$\{XDG_CONFIG_HOME\:-$HOME/.config}"
SCRIPTS			= usenew\
	 		  restore

all: $(SCRIPTS) 

$(SCRIPTS): ${SCRIPTS:=.in.sh} config.shh
	$(SHPP) $(@).in.sh  -o $@

config.shh: 
	@echo $@: generating 
	@echo '#\\define use_ver=$(USE_VER)' > $@
	@echo '#\\define prefix=$(PREFIX)' >> $@
	@echo '#\\define git_rev=$(shell ./../tools/git_revgen)' >> $@
	@echo '#\\define SHELL=${USE_SHELL}' >> $@
ifneq ($(WSYSTEMRC),0)
	@echo '#\\\\define SYSTEMRC$(SYSTEMRC)' >> $@
endif
ifneq ($(WUSERRC),0)
	@echo '#\\define USERRC=$(USERRC)' >> $@
endif

clean:
	rm -f $(SCRIPTS)
	rm -f config.shh

.PHONY: all clean
