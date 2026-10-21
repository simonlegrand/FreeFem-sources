# ======================================================================
# Laboratoire Jacques-Louis Lions
# Université Pierre et Marie Curie-Paris6, UMR 7598, Paris, F-75005 France
# http://www.ljll.math.upmc.fr/lehyaric
# ======================================================================
# This file is part of Freefem++
# 
# Freefem++ is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of
# the License, or (at your option) any later version.
# 
# Freefem++ is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with Freefem++; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
# ======================================================================
# headeralh default=0 freefem make multipleauthors start=19/03/10 upmc

# Downloading and compiling extra libraries
# -----------------------------------------

include Makefile.inc

all-local: scotch

# Downloading and compiling scotch
# -------------------------------
# Scotch information
# https://gitlab.inria.fr/scotch/scotch
DIRPKG=../pkg
SRCDIR=scotch-v$(scotch_VERSION)
PACKAGE=$(DIRPKG)/scotch-v$(scotch_VERSION_LOCAL).tar.gz
INSTALL=..
BUILD=build
PREFIX=$(CURDIR)/$(BUILD)/install-root
CMAKE ?= cmake
scotch_VERSION=7.0.17
scotch_VERSION_LOCAL=7.0.17
#  trick to no in MPI on NOT .. 
NOTESTMPI= test -z "$(CCP)"
scotch: FAIRE

# On Windows (MinGW/MSYS2) the generator must be given explicitely,
# cf. 3rdparty/mmg and 3rdparty/parmmg which do the same.
ifeq ($(WIN32DLLTARGET),)
CMAKE_GENERATOR :=
CFLAGSWIN :=
CMAKE_CC := $$(command -v $(CC))
else
CMAKE_GENERATOR := -G "MSYS Makefiles"
CMAKE_CC := $(CC)
# GCC >= 14 turns implicit function declarations into errors, and
# scotch's common_file_compress.c calls waitpid()/fork() which the
# mingw-w64 CRT neither declares nor provides (there is no sys/wait.h,
# those live in the MSYS2 layer only). These calls are unreachable here
# since the compression libraries are disabled (see USE_ZLIB/USE_BZ2/
# USE_LZMA=OFF below), so stub them out as scotch <= 6 used to do with
# -DCOMMON_STUB_FORK.
CFLAGSWIN := -Wno-error=implicit-function-declaration -D'fork()=-1' -D'waitpid(a,b,c)=0'
endif

FAIRE: install
	$(MAKE) WHERE
	$(NOTESTMPI) || $(MAKE) WHERE-mpi
	touch FAIRE

Makefile.inc: ../../config.status Makefile-scotch.inc Makefile
	../../config.status  --file="Makefile.inc:Makefile-scotch.inc"

# Compile scotch/ptscotch (and esmumps/ptesmumps) with the CMakeLists.txt
# of scotch instead of its own Makefiles, which gives macOS/Windows/Linux
# support (COMMON_OS_MACOS / COMMON_OS_WINDOWS flags are set by scotch).
#  - INTSIZE/IDXSIZE 32 preserve the historical -DINTSIZE32 -DIDXSIZE32,
#    Shouldn't we use 64 instead now?
#  - POSITION_INDEPENDENT_CODE is required to link the static libraries
#    into the scotch plugin (a shared object) on Linux,
#  - THREADS=OFF avoids -DSCOTCH_PTHREAD which breaks SUPERLU_DIST when
#    the program is not launched with MPI_THREAD_MULTIPLE (FH, Sep 2016),
#    it could be tested again.
#  - the compression libraries are disabled to keep the link lines of the
#    consumers (mumps, mmg, parmmg, ...) free of -lz -lbz2 -llzma,
#  - the scotchmetis library, the fortran bindings and the test suite are
#    not used by FreeFEM (scotchf.h is still generated and installed,
#    it does not need a fortran compiler).
#    Could scotchmetis replace metis? What about ptscotchparmetis?
# If bison/flex are missing or too old, the fallback parser files shipped
# in scotch (src/libscotch/last_resort) are used.
$(SRCDIR)/FAIT: $(SRCDIR) Makefile.inc Makefile
	cp Makefile.inc $(SRCDIR)/src
	mkdir -p $(BUILD)
	$(CMAKE) -S $(SRCDIR) -B $(BUILD) \
	 -DCMAKE_C_COMPILER="$(CMAKE_CC)" \
	 -DCMAKE_C_FLAGS="$(CFLAGS) $(CFLAGSWIN)" \
	 -DCMAKE_EXE_LINKER_FLAGS="$(LDFLAGS)" \
	 -DCMAKE_SHARED_LINKER_FLAGS="$(LDFLAGS)" \
	 -DCMAKE_BUILD_TYPE=Release \
	 -DCMAKE_INSTALL_PREFIX="$(PREFIX)" \
	 -DCMAKE_INSTALL_LIBDIR=lib \
	 -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	 -DINTSIZE=32 -DIDXSIZE=32 \
	 -DBUILD_FORTRAN=OFF \
	 -DBUILD_LIBESMUMPS=ON \
	 -DBUILD_LIBSCOTCHMETIS=OFF \
	 -DBUILD_PTSCOTCH=$(if $(CCP),ON,OFF) \
	 -DENABLE_TESTS=OFF \
	 -DTHREADS=OFF \
	 -DUSE_BZ2=OFF -DUSE_LZMA=OFF -DUSE_ZLIB=OFF \
	 $(if $(CCP),-DMPI_C_COMPILER="$(CCP)") \
	 $(CMAKE_GENERATOR)
	$(CMAKE) --build $(BUILD) --parallel
	$(CMAKE) --install $(BUILD)
	touch $(SRCDIR)/FAIT
