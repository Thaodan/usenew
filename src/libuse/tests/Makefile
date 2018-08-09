include ../../../rules.mk

SCRIPTS 	= backup_test \
			restore_backup_test
SUB_SCRIPTS	= test_env_env \
			backup_test_base

TEST_ENV 	= $(PWD)/test_env.d
SHELL_OPTS 	=
PREFIX		:= $(TEST_ENV)
 #FIXME?
LIBUSE_VER	= $(GITREVGEN)
INSPECT         =

all: $(SCRIPTS)

$(SUB_SCRIPTS): ${SUB_SCRIPTS:=.in.sh}
	$(SHPP) $(SHPPFLAGS) -DLIBUSE_VER=$(LIBUSE_VER) \
			-Dlibdir=$(libdir) \
			-Dlibsh_libdir=/usr/lib \
			$(@).in.sh -o $(@)

$(SCRIPTS): ${SCRIPTS:=.in.sh} $(SUB_SCRIPTS) test_env
	$(SHPP) $(SHPPFLAGS)  $(@).in.sh -o $(@)
	$(SHELL) $(SHELL_OPTS) $@

test_env:
	make -C .. install PREFIX=$(PREFIX)


clean: 
	rm -f $(SCRIPTS)

.PHONY: all clean test_env

