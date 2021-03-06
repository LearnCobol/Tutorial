      $ SET SOURCEFORMAT"FREE"
IDENTIFICATION DIVISION.
PROGRAM-ID.  Direct2Seq.
AUTHOR. Michael Coughlan.
*The ACME Stock Reorder System (ACME99.CBL) file set up program

ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
        SELECT STOCK-OUT ASSIGN TO "OutSTK.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

        SELECT MANF-OUT ASSIGN TO "OutMANF.DAT"
               ORGANIZATION IS LINE SEQUENTIAL.

	SELECT STOCK-FILE ASSIGN TO "STOCK.DAT"
                        ORGANIZATION IS RELATIVE
                        ACCESS MODE IS SEQUENTIAL
                        RELATIVE KEY IS STOCK-REC-POINTER-WB
                        FILE STATUS IS STOCK-STATUS-WB.

        SELECT MANF-FILE ASSIGN TO "MANF.DAT"
                        ORGANIZATION IS INDEXED
                        ACCESS MODE IS SEQUENTIAL
                        RECORD KEY IS MANF-CODE-FC
                        ALTERNATE RECORD KEY IS MANF-NAME-FC
                                 WITH DUPLICATES
                        FILE STATUS IS MANF-STATUS-WB.

DATA DIVISION.
FILE SECTION.
FD  STOCK-OUT.
01      STOCK-REC.
	02	STOCK-NUM			PIC 9(5).
	02	FILLER				PIC X(60).

FD  MANF-OUT.
01     MANF-REC                             PIC X(104).


FD  STOCK-FILE.
01      STOCK-REC-FB.
	02	STOCK-NUM-FB			PIC 9(5).
	02	MANF-CODE-FB			PIC X(4).
	02	ITEM-DESC-FB			PIC X(30).
	02	QTY-IN-STOCK-FB			PIC 9(6).
	02	REORDER-LEVEL-FB		PIC 999.
	02	REORDER-QTY-FB			PIC 9(6).
	02	ITEM-COST-FB			PIC 9(5).
	02	ITEM-WEIGHT-FB			PIC 9(5).
	02	ON-ORDER-FB			PIC X.	
		
FD  MANF-FILE.
01	MANF-REC-FC.
	02	MANF-CODE-FC			PIC X(4).
	02	MANF-NAME-FC			PIC X(30).
	02	MANF-ADDRESS-FC			PIC X(70).

WORKING-STORAGE SECTION.
01	FILE-DATA-WB.
	02	STOCK-REC-POINTER-WB			PIC 9(5).
	02	STOCK-STATUS-WB				PIC XX.
	02	MANF-STATUS-WB				PIC XX.
	02	FILLER					PIC 9 VALUE 0.
		88	END-OF-STOCK		VALUE 1.
	        88      END-OF-MANF             VALUE 2.


PROCEDURE DIVISION.
CREATE-REORDER-FILE.
   OPEN INPUT STOCK-FILE.

   OPEN OUTPUT STOCK-OUT.

   READ STOCK-FILE
        AT END SET END-OF-STOCK TO TRUE
   END-READ.
   PERFORM UNTIL END-OF-STOCK
      MOVE STOCK-REC-FB TO  STOCK-REC
      WRITE STOCK-REC
      READ STOCK-FILE
        AT END SET END-OF-STOCK TO TRUE
      END-READ
   END-PERFORM.
   CLOSE STOCK-FILE, STOCK-OUT.

   OPEN INPUT MANF-FILE.
   OPEN OUTPUT MANF-OUT.

   READ MANF-FILE
        AT END SET END-OF-MANF TO TRUE
   END-READ.
   PERFORM UNTIL END-OF-MANF
      MOVE MANF-REC-FC TO MANF-REC
      WRITE MANF-REC
      READ MANF-FILE
        AT END SET END-OF-MANF TO TRUE
      END-READ
   END-PERFORM.


   CLOSE MANF-FILE, MANF-OUT.
   STOP RUN.
