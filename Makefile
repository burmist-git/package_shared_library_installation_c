RELVERSION  = $(shell cat .release)

CXX  = g++
CXX += -I./

CXXFLAGS  = -g -Wall -fPIC -Wno-deprecated

MakefileFullPath = $(abspath $(lastword $(MAKEFILE_LIST)))
MakefileDirFullPath = $(shell dirname $(MakefileFullPath))
OUTLIB = $(MakefileDirFullPath)/obj/
INSTALLDIR = $(MakefileDirFullPath)/install.$(RELVERSION)/
INSTALLDIR_USR = ./install_user/
INSTALLDIR_USR_BIN = $(INSTALLDIR_USR)/bin/
INSTALLDIR_USR_LIB = $(INSTALLDIR_USR)/lib/
INSTALLDIR_USR_INC = $(INSTALLDIR_USR)/include/
INSTALLDIR_USR_ECT = $(INSTALLDIR_USR)/ect/

CXX += -I$(INSTALLDIR)
CXX += -I$(INSTALLDIR_USR_INC)
CXX += -L$(INSTALLDIR)
CXX += -L$(INSTALLDIR_USR)/lib/

.PHONY: all makedir clean printmakeinfo

#----------------------------------------------------#

all: makedir test

makedir:
	mkdir -p $(OUTLIB);

printmakeinfo:
	$(info CXX                  = "$(CXX)")
	$(info CXXFLAGS             = "$(CXXFLAGS)")
	$(info MakefileFullPath     = "$(MakefileFullPath)")
	$(info MakefileDirFullPath  = "$(MakefileDirFullPath)")
	$(info OUTLIB               = "$(OUTLIB)")
	$(info INSTALLDIR           = "$(INSTALLDIR)")
	$(info INSTALLDIR_USR_BIN   = "$(INSTALLDIR_USR_BIN)")
	$(info INSTALLDIR_USR_LIB   = "$(INSTALLDIR_USR_LIB)")
	$(info INSTALLDIR_USR_INC   = "$(INSTALLDIR_USR_INC)")
	$(info INSTALLDIR_USR_ECT   = "$(INSTALLDIR_USR_ECT)")
	$(info RELVERSION           = "$(RELVERSION)")

test: test.cc obj/libtempl.so
	$(CXX) -o $@ $< $(OUTLIB)*.so $(CXXFLAGS)

obj/%.o: %.cc libtempl.h
	$(CXX) $(CXXFLAGS) -c -I. -o $@ $<

obj/libtempl.so: obj/templ.o
	$(CXX) -shared -o $@ $^

install: makedir obj/libtempl.so
	mkdir -p $(INSTALLDIR);
	mkdir -p $(INSTALLDIR_USR);
	mkdir -p $(INSTALLDIR_USR_BIN);
	mkdir -p $(INSTALLDIR_USR_LIB);
	mkdir -p $(INSTALLDIR_USR_INC);
	mkdir -p $(INSTALLDIR_USR_ECT);
	cp $(OUTLIB)libtempl.so $(INSTALLDIR)libtempl.so
	cp $(MakefileDirFullPath)/libtempl.h $(INSTALLDIR)libtempl.h
	ln -s $(INSTALLDIR)libtempl.so $(INSTALLDIR_USR_LIB)libtempl.so
	ln -s $(INSTALLDIR)libtempl.h $(INSTALLDIR_USR_INC)libtempl.h

cleaninstall:
	rm -rf $(INSTALLDIR)
	rm -rf $(INSTALLDIR_USR_LIB)libtempl.so
	rm -rf $(INSTALLDIR_USR_INC)libtempl.h

clean:
	rm -f *~
	rm -f .*~
	rm -f test
	rm -rf obj
	rm -f $(OUTLIB)*
