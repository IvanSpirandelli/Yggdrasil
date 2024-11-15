# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder, Pkg

name = "libtakum"
version = v"0.5.1"

# Collection of sources required to complete build
sources = [
    GitSource("https://github.com/takum-arithmetic/libtakum.git", "e7f9abe94bfa865711af17a0dbb6a0e5bf5a915e")
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libtakum
./configure
make PREFIX=${prefix} LDCONFIG= -j${nproc} install
rm -f ${prefix}/lib/libtakum.a ${prefix}/lib/libtakum.lib ${prefix}/share/man/man3/takum*.3 ${prefix}/share/man/man7/libtakum.7
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products = [
    LibraryProduct("libtakum", :libtakum)
]

# Dependencies that must be installed before this package can be built
dependencies = Dependency[
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies; julia_compat="1.6")
