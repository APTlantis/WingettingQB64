': This program uses
': InForm - GUI library for QB64 - v1.3
': Fellippe Heitor, 2016-2021 - fellippe@qb64.org - @fellippeheitor
': https://github.com/FellippeHeitor/InForm
'-----------------------------------------------------------

': Controls' IDs: ------------------------------------------------------------------
DIM SHARED WinGetting AS LONG
DIM SHARED SearchBT AS LONG
DIM SHARED SearchTB AS LONG
DIM SHARED ListBox1 AS LONG
DIM SHARED AddToListBT AS LONG
DIM SHARED DownloadThisPackageBT AS LONG
DIM SHARED Package1CB AS LONG
DIM SHARED ListBox2 AS LONG
DIM SHARED DownloadPackagesBT AS LONG
DIM SHARED SaveThisListBT AS LONG
DIM SHARED PackageLB AS LONG

': App state: ----------------------------------------------------------------------
DIM SHARED SelectedPackageName AS STRING
DIM SHARED SelectedPackageId AS STRING
DIM SHARED LastStatusMessage AS STRING
DIM SHARED ResultCount AS LONG
DIM SHARED ResultName(1 TO 200) AS STRING
DIM SHARED ResultId(1 TO 200) AS STRING

': External modules: ---------------------------------------------------------------
'$INCLUDE:'InForm\InForm.bi'
'$INCLUDE:'InForm\xp.uitheme'
'$INCLUDE:'QB64.frm'

': Event procedures: ---------------------------------------------------------------
SUB __UI_BeforeInit

END SUB

SUB __UI_OnLoad
    _PRINTMODE _KEEPBACKGROUND
    SetCaption PackageLB, "Package"
    SetCaption AddToListBT, "Install Selected"
    SetCaption DownloadThisPackageBT, "Install Selected"
    Text(SearchTB) = ""
    SelectedPackageName = ""
    SelectedPackageId = ""
    LastStatusMessage = ""
    ClearSearchResults
    Control(Package1CB).Hidden = True
    Control(ListBox2).Hidden = True
    Control(DownloadPackagesBT).Hidden = True
    Control(SaveThisListBT).Hidden = True
    LogControlIds
END SUB

SUB __UI_BeforeUpdateDisplay
    'This event occurs at approximately 60 frames per second.
    'You can change the update frequency by calling SetFrameRate DesiredRate%

END SUB

SUB __UI_BeforeUnload
    'If you set __UI_UnloadSignal = False here you can
    'cancel the user's request to close.

END SUB

SUB __UI_Click (id AS LONG)
    LogDebug "Click id=" + LTRIM$(STR$(id))
    SELECT CASE id
        CASE WinGetting

        CASE SearchBT
            LogDebug "Search button clicked. query=" + Text(SearchTB)
            DoSearch

        CASE SearchTB

        CASE ListBox1
            SyncSelectedPackageFromList

        CASE AddToListBT
            LogDebug "Install button (AddToListBT) clicked. selectedId=" + SelectedPackageId
            InstallSelectedPackage

        CASE DownloadThisPackageBT
            LogDebug "Install button clicked. selectedId=" + SelectedPackageId
            InstallSelectedPackage

        CASE Package1CB

        CASE ListBox2

        CASE DownloadPackagesBT

        CASE SaveThisListBT

        CASE PackageLB

    END SELECT
END SUB

SUB __UI_MouseEnter (id AS LONG)
    SELECT CASE id
        CASE WinGetting

        CASE SearchBT

        CASE SearchTB

        CASE ListBox1

        CASE AddToListBT

        CASE DownloadThisPackageBT

        CASE Package1CB

        CASE ListBox2

        CASE DownloadPackagesBT

        CASE SaveThisListBT

        CASE PackageLB

    END SELECT
END SUB

SUB __UI_MouseLeave (id AS LONG)
    SELECT CASE id
        CASE WinGetting

        CASE SearchBT

        CASE SearchTB

        CASE ListBox1

        CASE AddToListBT

        CASE DownloadThisPackageBT

        CASE Package1CB

        CASE ListBox2

        CASE DownloadPackagesBT

        CASE SaveThisListBT

        CASE PackageLB

    END SELECT
END SUB

SUB __UI_FocusIn (id AS LONG)
    SELECT CASE id
        CASE SearchBT

        CASE SearchTB

        CASE ListBox1

        CASE AddToListBT

        CASE DownloadThisPackageBT

        CASE Package1CB

        CASE ListBox2

        CASE DownloadPackagesBT

        CASE SaveThisListBT

    END SELECT