# 	 -DCMAKE_AR="$$(command -v $(AR))" \
#	 -DCMAKE_RANLIB="$$(command -v $(RANLIB))" \

install:$(SRCDIR)/FAIT
	mkdir -p $(INSTALL)/include/scotch
	mkdir -p $(INSTALL)/lib
	cp $(BUILD)/install-root/include/*.h $(INSTALL)/include/scotch/
	cp $(BUILD)/install-root/lib/*.a $(INSTALL)/lib/
# ptscotch is built by the same CMake invocation, keep the historical
# target name for the callers (3rdparty/Makefile)
install-mpi:install

# ALH - 16/1/13 - simplifying make rules
WHERE:install
	-rm -f $(INSTALL)/lib/WHERE.scotch
	echo scotch LD -L@DIR@/lib  -lesmumps -lscotch -lscotcherr >>$(INSTALL)/lib/WHERE.scotch
#	echo scotchmetis LD -L@DIR@/lib  -lscotchmetis >>$(INSTALL)/lib/WHERE.scotch
	echo scotch INCLUDE -I@DIR@/include/scotch >> $(INSTALL)/lib/WHERE.scotch
WHERE-mpi:install-mpi
	-rm -f $(INSTALL)/lib/WHERE.scotch
	echo ptscotch LD -L@DIR@/lib  -lesmumps -lptscotch -lptscotcherr >>$(INSTALL)/lib/WHERE.scotch
#	echo ptscotchparmetis  LD -L@DIR@/lib  -lptscotchparmetis >>$(INSTALL)/lib/WHERE.scotch
	echo ptscotch INCLUDE -I@DIR@/include/scotch >> $(INSTALL)/lib/WHERE.scotch
	echo scotch LD -L@DIR@/lib  -lesmumps -lscotch -lscotcherr >>$(INSTALL)/lib/WHERE.scotch
#	echo scotchmetis LD -L@DIR@/lib  -lscotchmetis >>$(INSTALL)/lib/WHERE.scotch
	echo scotch INCLUDE -I@DIR@/include/scotch >> $(INSTALL)/lib/WHERE.scotch

$(SRCDIR): $(PACKAGE)
	tar xzf $(PACKAGE)
	touch $(SRCDIR)

$(PACKAGE):
	../getall -o Scotch -a

# FFCS - 28/3/13 - more cleaning
clean-local:
	-rm -rf $(BUILD)
	-rm config.log
	-rm -rf ../include/scotch/
	-rm -rf ../lib/*scotch*

clean: clean-local
	-rm Makefile.inc
	-rm -rf $(SRCDIR)
	-rm FAIRE 
.PHONY:$(SRCDIR)/$(INSTALL)

# Local Variables:
# mode:makefile
# ispell-local-dictionary:"british"
# coding:utf-8
# End:
