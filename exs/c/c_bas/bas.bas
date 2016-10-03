''
'' bas.bas -- BASIC side (main)
''

DefInt A-Z
'$Include: '..\..\..\inc\ugl.bi'

Const xRes = 320*2
Const yRes = 200*2
Const cFmt = UGL.16BIT

Declare Sub ExitError (msg As String)

Declare Sub cClear ( Byval dc As Long, Byval clr As Long )

'':::
    Dim video As Long
    
    '' initialize
    If (Not uglInit) Then ExitError "Init"
    
    '' change video-mode
    video = uglSetVideoDC(cFmt, xRes, yRes, 1)
    If (video = 0) Then ExitError "SetVideoDC"
    
    cClear video, uglColor(cFmt, 0, 255, 0)
    sleep

    uglRestore
    uglEnd
    End

'':::
Sub ExitError (msg As String)
    uglRestore
    uglEnd
    Print "ERROR! "; msg
    End
End Sub
