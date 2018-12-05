
/*------------------------------------------------------------------------
    File        : step1.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Wed Dec 05 08:51:11 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */


/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */

DEFINE TEMP-TABLE ttPolymer NO-UNDO  
    FIELD polymer  AS CHARACTER
    FIELD polynr   AS INTEGER
    FIELD strLen   AS INTEGER.
     
DEFINE BUFFER bbPolymer FOR ttPolymer.

DEFINE VARIABLE cData      AS LONGCHAR NO-UNDO CASE-SENSITIVE .
DEFINE VARIABLE cNewData   AS LONGCHAR NO-UNDO CASE-SENSITIVE .
DEFINE VARIABLE cRemData   AS LONGCHAR NO-UNDO.
DEFINE VARIABLE iLength    AS INTEGER  NO-UNDO.
DEFINE VARIABLE iNewLength AS INTEGER  NO-UNDO.    
DEFINE VARIABLE iAsc       AS INTEGER  NO-UNDO.
DEFINE VARIABLE iNr        AS INTEGER  NO-UNDO.
DEFINE VARIABLE iMin       AS INTEGER  NO-UNDO INIT 9999999.

COPY-LOB FROM FILE "jensdahlin-progressabl/day5/input.txt" TO cData.

/* Skapa polymerer */
DO iAsc = ASC("A") TO ASC("Z").
    iNr = iNr + 1.
    CREATE ttPolymer.
    ASSIGN 
        ttPolymer.polymer = CHR(iAsc) + CHR(iAsc + ASC("a") - ASC("A"))
        ttPolymer.polynr  = iNr.
    
    CREATE ttPolymer.
    ASSIGN 
        ttPolymer.polymer = CHR(iAsc + ASC("a") - ASC("A")) + CHR(iAsc)
        ttPolymer.polynr  = iNr.
END.

DISPLAY "Running...".


DO iAsc = ASC("A") TO ASC("Z"):
    cRemData = cData.
    
    cRemData = REPLACE(cRemData, CHR(iASC), "").
    
    cNewData = cRemData.
    
    /* Ta bort polymerer till strängen inte längre minskar */
    replLoop:
    REPEAT:
        iLength = LENGTH(cNewData).
    
        FOR EACH bbPolymer TABLE-SCAN :
            cNewData = REPLACE(cNewData, bbPolymer.polymer, "").    
        END.
        iNewLength = LENGTH(cNewData).
        
        IF iNewLength = iLength THEN LEAVE replLoop.
    END.    
    IF iNewLength < iMin THEN DO: 
        iMin = iNewLength.
    END.
    
END.

MESSAGE iMin VIEW-AS ALERT-BOX.
