''
'' bas.bas -- BASIC side (main)
''

DefInt A-Z
'$Include: '..\..\..\inc\ugl.bi'

Const xRes = 320
Const yRes = 200
Const cFmt = UGL.16BIT

Declare Sub ExitError (msg As String)

Declare function allocDCs% (  )
Declare Sub showDCs ( byval video as long )

'':::
    Dim video As Long
    
    '' initialize
    If (Not uglInit) Then ExitError "Init"
    
    '' change video-mode
    video = uglSetVideoDC(cFmt, xRes, yRes, 1)
    If (video = 0) Then ExitError "SetVideoDC"
    
    if ( not allocDCs ) then ExitError "allocDCs"
    
    uglClear video, uglColor(cFmt, 0, 255, 0)
    
    showDCs video
    
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
