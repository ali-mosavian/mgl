##
## make file for create b15.lib
##

ASMLIST        := 15main 15conv 15putm 15hflip 15plxg 15plxt 15conv_m
INCLIST        := equ misc ugl dct cfmt log vbe
LIBNAME        := B15
LIBCD          := cfmt\\
BAKCD          := ..\\

.INCLUDE        : ..\..\common.mk
