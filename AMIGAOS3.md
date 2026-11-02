# Barrage for AmigaOS 3

This port targets AmigaOS 3.2 on a 68040/68881 system. It uses the existing
AmigaChrome SDL2 and SDL2_mixer modules; SDL's software window surface remains
the game's CPU-authoritative framebuffer and SDL presents it through OpenGPU.

## Build

```sh
make -f Makefile.amigaos3 \
  AMIGA_STOVE=/path/to/os32-gcc16
amigaos3/package.sh
```

The package is written to `Barrage-AmigaOS3` by default. Copy that drawer to
the Amiga and double-click **Start Game**. The package includes a drawer icon
and a native Workbench start icon; it does not require IconX or a shell script.

## Controls

- Mouse: aim
- Left mouse button: large grenade
- Middle mouse button or Ctrl + left mouse button: small grenade
- Right mouse button or Space: reload
- F: toggle full-screen/window mode
- S: toggle sound
- Tab: save a screenshot
- Escape: leave the current game or quit from the menu

High scores are stored as `PROGDIR:barrage.hscr`.