END SUB

SUB __UI_FocusOut (id AS LONG)
    'This event occurs right before a control loses focus.
    'To prevent a control from losing focus, set __UI_KeepFocus = True below.
    SELECT CASE id
        CASE SearchBT

        CASE SearchTB

        CASE ListBox1

        CASE AddToListBT

        CASE DownloadThisPackageBT

        CASE Package1CB

        CASE ListBox2

        CASE DownloadPackagesBT

        CASE SaveThisListBT

    END SELECT
END SUB

SUB __UI_MouseDown (id AS LONG)
    SELECT CASE id
        CASE WinGetting

        CASE SearchBT

        CASE SearchTB

        CASE ListBox1

        CASE AddToListBT

        CASE DownloadThisPackageBT

        CASE Package1CB

        CASE ListBox2

        CASE DownloadPackagesBT

        CASE SaveThisListBT

        CASE PackageLB

    END SELECT
END SUB

SUB __UI_MouseUp (id AS LONG)
    SELECT CASE id
        CASE WinGetting

        CASE SearchBT

        CASE SearchTB

        CASE ListBox1

        CASE AddToListBT

        CASE DownloadThisPackageBT

        CASE Package1CB

        CASE ListBox2

        CASE DownloadPackagesBT

        CASE SaveThisListBT

        CASE PackageLB

    END SELECT
END SUB

SUB __UI_KeyPress (id AS LONG)
    'When this event is fired, __UI_KeyHit will contain the code of the key hit.
    'You can change it and even cancel it by making it = 0
    SELECT CASE id
        CASE SearchBT

        CASE SearchTB
            IF __UI_KeyHit = 13 THEN
                DoSearch
                __UI_KeyHit = 0
            END IF

        CASE ListBox1

        CASE AddToListBT

        CASE DownloadThisPackageBT

        CASE Package1CB

        CASE ListBox2

        CASE DownloadPackagesBT

        CASE SaveThisListBT

    END SELECT
END SUB

SUB __UI_TextChanged (id AS LONG)
    SELECT CASE id
        CASE SearchTB

    END SELECT
END SUB

SUB __UI_ValueChanged (id AS LONG)
    SELECT CASE id
        CASE ListBox1
            SyncSelectedPackageFromList

        CASE Package1CB

        CASE ListBox2

    END SELECT
END SUB

SUB __UI_FormResized

END SUB

SUB DoSearch
    DIM query AS STRING
    DIM outputFile AS STRING
    DIM rawLine AS STRING
    DIM displayLine AS STRING
    DIM i AS LONG

    query = _TRIM$(Text(SearchTB))
    IF LEN(query) = 0 THEN
        SetStatus "Enter a package name or ID first."
        EXIT SUB
    END IF

    outputFile = ProjectFile$("winget_search_output.txt")
    DeleteFileIfExists outputFile
    LogDebug "DoSearch start. query=" + query
    SHELL _HIDE "cmd /c winget search " + CHR$(34) + EscapeCmdArg$(query) + CHR$(34) + " > " + CHR$(34) + outputFile + CHR$(34) + " 2>&1"

    IF _FILEEXISTS(outputFile) = 0 THEN
        SetStatus "Could not read winget output."
        LogDebug "Search output file missing."
        EXIT SUB
    END IF

    ClearSearchResults
    OPEN outputFile FOR INPUT AS #1
    DO UNTIL EOF(1)
        LINE INPUT #1, rawLine
        IF TryParseWingetSearchLine(rawLine, SelectedPackageName, SelectedPackageId) THEN
            IF ResultCount < UBOUND(ResultName) THEN
                ResultCount = ResultCount + 1
                ResultName(ResultCount) = SelectedPackageName
                ResultId(ResultCount) = SelectedPackageId
            END IF
        END IF
    LOOP
    CLOSE #1
    LogDebug "Parsed results count=" + LTRIM$(STR$(ResultCount))

    IF ResultCount > 0 THEN
        ResetList ListBox1
        FOR i = 1 TO ResultCount
            displayLine = ResultName(i) + " [" + ResultId(i) + "]"
            AddItem ListBox1, displayLine
        NEXT
        Control(ListBox1).Value = 1
        SyncSelectedPackageFromList
        SetStatus "Found " + LTRIM$(STR$(ResultCount)) + " match(es)."
        Notify "Search complete. Found " + LTRIM$(STR$(ResultCount)) + " package(s)." + CHR$(10) + "First: " + ResultName(1) + " [" + ResultId(1) + "]"
    ELSE
        ResetList ListBox1
        SetStatus "No package match found."
        Notify "No package match found."
        LogDebug "No results matched parser."
    END IF
