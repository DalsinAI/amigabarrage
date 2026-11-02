#!/bin/sh
set -eu

SOURCE_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
BUILD_DIR=${BARRAGE_BUILD_DIR:-"$SOURCE_DIR/build/amigaos3"}
STAGE_DIR=${BARRAGE_STAGE_DIR:-"$SOURCE_DIR/Barrage-AmigaOS3"}

mkdir -p "$STAGE_DIR/data/gfx" "$STAGE_DIR/data/sounds"
cp "$BUILD_DIR/Barrage" "$STAGE_DIR/Barrage"
cp "$BUILD_DIR/BarrageLauncher" "$STAGE_DIR/Start Game"
cp "$SOURCE_DIR/amigaos3/Start Game.info" "$STAGE_DIR/Start Game.info"
# The shared artwork starts as WBPROJECT. This is a native launcher executable,
# so set DiskObject do_Type (byte 48) to WBTOOL.
printf '\003' | dd of="$STAGE_DIR/Start Game.info" bs=1 seek=48 count=1 conv=notrunc 2>/dev/null
cp "$SOURCE_DIR/amigaos3/Drawer.info" "$STAGE_DIR.info"
cp "$SOURCE_DIR/src/gfx/"*.bmp "$STAGE_DIR/data/gfx/"
cp "$SOURCE_DIR/src/sounds/"*.wav "$STAGE_DIR/data/sounds/"
cp "$SOURCE_DIR/COPYING" "$SOURCE_DIR/README" "$SOURCE_DIR/AMIGAOS3.md" "$STAGE_DIR/"
chmod +x "$STAGE_DIR/Barrage" "$STAGE_DIR/Start Game"

printf '%s\n' "Packaged Barrage for AmigaOS 3 at $STAGE_DIR"
