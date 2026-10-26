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
# SUMMARY : Makefile for downloaded fftw
# LICENSE : LGPLv3
# ORG     : LJLL Universite Pierre et Marie Curie, Paris, FRANCE
# AUTHORS : ...
# E-MAIL  : ...

# Downloading and compiling fftw
# ------------------------------
# FFTW (http://www.fftw.org) is built with its own autotools build system.
# Only the double-precision static library and the public headers are copied
# into ../lib and ../include, where the rest of the build expects them (see
# ../lib/WHERE.fftw3).

# Package selection (set by configure)
# DOWNLOAD_FFTW : "install" when the downloaded library must be built
# FFTWLIB       : final library path (empty when using a system fftw)

# Package information
PKG_VERSION=3.3.11
DIRPKG=../pkg
PKG_SRCDIR=fftw-$(PKG_VERSION)
PKG_TARBALL=$(DIRPKG)/fftw-$(PKG_VERSION).tar.gz
PKG_BUILD=build
PKG_PREFIX=$(CURDIR)/prefix

PKGCOMMON_PACKTITLE=FFTW
PKGCOMMON_PACKAGES=$(PKG_TARBALL)
include ../common.mak

# Common package goals
all-local:$(DOWNLOAD_FFTW)
EXTRA_DIST=
compilepkg::$(FFTWLIB)
.NOTPARALLEL:

# Download and extract
$(PKG_SRCDIR):$(PKG_TARBALL)
	rm -rf $(PKG_SRCDIR)
	tar xzf $(PKG_TARBALL)
	touch $(PKG_SRCDIR)

# Configure (autotools)
# --with-pic is required to link the static library into the dfft plugin (a
# shared object), and --disable-shared keeps the installation limited to the
# static archive used by FreeFEM. Documentation is not needed.
$(PKG_BUILD)/configure.done:$(PKG_SRCDIR) Makefile
	mkdir -p $(PKG_BUILD)
	cd $(PKG_BUILD) && ../$(PKG_SRCDIR)/configure \
	 --disable-dependency-tracking \
	 --disable-doc \
	 --disable-fortran \
	 --disable-shared \
	 --enable-static \
	 --with-pic \
	 --prefix="$(PKG_PREFIX)" \
	 CC="$(CC)" \
	 CXX="$(CXX)" \
	 CFLAGS="$(CFLAGS)" \
	 CXXFLAGS="$(CXXFLAGS)"
	touch $@

# Build and install (autotools)
$(PKG_BUILD)/install.done:$(PKG_BUILD)/configure.done
	$(MAKE) -C $(PKG_BUILD)
	$(MAKE) -C $(PKG_BUILD) install
	touch $@

# Install into FreeFEM's 3rdparty tree
$(FFTWLIB):$(PKG_BUILD)/install.done
	mkdir -p ../include ../lib
	cp $(PKG_PREFIX)/include/* ../include/
	cp $(PKG_PREFIX)/lib/libfftw3.a $(FFTWLIB)
	$(MAKE) WHERE

# Package-specific targets
WHERE:$(PKG_BUILD)/install.done
	-rm -f ../lib/WHERE.fftw3
	echo fftw3 LD -L@DIR@/lib -lfftw3 >../lib/WHERE.fftw3
	echo fftw3 INCLUDE -I@DIR@/include >>../lib/WHERE.fftw3

# Clean
clean-local::
	-rm -rf $(PKG_SRCDIR) $(PKG_BUILD) $(PKG_PREFIX)
	-rm -f ../include/fftw3.h ../include/fftw3.f ../include/fftw3.f03 \
		../include/fftw3l.f03 ../include/fftw3q.f03
	-rm -f ../lib/libfftw3.a ../lib/libfftw3.la ../lib/WHERE.fftw3

.PHONY: WHERE

# Local Variables:
# mode:makefile
# ispell-local-dictionary:"british"
# coding:utf-8
# End:
