#include <config.h>
#include "strversionnumber.hpp"
#include <sstream>
using namespace std

#define xstrg(s) strg(s)
#define strg(s) #s

double VersionNumber() {
  return VersionFreeFem
}

string StrVersionNumber() {
  ostringstream version
  version.precision(8)
  version << xstrg(VersionFreeFem)
          << " (Tue Feb 25 06:07:48 PM CET 2025 - git v4.15-testActions-164-g103dddd98)"
  return version.str()
}
