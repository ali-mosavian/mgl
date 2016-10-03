type vec3
    x       as single
    y       as single
    z       as single
end type

type vec3i
    x       as integer
    y       as integer
    z       as integer
end type

type boundbox
    min     as vec3
    max     as vec3
end type

type bboundbox
    min     as vec3i
    max     as vec3i
end type

type dentry
    offs    as long
    size    as long
end type

type header
    version     as long
    entities    as dentry
    planes      as dentry
    miptex      as dentry
    vertices    as dentry
    vislist     as dentry
    nodes       as dentry
    texinfo     as dentry
    faces       as dentry
    lightmaps   as dentry
    clipnode    as dentry
    leaves      as dentry
    lface       as dentry
    edges       as dentry
    ledges      as dentry
    models      as dentry
end type

type model
    mins        as vec3
    maxs        as vec3
	origin      as vec3
	headnode0   as long
	headnode1   as long
	headnode2   as long
	headnode3   as long
	visleafs    as long
	firstface   as long
	numfaces    as long
end type

type vertex
    x           as single
    y           as single
    z           as single
end type

type surface
    vectorS     as vec3
    distS       as single
    vectorT     as vec3
    distT       as single    
    textureid   as long
    animated    as long
end type

type edge
    v0          as integer    
    v1          as integer    
end type

type face
    planeid     as integer
    side        as integer
    ledgeid     as long
    ledgenum    as integer
    texinfoid   as integer
    flag1       as integer
    flag2       as integer
    lightmap    as long    
end type 

type face2
    planeid     as integer
    side        as integer    
    ledgeid     as long
    ledgenum    as integer
    texinfoid   as integer
    lightmap    as long    
end type 

type leaf
    cont        as long
    vislist     as long    
    bound       as bboundbox
    lfaceid     as integer
    lfacenum    as integer
    stuff       as string * 4
end type

type leaf2    
    vislist     as long    
    bound       as bboundbox
    lfaceid     as integer
    lfacenum    as integer    
end type

type plane
    norm        as vec3
    dist        as single
    ptype       as long    
end type

type plane2
    norm        as vec3
    dist        as single
    ptype       as integer
end type

type node
    planeid     as long
    child0      as integer    
    child1      as integer    
    bound       as bboundbox
    lfaceid     as integer
    lfacenum    as integer
end type

type nodeb
    planeid     as integer
    child0      as integer    
    child1      as integer
    lfaceid     as integer
    lfacenum    as integer
    bound       as bboundbox
end type

type texinfo
    vecs(3)     as single
    vect(3)     as single
    miptex      as long
    flags       as long
end type


type miptex
    name        as string * 16
    wdth        as long
    hght        as long
    offset(3)   as long
end type

type miptexb    
    wdth        as single
    hght        as single
    lnext       as integer
end type


type clipnode
    planenum    as long
    front       as integer
    back        as integer
end type


const FALSE = 0
const TRUE  = -1

type EnvType
    zFar        as single
    zNear       as single    
    
    hFont       as long
    hVideoDC    as long
    hBackBDC    as long
    
    mouse       as MOUSEINF
    Keyboard    as TKBD
    
    fpsTimer    as TMR                      '' expires every frame
    secTimer    as TMR                      '' /       every second
    frames      as single    
    
    xRes        as integer
    yRes        as integer
    cFmt        as integer
    pages       as integer
    usepag      as integer
    disclear    as integer
    
    sound       as integer
    camfov      as single
    cammode     as integer
    caminterp   as integer   
    camscrpt    as string * 40
    
end type

const DEG2RAD# = 3.14159265359 / 180.0

declare sub doInit    ( )
declare sub doMain    ( )
declare sub doEnd     ( )
declare sub ExitError ( msg as string )
declare sub pvsInit ( byval nodenr as integer )
declare sub bspShowModel ( model as integer )
declare function BBoxInFrustum% ( bbox as bboundbox, frustum() as plane )
declare sub ExtractFrustum ( frustum() as plane, mtx as u3dMtrx )
declare function ClipBBoxToFrustum% ( bbox as bboundbox, frustum() as plane )
declare sub parseIni ( filename as string )
declare sub strtok ( strm() as string, strm_cnt as integer, _
                     tokenlist as string, stream as string )
declare function bspCheckCollision% ( byval nodenr as integer, _
                              strPnt as u3dVector3f, _ 
                              endPnt as u3dVector3f )                     
declare function ClipToPlane% ( inPoly() as u3dVector4f, inVert as integer, _
                        otPoly() as u3dVector4f, otVert as integer, _
                        plan as plane )  
                        
                        
type uv
    u   as single
    v   as single
end type


declare sub strtok ( strm() as string, strm_cnt as integer, _
             tokenlist as string, stream as string )
declare function initFont% ( flname as string, col as long )
declare sub fontPrintChar ( dc as long, x as integer, y as integer, _
                           char as integer )
declare sub fontPrintText ( dc as long, x as integer, y as integer, _
                            text as string ) 
                            
declare function bspIsInside% ( byval nodenr as integer, strPnt as u3dVector3f )                                                      
declare sub ugluBMPSave ( file as string, byval dc as long )

                         
declare sub SHClipzNearFar ( otVtx() as u3dVector4f, otUV() as uv, otCnt as integer, _
                         inVtx() as u3dVector4f, inUV() as uv, inCnt as integer )
                                                    
