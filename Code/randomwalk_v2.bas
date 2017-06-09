declare sub gfx_box(buffer as integer ptr, x1 as integer, y1 as integer,_
                    x2 as integer, y2 as integer, col as integer,_
                    scr_size_x as integer) 

screenres 500,500,32,1
ScreenSet 1,0

dim as integer screenSizeX = 500
dim as LongInt numOfSquaresHorizontal= 40
dim as LongInt numOfSquaresVertical = 40
dim as LongInt squareSize = 10
dim as LongInt indent = 2
dim as LongInt lineWidth = 3
dim as LongInt x0 = 10
dim as LongInt y0 = 10
dim as LongInt gridCornerX = x0
dim as LongInt gridCornerY = y0
dim as LongInt startX 
dim as LongInt startY 
dim as LongInt direction
dim as LongInt currentX 
dim as LongInt currentY 
dim as LongInt minX 
dim as LongInt minY 
dim as LongInt maxX 
dim as LongInt maxY 
dim as LongInt speed 
dim as LongInt startPositionHorizontal
dim as LongInt startPositionVertical 
dim as LongInt numberOfSteps 

dim Start As Double

dim as String stepStr
dim as String timeStr
dim as String dirStr 
dim as String initPositionStr 
dim as String nextPositionStr 

dim as LongInt nextX 
dim as LongInt nextY 

dim as integer i

'output stream variables
dim As String printfile = "path.txt"
dim As Integer printer = Freefile
Open printfile For Output As #printer
#UnDef Lprint
#Define Lprint Print #printer,

'array to store all nodes' coordinates
dim As LongInt xCoordArray(numOfSquaresVertical)
dim As LongInt yCoordArray(numOfSquaresHorizontal)

dim as LongInt  row, col

'input stream variables
dim As Integer varValue()
dim As String  varName()
dim As String  lname()
dim As Integer count = -1
dim As String readfile = "parameters.txt"
dim As Integer reader = Freefile

'first check whether the parameters file exists
If dir(readfile)="" Then:
    ' if "parameters.txt" file does not exist -- use default values
    speed = 100 'default value
    startPositionHorizontal = 2'2 squares left by default'
    startPositionVertical = 5 '5 squares down by default 
    numberOfSteps = 10000 'default value

Else: 
    ' if "parameters.txt" file  exists -- read the variables from the file
    Open readfile For Input As  reader
    While Not Eof(reader)
        count +=1 
        Redim Preserve varName(count), varValue(count)
        Input #reader, varName(count), varValue(count)
    Wend
    Close reader
    
    'set the variables from "parameters.txt" file
    For idx as Integer = 0 To count
        If varName(idx) = "numberOfSteps" Then:
            numberOfSteps = varValue(idx)
        EndIf
        If varName(idx) = "startPositionHorizontal" Then:
            startPositionHorizontal = varValue(idx)
        EndIf
        If varName(idx) = "startPositionVertical" Then:
            startPositionVertical = varValue(idx)
        EndIf
        If varName(idx) = "speed" Then:
            speed = varValue(idx)
        EndIf
    Next
EndIf



'draw the grid
For row=1 To numOfSquaresVertical
    For col=1 To numOfSquaresHorizontal
        xCoordArray(col-1)= gridCornerX
        gfx_box(screenptr, gridCornerX, gridCornerY, gridCornerX+squareSize,_
                gridCornerY+squareSize, rgb(255,255,255), screenSizeX)
        gridCornerX = x0+col*(squareSize+indent)
    Next col
    yCoordArray(row-1)= gridCornerY
    gridCornerX = x0
    gridCornerY = y0+row*(squareSize+indent)
Next row


minX = xCoordArray(0)
maxX = xCoordArray(numOfSquaresVertical-1)+squareSize

minY = yCoordArray(0)
maxY = yCoordArray(numOfSquaresHorizontal-1)+squareSize

startX = xCoordArray(startPositionHorizontal)
startY = yCoordArray(startPositionVertical)

nextX = startX
nextY = startY

Lprint "Step" & Space(10-Len("Step"))&_
       "Time, msec" & Space(20-Len("Time, msec"))&_
       "Direction" & Space(15-Len("Direction"))& _
       "Init Position" & Space(15-Len("Init Position")) &_
       "Next Position" & Space(15-Len("Next Position"))
    
Start = Timer

