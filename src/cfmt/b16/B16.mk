##
## make file for create b16.lib
##

ASMLIST        := 16main 16conv 16pixel 16line 16vline 16putm 16hflip 16plxf\
		  16plxg 16plxt 16conv_m
INCLIST        := equ misc ugl dct cfmt log vbe
LIBNAME        := B16
LIBCD          := cfmt\\
BAKCD          := ..\\

.INCLUDE        : ..\..\common.mk
