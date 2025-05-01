#include <config.h>
#include "strversionnumber.hpp"
#include <sstream>
using namespace std;

#define xstrg(s) strg(s)
#define strg(s) #s

double VersionNumber() {
  return VersionFreeFem;
}

string StrVersionNumber() {
  ostringstream version;
  version.precision(8);
  version << xstrg(VersionFreeFem)
          << " (Mar Tue 25 - 15:12:10 - 2025 - git v4.15-testActions-172-g7d51cd82d)";
  return version.str();
}
