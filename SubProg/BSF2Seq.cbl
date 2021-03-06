      $ SET SOURCEFORMAT"FREE"
IDENTIFICATION DIVISION.
PROGRAM-ID. BSF2SEQ.
AUTHOR.  Michael Coughlan.
ENVIRONMENT DIVISION.
INPUT-OUTPUT SECTION.
FILE-CONTROL.
    SELECT BookStockFile ASSIGN TO "BookStock.DAT"
        ORGANIZATION IS INDEXED
        ACCESS MODE IS SEQUENTIAL
        RECORD KEY IS Book-Id-BSF
        ALTERNATE RECORD KEY IS Book-Title-BSF
        ALTERNATE RECORD KEY IS Author-Id-BSF
                  WITH DUPLICATES
        FILE STATUS IS BookStatus.

    SELECT BSF-SEQ ASSIGN TO "BSF-OUT.DAT"
        ORGANIZATION IS LINE SEQUENTIAL.

DATA DIVISION.
FILE SECTION.
FD  BookStockFile.
01  BookStockRec.
    88 EndOfBSF                 VALUE HIGH-VALUES.
    02  Book-Id-BSF             PIC X(5).
    02  Book-Title-BSF          PIC X(30).
    02  Author-Id-BSF           PIC 9(4).
    02  Qty-In-Stock-BSF        PIC 999.
    02  Copy-Price-BSF          PIC 99V99.

FD  BSF-SEQ.
01 BSF-SEQ-Rec.
    88  EndOfSeq                VALUE HIGH-VALUES.
    02  Book-Id-SEQ             PIC X(5).
    02  Book-Title-SEQ          PIC X(30).
    02  Author-Id-SEQ           PIC 9(4).
    02  Qty-In-Stock-SEQ        PIC 999.
    02  Copy-Price-SEQ          PIC 99V99.



WORKING-STORAGE SECTION.
01  BookStatus                  PIC XX.
01  BookNum                     PIC 99.
01  Copy-Postage                PIC 99V99.
01  Cust-Address                PIC X(40).
01  UnstringPtr                 PIC 99.
    88 EndOfAddress             VALUE 41.
01  Country-Code                PIC XX.



PROCEDURE DIVISION.
Begin.
    OPEN OUTPUT BSF-SEQ.
    OPEN INPUT BookStockFile.
    READ BookStockFile
        AT END SET EndOfBSF TO TRUE
    END-READ.
    PERFORM UNTIL EndOfBSF
        WRITE BSF-SEQ-REC FROM BookStockRec
        READ BookStockFile
           AT END SET EndOfBSF TO TRUE
        END-READ
     END-PERFORM
     CLOSE BSF-SEQ, BookStockFile
    STOP RUN.