For i=1 To numberOfSteps
    'direction legend:
    '1-left
    '2-right
    '3 -up
    '4-down
    
    'decide which direction to go
    randomize(timer)
    Randomize
    
    'generate a random integer from 1 to 4
    direction = int(4*Rnd+1)

    'update X coordinates
    If nextX > minX and nextX < maxX Then:
        currentX = nextX
    EndIf
    'update Y coordinates
    If nextY > minY and nextY < maxY Then:
        currentY = nextY
    EndIf
    
    screenlock
    
    'LEFT
    If direction = 1 Then: 
        dirStr = "LEFT"
        nextX = currentX - squareSize - indent 
        nextY = currentY 
    
        gfx_box(screenptr, nextX, currentY -lineWidth/2, currentX,_
                                            nextY+lineWidth/2, rgb(255,0,0),500)
        'draw a 'black head' pointing the direction of the movement
        gfx_box(screenptr, nextX, currentY -lineWidth/2, nextX+squareSize/2,_
                                            nextY+lineWidth/2, rgb(0,0,0), 500)
    
    EndIf
    
    'RIGHT
    If direction = 2 Then: 
        dirStr = "RIGHT"
        nextX = currentX + squareSize + indent
        nextY = currentY 
    
        gfx_box(screenptr, currentX, currentY - lineWidth/2, nextX,_
                                         nextY + lineWidth/2, rgb(255,0,0), 500)
        'draw a 'black head' pointing the direction of the movement
        gfx_box(screenptr, nextX-squareSize/2, currentY - lineWidth/2, nextX,_
                                           nextY + lineWidth/2, rgb(0,0,0), 500)
        
    EndIf
    
    'UP
    If direction = 3 Then: 
        dirStr = "UP"
        nextX = currentX
        nextY = currentY - squareSize - indent
    
        gfx_box(screenptr, currentX-lineWidth/2, nextY, nextX+lineWidth/2,_
                                                    currentY, rgb(255,0,0), 500)
        'draw a 'black head' pointing the direction of the movement
        gfx_box(screenptr, currentX-lineWidth/2, nextY, nextX+lineWidth/2,_
                                            nextY+squareSize/2, rgb(0,0,0), 500)
    
    EndIf
    
    'DOWN
    If direction = 4 Then: 
        dirStr = "DOWN"
        nextX = currentX
        nextY = currentY + squareSize + indent
    
        gfx_box(screenptr, currentX-lineWidth/2, currentY, nextX+lineWidth/2,_
                                                       nextY, rgb(255,0,0), 500)
        'draw a 'black head' pointing the direction of the movement
        gfx_box(screenptr, currentX-lineWidth/2, nextY-squareSize/2,_
                                      nextX+lineWidth/2, nextY, rgb(0,0,0), 500)
    
    EndIf
    
    
    screenunlock
    
    ' use this trick to convert to the strings for file output
    stepStr = ""& i &""
    timeStr = ""& int((Timer-Start)*1000)&""
    initPositionStr = "(" & currentX & "," & currentY & ")"
    nextPositionStr = "(" & nextX & "," & nextY & ")"
    
    'pause for speed milliseconds to create an impression of animated movement
    sleep speed
    
    Lprint stepStr & Space(10-Len(stepStr))&_
           timeStr & Space(20-Len(timeStr))&_
           dirStr & Space(15-Len(dirStr))&_
           initPositionStr & Space(15-Len(initPositionStr)) &_
           nextPositionStr & Space(15-Len(nextPositionStr))
    
    
    'press 'q' to terminate the movement
    If Inkey = "q" Then:
        exit for
    EndIf
    
    
    're-color the 'black heads' back to red 
    If direction = 1 Then:
        If nextX+squareSize/2 > minX and nextX+squareSize/2 < maxX Then:
            gfx_box(screenptr, nextX, currentY -lineWidth/2, nextX+squareSize/2,_
                                           nextY+lineWidth/2, rgb(255,0,0), 500)
        EndIf
    EndIf
    
    If direction = 2 Then:
        If nextX-squareSize/2 > minX and nextX-squareSize/2 < maxX Then:
            gfx_box(screenptr, nextX-squareSize/2, currentY -lineWidth/2, nextX,_
                                           nextY+lineWidth/2, rgb(255,0,0), 500)
        EndIf
    EndIf
    
    If direction = 3 Then:
        If nextY+squareSize/2 > minY and nextY+squareSize/2 < maxY Then:
            gfx_box(screenptr, currentX-lineWidth/2, nextY, nextX+lineWidth/2,_
                                          nextY+squareSize/2, rgb(255,0,0), 500)
        EndIf
    EndIf
    
     If direction = 4 Then:
        If nextY-squareSize/2 > minY and nextY-squareSize/2 < maxY Then:
            gfx_box(screenptr, currentX-lineWidth/2, nextY-squareSize/2,_
                                    nextX+lineWidth/2, nextY, rgb(255,0,0), 500)
        EndIf
    EndIf
    
    
Next i


Close #printer

'===================================================================
Print "Normal exit."

sleep






'routine to draw a filled rectangle
sub gfx_box(buffer as integer ptr, x1 as integer, y1 as integer, x2 as integer,_
                          y2 as integer, col as integer, scr_size_x as integer) 
    dim as integer x, y, blit_corr

    x = (x2 - x1) + 1
    y = (y2 - y1) + 1

    buffer += (y1 * scr_size_x) + x1
    blit_corr = (scr_size_x - x) shl 2

    asm
        mov edi,[buffer]
        mov edx,[y]
        mov ebx,[x]'<-|
        mov eax,[col]'|
        nl_box:'      |
        mov ecx,ebx'<--difference = not fetching var W but keep it in a register
        rep stosd
        add edi,[blit_corr]
        dec edx
        jnz nl_box
    end asm
end sub
