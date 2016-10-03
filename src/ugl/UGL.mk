##
## make file for create ugl.lib
##

ASMLIST        := uglbez uglbmp uglelip uglelipf uglclear uglcolor uglconv\
                  ugldc ugldel uglget uglhline uglline uglmain uglmode uglnew\
                  uglpage uglpixel uglpoly uglpolyf uglput uglputm uglputb\
		  uglrect uglrectf uglrow uglsel uglvline\
		  uglplxf uglplxg uglplxt uglplxtp uglrtscl uglpal
INCLIST        := ugl equ dct cfmt log polyx bez
LIBNAME        := UGL

.INCLUDE        : ..\common.mk