END SUB

SUB InstallSelectedPackage
    DIM outputFile AS STRING
    DIM cmdLine AS STRING

    IF LEN(SelectedPackageId) = 0 THEN
        SetStatus "Search and select a package first."
        EXIT SUB
    END IF

    outputFile = ProjectFile$("winget_install_output.txt")
    DeleteFileIfExists outputFile
    SetStatus "Installing " + SelectedPackageName + "..."
    cmdLine = "winget install --id " + CHR$(34) + SelectedPackageId + CHR$(34) + " -e --accept-package-agreements --accept-source-agreements > " + CHR$(34) + outputFile + CHR$(34) + " 2>&1"
    LogDebug "Install start cmd=" + cmdLine
    SHELL _HIDE "cmd /c " + cmdLine

    IF InstallLooksSuccessful(outputFile) THEN
        SetStatus "Install finished for " + SelectedPackageName + "."
        Notify "Install finished for " + SelectedPackageName + "."
        LogDebug "Install success detected."
    ELSE
        SetStatus "Install may have failed. Check winget_install_output.txt"
        Notify "Install may have failed. Check:" + CHR$(10) + outputFile
        LogDebug "Install success not detected."
    END IF
END SUB

SUB SetStatus (message AS STRING)
    LastStatusMessage = message
    SetCaption PackageLB, message
    LogDebug "Status: " + message
END SUB

SUB DeleteFileIfExists (fileName AS STRING)
    IF _FILEEXISTS(fileName) THEN KILL fileName
END SUB

SUB ClearSearchResults
    DIM i AS LONG

    ResultCount = 0
    SelectedPackageName = ""
    SelectedPackageId = ""
    ResetList ListBox1
    FOR i = 1 TO UBOUND(ResultName)
        ResultName(i) = ""
        ResultId(i) = ""
    NEXT
END SUB

SUB SyncSelectedPackageFromList
    DIM idx AS LONG

    IF ResultCount <= 0 THEN EXIT SUB
    idx = CLNG(Control(ListBox1).Value)

    IF idx >= 1 AND idx <= ResultCount THEN
        SelectedPackageName = ResultName(idx)
        SelectedPackageId = ResultId(idx)
        SetStatus "Selected: " + SelectedPackageName + " [" + SelectedPackageId + "]"
    END IF
END SUB

FUNCTION TryParseWingetSearchLine%% (lineIn AS STRING, packageName AS STRING, packageId AS STRING)
    DIM s AS STRING
    DIM f1 AS STRING, f2 AS STRING
    DIM i AS LONG, c AS STRING, spaceRun AS LONG
    DIM p AS LONG

    s = _TRIM$(lineIn)
    IF LEN(s) = 0 THEN EXIT FUNCTION
    IF INSTR(s, "---") > 0 THEN EXIT FUNCTION
    IF LEFT$(UCASE$(s), 4) = "NAME" THEN EXIT FUNCTION
    IF INSTR(UCASE$(s), "NO PACKAGE FOUND") > 0 THEN EXIT FUNCTION

    s = ""
    spaceRun = 0
    FOR i = 1 TO LEN(lineIn)
        c = MID$(lineIn, i, 1)
        IF c = " " THEN
            spaceRun = spaceRun + 1
        ELSE
            IF spaceRun = 1 THEN
                s = s + " "
            ELSEIF spaceRun >= 2 THEN
                s = s + CHR$(9)
            END IF
            spaceRun = 0
            s = s + c
        END IF
    NEXT
    IF spaceRun = 1 THEN
        s = s + " "
    ELSEIF spaceRun >= 2 THEN
        s = s + CHR$(9)
    END IF

    s = _TRIM$(s)
    p = INSTR(s, CHR$(9))
    IF p = 0 THEN EXIT FUNCTION
    f1 = _TRIM$(LEFT$(s, p - 1))
    s = MID$(s, p + 1)

    p = INSTR(s, CHR$(9))
    IF p > 0 THEN
        f2 = _TRIM$(LEFT$(s, p - 1))
    ELSE
        f2 = _TRIM$(s)
    END IF

    IF LEN(f1) = 0 OR LEN(f2) = 0 THEN EXIT FUNCTION
    IF INSTR(f2, ".") = 0 THEN EXIT FUNCTION

    packageName = f1
    packageId = f2
    TryParseWingetSearchLine%% = True
