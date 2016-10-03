@echo off
call bccmp src\modcmn.c -D__BASLIB__
call bccmp src\modload.c -D__BASLIB__
call bccmp src\modmain.c -D__BASLIB__
call bccmp src\modmem.c -D__BASLIB__ 
call bccmp src\modplay.c -D__BASLIB__
call bccmp src\modtbl.c -D__BASLIB__
call bccmp src\modctrl.c -D__BASLIB__
call mlasm src\modamain.asm

lib16 uglmodqb.lib -+modcmn -+modload -+modmain -+modamain -+modmem -+modplay -+modtbl -+modctrl;

if exist *.obj del *.obj
if exist *.bak del *.bak


call bccmp src\modcmn.c
call bccmp src\modload.c
call bccmp src\modmain.c
call bccmp src\modmem.c
call bccmp src\modplay.c
call bccmp src\modtbl.c
call bccmp src\modctrl.c
call mlasm src\modamain.asm

lib16 uglmodc.lib -+modcmn -+modload -+modmain -+modamain -+modmem -+modplay -+modtbl -+modctrl;

if exist *.obj del *.obj
if exist *.bak del *.bak

ren *.lib *.lib
ren uglmodc.lib uglmodc.lib
ren uglmodqb.lib uglmodqb.lib