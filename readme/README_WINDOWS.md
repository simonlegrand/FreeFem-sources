<!----------------------------------------------------------------------------------->
<!--- This file is part of FreeFEM.                                               --->
<!--- Laboratoire Jacques-Louis Lions                                             --->
<!--- Sorbonne Université, UMR 7598, Paris, F-75005 France                        --->
<!---                                                                             --->
<!--- FreeFEM is free software: you can redistribute it and/or modify             --->
<!--- it under the terms of the GNU Lesser General Public License as published by --->
<!--- the Free Software Foundation, either version 3 of the License, or           --->
<!--- (at your option) any later version.                                         --->
<!---                                                                             --->
<!--- FreeFEM is distributed in the hope that it will be useful,                  --->
<!--- but WITHOUT ANY WARRANTY; without even the implied warranty of              --->
<!--- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               --->
<!--- GNU Lesser General Public License for more details.                         --->
<!---                                                                             --->
<!--- You should have received a copy of the GNU Lesser General Public License    --->
<!--- along with FreeFEM.  If not, see <http://www.gnu.org/licenses/>.            --->
<!----------------------------------------------------------------------------------->

# How to compile FreeFem++ on Microsoft Windows

FreeFEM can be built on Windows using [MSYS2](https://www.msys2.org/). Use one MSYS2 environment consistently, do not mix packages from UCRT64, MINGW64, or CLANG64 environments

The environment-specific installation prefix is available as `MSYSTEM_PREFIX` in an MSYS2 shell. Build and packaging commands should use that prefix rather than assuming a path such as `/ucrt64`.

## Select an MSYS2 environment

Open the MSYS2 shell for the environment you intend to use. UCRT64 is the reference environment for the package examples below.

Other environments, like CLANG64, could work but have not been tested.

## Install build dependencies

Update MSYS2, then install the tools and libraries required for the build. For UCRT64, for example:

```bash
pacman -Syu
pacman -S --needed \
  mingw-w64-ucrt-x86_64-toolchain \
  mingw-w64-ucrt-x86_64-freeglut \
  mingw-w64-ucrt-x86_64-gcc-fortran \
  mingw-w64-ucrt-x86_64-autotools \
  mingw-w64-ucrt-x86_64-openblas \
  mingw-w64-ucrt-x86_64-msmpi \
  mingw-w64-ucrt-x86_64-cmake \
  mingw-w64-ucrt-x86_64-ntldd \
  m4 patch git flex bison unzip pkg-config pkgfile tar python
```
For another environment, install the corresponding packages from that environment’s MSYS2 repository. Package names and compiler availability may differ.
## To test the MPI usage: in windows terminal (cmd, shell, PowerShell)

Go to the directory `C:\Program Files (86)\FreeFem++\examples\mpi`

To lauch an example:
```bash
mpiexec.exe -np 4 FreeFem++-mpi DDM-Schwarz-Lame-2d.edp -wg
```
or without graphics:
```bash
mpiexec.exe -np 4 FreeFem++-mpi DDM-Schwarz-Lame-2d.edp
```

## To use MPI, you must first install `MSMPI`

Download [MS MPI V7](https://www.microsoft.com/en-us/download/details.aspx?id=49926 ),
and install both `msmpisdk.msi` and `MSMpiSetup.exe`.

Remark:

Under msys2 do not forger to do open `c:\msys64\mingw64.ini` in an editor
and remove `rem` before `set MSYS2_PATH_TYPE=inherit`