END FUNCTION

FUNCTION InstallLooksSuccessful%% (outputFile AS STRING)
    DIM lineIn AS STRING
    DIM u AS STRING

    IF _FILEEXISTS(outputFile) = 0 THEN EXIT FUNCTION
    OPEN outputFile FOR INPUT AS #1
    DO UNTIL EOF(1)
        LINE INPUT #1, lineIn
        u = UCASE$(lineIn)
        IF INSTR(u, "SUCCESSFULLY INSTALLED") > 0 OR INSTR(u, "INSTALLED") > 0 THEN
            InstallLooksSuccessful%% = True
            EXIT DO
        END IF
    LOOP
    CLOSE #1
END FUNCTION

FUNCTION EscapeCmdArg$ (s AS STRING)
    DIM i AS LONG
    DIM ch AS STRING
    DIM escaped AS STRING

    escaped = ""
    FOR i = 1 TO LEN(s)
        ch = MID$(s, i, 1)
        IF ch = CHR$(34) THEN
            escaped = escaped + CHR$(34) + CHR$(34)
        ELSE
            escaped = escaped + ch
        END IF
    NEXT
    EscapeCmdArg$ = escaped
END FUNCTION

SUB Notify (message AS STRING)
    SetStatus message
    LogDebug "Notify: " + message
END SUB

SUB LogDebug (lineIn AS STRING)
    OPEN ProjectFile$("debug_log.txt") FOR APPEND AS #1
    PRINT #1, TIME$ + " | " + lineIn
    CLOSE #1
END SUB

SUB LogControlIds
    LogDebug "IDs WinGetting=" + LTRIM$(STR$(WinGetting)) + ", SearchBT=" + LTRIM$(STR$(SearchBT)) + ", SearchTB=" + LTRIM$(STR$(SearchTB))
    LogDebug "IDs ListBox1=" + LTRIM$(STR$(ListBox1)) + ", AddToListBT=" + LTRIM$(STR$(AddToListBT)) + ", DownloadThisPackageBT=" + LTRIM$(STR$(DownloadThisPackageBT))
    LogDebug "IDs Package1CB=" + LTRIM$(STR$(Package1CB)) + ", ListBox2=" + LTRIM$(STR$(ListBox2)) + ", DownloadPackagesBT=" + LTRIM$(STR$(DownloadPackagesBT))
    LogDebug "IDs SaveThisListBT=" + LTRIM$(STR$(SaveThisListBT)) + ", PackageLB=" + LTRIM$(STR$(PackageLB))
END SUB

FUNCTION ProjectFile$ (fileName AS STRING)
    ProjectFile$ = "D:\QB64\QB-Winget\" + fileName
END FUNCTION

'Fallback text routines when external falcon library is unavailable.
SUB uprint_extra (x&, y&, chars%&, length%&, kern&, do_render&, txt_width&, charpos%&, charcount&, colour~&, max_width&)
    txt_width& = 0
    charcount& = 0
END SUB

FUNCTION uprint (x&, y&, chars$, txt_len&, colour~&, max_width&)
    DIM s AS STRING
    IF txt_len& > 0 THEN
        s = LEFT$(chars$, txt_len&)
    ELSE
        s = chars$
    END IF
    _PRINTSTRING (x&, y&), s
    uprint = _PRINTWIDTH(s)
END FUNCTION

FUNCTION uprintwidth (chars$, txt_len&, max_width&)
    DIM s AS STRING
    IF txt_len& > 0 THEN
        s = LEFT$(chars$, txt_len&)
    ELSE
        s = chars$
    END IF
    uprintwidth = _PRINTWIDTH(s)
END FUNCTION

FUNCTION uheight& ()
    uheight& = _FONTHEIGHT
END FUNCTION

FUNCTION falcon_uspacing& ()
    falcon_uspacing& = _FONTHEIGHT
END FUNCTION

FUNCTION uascension& ()
    uascension& = _FONTHEIGHT
END FUNCTION

'$INCLUDE:'InForm\InForm.ui'
