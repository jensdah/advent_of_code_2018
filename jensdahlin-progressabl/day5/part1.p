
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
    FIELD polymer AS CHARACTER. 

DEFINE VARIABLE cData      AS LONGCHAR NO-UNDO CASE-SENSITIVE.
DEFINE VARIABLE iLength    AS INTEGER  NO-UNDO.
DEFINE VARIABLE iNewLength AS INTEGER  NO-UNDO.    
DEFINE VARIABLE iAsc       AS INTEGER  NO-UNDO.

COPY-LOB FROM FILE "jensdahlin-progressabl/day5/input.txt" TO cData.

/* Skapa polymerer */
DO iAsc = ASC("A") TO ASC("Z").
    CREATE ttPolymer.
    ASSIGN ttPolymer.polymer = CHR(iAsc) + CHR(iAsc + ASC("a") - ASC("A")).
    
    CREATE ttPolymer.
    ASSIGN ttPolymer.polymer = CHR(iAsc + ASC("a") - ASC("A")) + CHR(iAsc).
END.

/* Ta bort polymerer till strängen inte längre minskar */
replLoop:
REPEAT:
    iLength = LENGTH(cData).

    FOR EACH ttPolymer TABLE-SCAN:
        cData = REPLACE(cData, ttPolymer.polymer, "").    
    END.
    iNewLength = LENGTH(cData).
    
    IF iNewLength = iLength THEN LEAVE replLoop.
END.    


MESSAGE "Remains:" LENGTH(cData) VIEW-AS ALERT-BOX.
