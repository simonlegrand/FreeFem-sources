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
# SUMMARY : Makefile for downloaded arpack-ng
# LICENSE : LGPLv3
# ORG     : LJLL Universite Pierre et Marie Curie, Paris, FRANCE
# AUTHORS : ...
# E-MAIL  : ...

all-local:$(DOWNLOAD_ARPACK)
EXTRA_DIST=

PKGCOMMON_PACKTITLE=ARPACK
include ../common.mak

# nothing specific to do for [[file:../common.mak::reinstall]]

reinstall::install

# Downloading and compiling arpack-ng
# -----------------------------------
# arpack-ng (https://github.com/opencollab/arpack-ng) is the maintained
# fork of the original 1996 ARPACK. It keeps the same F77 interface, so
# src/Eigen/arpackff.hpp works unchanged. The library is built with its
# own CMake build system (as done for mmg) into a static libarpack.a
# copied to ../lib, where configure.ac expects it (ARPACKLIB).

.NOTPARALLEL:

# set in configure
#ARPACKLIB=ARPACK/libarpack_ff++.a
DIRPKG=../pkg
ARPACKNG_TAR_GZ=$(DIRPKG)/arpack-ng-3.9.1.tar.gz

PKGCOMMON_PACKAGES=$(ARPACKNG_TAR_GZ)

compilepkg::$(ARPACKLIB)

$(ARPACKLIB):ARPACK/install.done
	mkdir -p ../lib
	cp prefix/lib/libarpack.a $(ARPACKLIB)

ARPACK/install.done:ARPACK/configure.done
	cd ARPACK/build && $(MAKE)
	cd ARPACK/build && $(MAKE) install
	touch $@

# BLAS/LAPACK come from FreeFEM's configure (@BLASLIBS@/@LAPACKLIBS@);
# pass them explicitly so CMake's FindBLAS/FindLAPACK cannot pick
# different ones than the rest of the build.

ARPACK/configure.done:$(ARPACKNG_TAR_GZ)
	rm -rf ARPACK
	mkdir -p ARPACK
	cd ARPACK && tar xzf ../$(ARPACKNG_TAR_GZ) --strip-components=1
	mkdir -p ARPACK/build
	set -- ; \
	if test -n '$(WIN32DLLTARGET)' ; then set -- -G "MSYS Makefiles" ; fi ; \
	prefix="`cd ARPACK; pwd`/../prefix"; \
	cd ARPACK/build && cmake .. \
	 -DCMAKE_Fortran_COMPILER='$(F77)' \
	 -DCMAKE_Fortran_FLAGS='$(FFLAGS)' \
	 -DCMAKE_C_COMPILER='$(CC)' \
	 -DCMAKE_C_FLAGS='$(CFLAGS)' \
	 -DCMAKE_INSTALL_PREFIX="$$prefix" \
	 -DCMAKE_INSTALL_LIBDIR=lib \
	 -DCMAKE_POSITION_INDEPENDENT_CODE=ON \
	 -DBUILD_SHARED_LIBS=OFF \
	 -DTESTS=OFF \
	 -DEXAMPLES=OFF \
	 -DICB=OFF \
	 -DMPI=OFF \
	 -DBLAS_LIBRARIES='$(BLASLIBS)' \
	 -DLAPACK_LIBRARIES='$(LAPACKLIBS)' \
	 "$$@"
	touch $@

$(ARPACKNG_TAR_GZ):download
#	../getall -o ARPACK -a

clean-local::
	-rm -rf ARPACK prefix
	-rm -f ../lib/libarpack.a

# Local Variables:
# mode:makefile
# ispell-local-dictionary:"british"
# coding:utf-8
# End:
