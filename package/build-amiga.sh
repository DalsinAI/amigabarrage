#!/bin/sh
# The release archive, for Cradle's stove_build (target package): Barrage
# built with Makefile.amigaos3 for the 68040 in soft float (CPU="-m68040
# -msoft-float", so the stove's fpuauto takes the FPU when there is one),
# its drawer staged by amigaos3/package.sh, then package/pack.py makes
# amigabarrage-VERSION-68040.lha: the Barrage drawer and its icon, with the
# Installer (Install-Barrage and its icon, made by amicradle's
# scripts/ports/port_installer.py from package/installer.json) beside it at
# the archive's root. It also writes the .sha256, the drawer as Barrage.tar
# (for a lab) and package.json.
# package/soft-float.sh stops the build on a hard-float flag, a compile without soft
# float, an FPU instruction in the objects or no fpuauto.
# STOVE is the os32-gcc16 stove (or its prefix/); VERSION is package/VERSION.
# Nothing is published from here.
# MIT, Copyright (c) 2026 AmiCradle Team.
set -eu

JOBS=${JOBS:-2}
HERE=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
ROOT=$(CDPATH= cd -- "$HERE/.." && pwd)
OUT=${OUT:-"$ROOT/build-amiga-package"}
VERSION=$(cat "$HERE/VERSION")
STOVE=${STOVE:-"$(sh "$HERE/stove-dir.sh")"}
# Makefile.amigaos3 takes the stove's directory (it adds prefix/).
[ -x "$STOVE/prefix/bin/m68k-amigaos-gcc" ] || [ ! -x "$STOVE/bin/m68k-amigaos-gcc" ] || STOVE=$(dirname "$STOVE")
[ -x "$STOVE/prefix/bin/m68k-amigaos-gcc" ] || { echo "no m68k-amigaos-gcc in $STOVE/prefix (set STOVE)"; exit 2; }
P="$STOVE/prefix"
mkdir -p "$OUT"
OUT=$(CDPATH= cd -- "$OUT" && pwd)
BUILD=$(mktemp -d "${TMPDIR:-/tmp}/barrage-package.XXXXXX")
trap 'rm -rf "$BUILD"' EXIT INT TERM

# A copy of the checkout, so its build/ stays out of it.
SRC="$BUILD/src"
mkdir -p "$SRC"
( cd "$ROOT" && tar --exclude=.git --exclude=build-amiga-package --exclude=./build -cf - . ) | ( cd "$SRC" && tar -xf - )
( cd "$SRC" && make -f Makefile.amigaos3 -j"$JOBS" AMIGA_STOVE="$STOVE" VERSION_STRING="$VERSION" all ) \
	> "$OUT/build-output.txt" 2>&1 || { tail -n 60 "$OUT/build-output.txt"; exit 1; }
sh "$HERE/soft-float.sh" "$P" "$SRC/build/amigaos3/Barrage" --log "$OUT/build-output.txt" \
	"$SRC/build/amigaos3/obj" > "$OUT/soft-float.txt" || { cat "$OUT/soft-float.txt"; exit 1; }
cat "$OUT/soft-float.txt"

BARRAGE_BUILD_DIR="$SRC/build/amigaos3" BARRAGE_STAGE_DIR="$BUILD/dist/Barrage" sh "$SRC/amigaos3/package.sh"
python3 "$HERE/pack.py" --dist "$BUILD/dist" --drawer Barrage --program Barrage --archive amigabarrage \
	--version "$VERSION" --installer "$HERE/installer" --source "$(git -C "$ROOT" rev-parse HEAD 2>/dev/null || echo unknown)" \
	--compiler "$("$P/bin/m68k-amigaos-gcc" --version | head -n 1)" --out "$OUT"
