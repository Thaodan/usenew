include ../../../rules.mk

SCRIPTS 	= backup_test
TEST_ENV 	= $(PWD)/test_env.d
SHELL_OPTS 	=
PREFIX		:= $(TEST_ENV)
 #FIXME?
LIBUSE_VER	= $(GITREVGEN)
INSPECT         =

all: $(SCRIPTS)

test_env_env: test_env_env.in.sh
	$(SHPP) $(SHPPFLAGS) -Dlibsh_libdir=/usr/lib $(@).in.sh -o $(@)

$(SCRIPTS): ${SCRIPTS:=.in.sh} test_env_env test_env
	$(SHPP) $(SHPPFLAGS) -DLIBUSE_VER=$(LIBUSE_VER) -Dlibdir=$(libdir) $(@).in.sh -o $(@)
	$(SHELL) $(SHELL_OPTS) $@

test_env:
	make -C .. install PREFIX=$(PREFIX)


clean: 
	rm -f $(SCRIPTS)

.PHONY: all clean test_env

