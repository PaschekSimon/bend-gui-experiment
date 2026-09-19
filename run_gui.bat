@echo off
REM Launcher for Bend GUI Text Input via WSLg
REM Runs the Linux native binary built in WSL

set WSL_DISTRO=Ubuntu
set BINARY_PATH=/home/simon/gui_app

wsl -d %WSL_DISTRO% -- bash -c "export DISPLAY=:0; export WAYLAND_DISPLAY=wayland-0; export XDG_RUNTIME_DIR=/mnt/wslg/runtime-dir; %BINARY_PATH%"