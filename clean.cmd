@echo off

setlocal

rmdir /S /Q c:\Users\doccaico\AppData\Local\zig
rmdir /S /Q .zig-cache
rmdir /S /Q zig-out

endlocal

REM vim: ft=dosbatch fenc=cp932 ff=dos
