#!/bin/sh
# Run this to generate all the initial makefiles, etc.

PROJECT=gtk-doc
TEST_TYPE=-f
FILE=gtk-doc.dsl.in

DIE=0

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

THEDIR="`pwd`"

cd "$srcdir"

(autoconf --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have autoconf installed to compile $PROJECT."
	echo "Download the appropriate package for your distribution,"
	echo "or get the source tarball at ftp://ftp.gnu.org/pub/gnu/"
	DIE=1
}

(libtool --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have libtool installed to compile $PROJECT."
	echo "Get ftp://alpha.gnu.org/gnu/libtool-1.2b.tar.gz"
	echo "(or a newer version if it is available)"
	DIE=1
}

(automake-1.4 --version) < /dev/null > /dev/null 2>&1 || {
	echo
	echo "You must have automake installed to compile $PROJECT."
	echo "Get ftp://ftp.cygnus.com/pub/home/tromey/automake-1.2d.tar.gz"
	echo "(or a newer version if it is available)"
	DIE=1
}

if test "$DIE" -eq 1; then
	exit 1
fi

test $TEST_TYPE $FILE || {
	echo "You must run this script in the top-level $PROJECT directory"
	exit 1
}

if test -z "$*"; then
	echo "I am going to run ./configure with no arguments - if you wish "
        echo "to pass any to it, please specify them on the $0 command line."
fi

case $CC in
*xlc | *xlc\ * | *lcc | *lcc\ *) am_opt=--include-deps;;
esac

aclocal-1.4 $ACLOCAL_FLAGS

# optionally feature autoheader
#(autoheader --version)  < /dev/null > /dev/null 2>&1 && autoheader

automake-1.4 --add-missing $am_opt
autoconf

cd "$THEDIR"

$srcdir/configure "$@"

echo 
echo "Now type 'make install' to install $PROJECT."



