# Barrage AmigaOS 3 RC1

First release candidate of the AmigaOS 3.2 port of Barrage 1.0.4.

## Requirements

- 68040 with FPU
- AmigaOS 3.2
- AmigaChrome OpenGPU SDL2 and SDL2_mixer modules

## Included

- Native `Start Game` Workbench launcher for the qualified windowed mode
- Native `Start Full Screen` launcher for retained-surface qualification
- Drawer and launch icons
- Complete GPL game graphics and sound data

## Qualified

- Title, menu and shooting-range gameplay
- Mouse aim and fire
- Space reload and Escape exit
- SDL2_mixer startup
- Windowed presentation on the OS 3.2.3 AC090 lab

Full-screen presentation is included for testing against gfopenrtg retained
surface #169/full22; it is not yet qualified on that baseline.

## Still to qualify

- Joystick and gamepad input on a real instance
- Audible sound output (the mixer starts successfully, but listening has not
  yet been checked)
