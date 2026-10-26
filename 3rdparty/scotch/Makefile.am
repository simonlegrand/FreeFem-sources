############################################################################
# This file is part of FreeFEM.                                            #
#                                                                          #
# FreeFEM is free software: you can redistribute it and/or modify          #
# it under the terms of the GNU Lesser General Public License as           #
# published by the Free Software Foundation, either version 3 of           #
# the License, or (at your option) any later version.                      #
#                                                                          #
# FreeFEM is distributed in the hope that it will be useful,               #
# but WITHOUT ANY WARRANTY; without even the implied warranty of           #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
# GNU Lesser General Public License for more details.                      #
#                                                                          #
# You should have received a copy of the GNU Lesser General Public License #
# along with FreeFEM. If not, see <http://www.gnu.org/licenses/>.          #
############################################################################
# SUMMARY : Makefile for downloaded scotch
# LICENSE : LGPLv3
# ORG     : LJLL Universite Pierre et Marie Curie, Paris, FRANCE
# AUTHORS : ...
# E-MAIL  : ...

# Downloading and compiling scotch
# --------------------------------
# Scotch (https://gitlab.inria.fr/scotch/scotch) is built with its own
# CMake build system into static libraries copied to ../lib and headers
# copied to ../include/scotch.

# Package selection (set by configure)
# DOWNLOAD_SCOTCH : "install" when the downloaded library must be built
# SCOTCHLIB       : final library path (empty when using a system scotch)

# Package information
PKG_VERSION=7.0.17
DIRPKG=../pkg
PKG_SRCDIR=scotch-v$(PKG_VERSION)
PKG_TARBALL=$(DIRPKG)/scotch-v$(PKG_VERSION).tar.gz
PKG_BUILD=build
PKG_PREFIX=$(CURDIR)/prefix
CMAKE ?= cmake
CMAKE_GENERATOR=$(if $(WIN32DLLTARGET),-G "MSYS Makefiles")
# GCC >= 14 turns implicit function declarations into errors, and
# scotch's common_file_compress.c calls waitpid()/fork() which the
# mingw-w64 CRT neither declares nor provides (there is no sys/wait.h,
# those live in the MSYS2 layer only). These calls are unreachable here
# since the compression libraries are disabled (see USE_ZLIB/USE_BZ2/
# USE_LZMA=OFF below), so stub them out as scotch <= 6 used to do with
# -DCOMMON_STUB_FORK.
CMAKE_CC=$(if $(WIN32DLLTARGET),$(CC),$$(command -v $(CC)))
CFLAGSWIN=$(if $(WIN32DLLTARGET),-Wno-error=implicit-function-declaration -D'fork()=-1' -D'waitpid(a,b,c)=0')
#  trick to no in MPI on NOT ..
CCP=$(MPICC)
NOTESTMPI= test -z "$(CCP)"

PKGCOMMON_PACKTITLE=Scotch
PKGCOMMON_PACKAGES=$(PKG_TARBALL)
include ../common.mak

# Common package goals
all-local:$(DOWNLOAD_SCOTCH)
EXTRA_DIST=
compilepkg::$(SCOTCHLIB)
.NOTPARALLEL:

# Download and extract
$(PKG_SRCDIR):$(PKG_TARBALL)
	rm -rf $(PKG_SRCDIR)
	tar xzf $(PKG_TARBALL)
	touch $(PKG_SRCDIR)

# Configure (CMake)
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
$(PKG_BUILD)/configure.done:$(PKG_SRCDIR) Makefile
	mkdir -p $(PKG_BUILD)
	$(CMAKE) -S $(PKG_SRCDIR) -B $(PKG_BUILD) \
	 -DCMAKE_C_COMPILER="$(CMAKE_CC)" \
	 -DCMAKE_C_FLAGS="$(CFLAGS) $(CFLAGSWIN)" \
	 -DCMAKE_EXE_LINKER_FLAGS="$(LDFLAGS)" \
	 -DCMAKE_SHARED_LINKER_FLAGS="$(LDFLAGS)" \
	 -DCMAKE_BUILD_TYPE=Release \
	 -DCMAKE_INSTALL_PREFIX="$(PKG_PREFIX)" \
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
	touch $@

# Build and install (CMake)
$(PKG_BUILD)/install.done:$(PKG_BUILD)/configure.done
	$(CMAKE) --build $(PKG_BUILD) --parallel
	$(CMAKE) --install $(PKG_BUILD)
	touch $@

# Install into FreeFEM's 3rdparty tree
$(SCOTCHLIB):$(PKG_BUILD)/install.done
	mkdir -p ../include/scotch ../lib
	cp $(PKG_PREFIX)/include/*.h ../include/scotch/
	cp $(PKG_PREFIX)/lib/*.a ../lib/
	$(MAKE) WHERE
	$(NOTESTMPI) || $(MAKE) WHERE-mpi

# Package-specific targets
WHERE:
	-rm -f ../lib/WHERE.scotch
	echo scotch LD -L@DIR@/lib  -lesmumps -lscotch -lscotcherr >>../lib/WHERE.scotch
#	echo scotchmetis LD -L@DIR@/lib  -lscotchmetis >>../lib/WHERE.scotch
	echo scotch INCLUDE -I@DIR@/include/scotch >> ../lib/WHERE.scotch
WHERE-mpi:
	-rm -f ../lib/WHERE.scotch
	echo ptscotch LD -L@DIR@/lib  -lesmumps -lptscotch -lptscotcherr >>../lib/WHERE.scotch
#	echo ptscotchparmetis  LD -L@DIR@/lib  -lptscotchparmetis >>../lib/WHERE.scotch
	echo ptscotch INCLUDE -I@DIR@/include/scotch >> ../lib/WHERE.scotch
	echo scotch LD -L@DIR@/lib  -lesmumps -lscotch -lscotcherr >>../lib/WHERE.scotch
#	echo scotchmetis LD -L@DIR@/lib  -lscotchmetis >>../lib/WHERE.scotch
	echo scotch INCLUDE -I@DIR@/include/scotch >> ../lib/WHERE.scotch

# Clean
clean-local::
	-rm -rf $(PKG_SRCDIR) $(PKG_BUILD) $(PKG_PREFIX)
	-rm -rf ../include/scotch
	-rm -f ../lib/*scotch* ../lib/WHERE.scotch

.PHONY: WHERE WHERE-mpi

# Local Variables:
# mode:makefile
# ispell-local-dictionary:"british"
# coding:utf-8
# End:
