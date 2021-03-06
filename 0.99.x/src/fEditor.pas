// Copyright (c) 2009, ConTEXT Project Ltd
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// Neither the name of ConTEXT Project Ltd nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

unit fEditor;

interface

{$I ConTEXT.inc}

uses
  Windows,
  Messages,
  SysUtils,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ConTEXTSynEdit,
  SynEdit,
  SynEditKeyCmds,
  uFileHist,
  Menus,
  SynEditMiscProcs,
  Clipbrd,
  FileCtrl,
  ExtCtrls,
  SynEditHighlighter,
  SynEditSearch,
  ComCtrls,
  Math,
  uCommon,
  SynEditTypes,
  uHighlighterProcs,
  ShellAPI,
  uMultiLanguage,
  StdCtrls,
  //SynHighlighterText,
  SynEditTextBuffer,
  JclStrings,
  SynEditMiscClasses,
  uCommonClass,
  uEditorPlugins,
  fIncrementalSearch,
  TB2Dock,
  SpTBXDkPanels,
  SpTBXItem,
  SynHighlighterMyGeneral,
  fCodeTemplateInsert,
  uRuler,
  uEditorFileHandler;

type
  TEditorFindRec = record
    line: string;
    CurrXY: TBufferCoord;
    FoundXY: TBufferCoord;
    FoundText: string;
  end;

  pTEditorFindRec = ^TEditorFindRec;

  TfmEditor = class(TForm)
    memo: TConTEXTSynEdit;
    pnStatus: TStatusBar;
    dockBottom: TSpTBXDock;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure memoChange(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure memoDropFiles(Sender: TObject; X, Y: Integer; Files: TStrings);
    procedure FormShow(Sender: TObject);
    procedure timRecBlinkingTimer(Sender: TObject);
    procedure memoSpecialLineColors(Sender: TObject; Line: Integer; var Special: Boolean; var FG, BG: TColor);
    procedure memoProcessUserCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure memoProcessCommand(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure memoCommandProcessed(Sender: TObject; var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
    procedure memoStatusChange(Sender: TObject; Changes: TSynStatusChanges);
    procedure memoMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure memoKeyPress(Sender: TObject; var Key: Char);
    procedure memoMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure memoMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure memoDragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure memoDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure memoPaintTransient(Sender: TObject; Canvas: TCanvas; TransientType: TTransientType);
    procedure FOnTimTextDrag(Sender: TObject);
    procedure pnStatusResize(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure WndProc(var Message: TMessage); override;
  private
    FFileName: string;
    FModified: boolean;
    FileTime: TDateTime;
    FTextFormat: TTextFormat;
    FEncoding: TEncoding;
    FMacroIsRecording: boolean;
    FStatusMsg: string;
    FLoaded: boolean;
    FColorCurrentLine: boolean;
    FOverrideTxtFgColor: boolean;
    FReadOnly: boolean;
    fPreviousCaretY: integer;
    FLocked: boolean;
    fMovingRightEdge: boolean;
    FProjectFile: boolean;
    FDragTopLine: integer;
    fNewLineInserted: boolean;
    fMouseDownOnGutter: boolean;
    fMouseDownOnGutterY: integer;
    timRecBlinking: TTimer;
    wndRightEdgeHint: THintWindow;
    fOEMView: boolean;
    fKeepedUnexistedFile: boolean;

    fEmphasizeWordPlugin: TEmphasizeWordPlugin;
    fIncrementalSearchPanel: TIncrementalSearchPanel;
    fEmphasizedWord: string;
    fEmphasizeWord: boolean;
    fRulerVisible: boolean;
    fRuler: TRuler;
    fFileHandler: TEditorFileHandler;

    procedure SetFileName(value: string);
    procedure SetModified(value: boolean);
    procedure SetStatusMsg(value: string);
    procedure SetTextFormat(value: TTextFormat);
    procedure SetMacroRecording(value: boolean);
    procedure SetColorCurrentLine(value: boolean);
    procedure SetOverrideTxtFgColor(value: boolean);
    procedure SetLocked(Value: boolean);
    procedure SetMovingRightEdge(Value: boolean);
    procedure WriteStatus(n: integer; msg: string);
    procedure UpdateRightEdgeMovingHint;
    function CheckIsReadOnly: boolean;
    function GetReadOnlyString: string;
    procedure SaveFinished(Successfully: boolean; NewFileName: string);
    function GetTextFormat: TTextFormat;

    procedure RefreshCaption;
    procedure RefreshStatusPanels;
    procedure RefreshInsertOverwrite(value: boolean);
    procedure RefreshSelectionMode;
    procedure RefreshTextFormat;
    procedure RefreshFileSize;
    procedure RefreshSelectionStatusPanelMessage;
    procedure UpdateTimes;
    procedure CheckCurrentLineForWordwrap;
    procedure AdjustGutterLinesWidth;
    function MouseOverRightEdge(X, Y: integer): boolean;
    procedure UpdateAllEditorsRightEdge(NewValue: integer);
    procedure DoRemoveTrailingSpaces;
    procedure DoConvertTabsAndSpaces(Conversion: TTabsConversion);
    procedure DoRemoveComments;

    function GetExtWordUnderCursor(select: boolean; var word_beg, word_end: integer): string;
    procedure DefineUserCommands;

    procedure LoadEditingPosition;

    procedure WMSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;

    function DoFind(ptr: pointer): PChar;
    procedure DoFindNext(Direction: TFindDirection);
    procedure DoSort;
    function FillBlock(ptr: pointer): pointer;

    procedure DoToggleSelectionMode;
    function FileTypeSuitableForBlockIndent(var HL: pTHighlighter): boolean;
    procedure DoBlockIndentEnterKey;
    procedure DoBlockUnindentEnterKey;
    function IsTimeToBlockUnindent(PressedChar: char): boolean;
    function PreparedToMatchBraces: boolean;
    procedure DoInsertTimeStamp;
    procedure DoSelectAllColumnar;
    procedure DoSelectTextInBraces;
    procedure DoCopyFilenameToClipboard;

    procedure CT_ShowWindow;
    function CT_ShouldPopup: boolean;
    procedure CT_OnSelect(Sender: TfmCTInsert; ItemSelected: boolean; Item: string);
    procedure SetOEMView(const Value: boolean);
    function GetWordwrap: boolean;
    procedure SetWordwrap(const Value: boolean);
    property MovingRightEdge: boolean read fMovingRightEdge write SetMovingRightEdge;
    procedure SetEmphasizedWord(const Value: string);
    procedure SetEmphasizeWord(const Value: boolean);
    procedure SetRulerVisible(const Value: boolean);
    procedure SetEncoding(const Value: TEncoding);
  public
    NewFile: boolean;
    Unnamed: boolean;
    DefaultEmptyFile: boolean;
    LockHighlighterChange: boolean;

    function Open(fname: string; const DoLoadEditingPosition: boolean = TRUE): boolean;
    function Save(const ChangeName: boolean = FALSE): boolean;
    procedure SaveAs;
    procedure WriteBlockToFile(fname: string);
    function Reload: boolean;
    procedure ApplyOptions(cfg: pTEditorCfg);
    procedure ApplyOtherHLColors(HL: TSynCustomHighLighter);
    procedure ApplyRulerSettings;

    function InsertFileAtCurrentPosition(fname: string): boolean;
    function AppendFile(fname: string): boolean;
    procedure CheckFileTime;
    function GetWordUnderCursor: string;
    procedure RemoveSelection;

    procedure GetCursorPos(var X, Y: integer);
    procedure SetCursorPos(X, Y: integer);
    procedure SetCursorPosNice;
    procedure SetCurrentLineAtCenter;
    procedure SetCursorOnFirstNonBlank;
    procedure GoToLineDialog;
    procedure InvokeHelpFile;
    procedure ShellExecFile;

    procedure ToggleBookmark(n: integer);
    procedure JumpToBookmark(n: integer);
    procedure UpdateMainMenuBookmarks;

    function CutEnabled: boolean;
    function CopyEnabled: boolean;
    function PasteEnabled: boolean;
    function UndoEnabled: boolean;
    function RedoEnabled: boolean;
    function DeleteEnabled: boolean;
    function SortTextEnabled: boolean;
    function CopyFilenameToClipboardEnabled: boolean;

    procedure CutSelection;
    procedure CopySelection;
    procedure PasteSelection;
    procedure Undo;
    procedure Redo;
    procedure DeleteSelection;
    procedure SelectAll;
    function SelAvail: boolean;
    procedure DoFillBlockDialog; //!!WW
    procedure Sort;
    procedure Find;
    procedure FindNext;
    procedure FindPrevious;
    procedure DoIncrementalSearchDialog;
    procedure Replace;
    procedure MatchBraces;
    procedure SelectTextInBraces;
    procedure ToggleSelectionMode;
    procedure CopyFilenameToClipboard;

    function IndentBlockEnabled: boolean;
    function UnindentBlockEnabled: boolean;
    function InvertCaseEnabled: boolean;
    function ToUpperCaseEnabled: boolean;
    function ToLowerCaseEnabled: boolean;
    function ReformatParagraphEnabled: boolean;
    function FillBlockEnabled: boolean;
    function InsertTimeStampEnabled: boolean;
    function InsertCodeFromTemplateEnabled: boolean;
    function ToggleCommentBlockEnabled: boolean;
    function RemoveTrailingSpacesEnabled: boolean;
    function ConvertTabsToSpacesEnabled: boolean;
    function ConvertSpacesToTabsEnabled: boolean;
    function RemoveCommentsEnabled: boolean;

    procedure IndentBlock;
    procedure UnindentBlock;
    procedure InvertCase;
    procedure ToUpperCase;
    procedure ToLowerCase;
    procedure ReformatParagraph;
    procedure InsertTimeStamp;
    procedure InsertCodeFromTemplate;
    procedure ToggleCommentBlock;
    procedure RemoveTrailingSpaces;
    procedure ConvertTabsToSpaces;
    procedure ConvertSpacesToTabs;
    procedure RemoveComments;

    procedure RefreshMacroRecording(value: boolean);
    procedure SetFocusToEditor;

    function FindAllOccurences(const ASearch: string; AOptions: TSynSearchOptions): boolean;
    property FileHandler: TEditorFileHandler read fFileHandler;
  published
    property FileName: string read FFileName write SetFileName;
    property Modified: boolean read FModified write SetModified;
    property StatusMsg: string read FStatusMsg write SetStatusMsg;
    property TextFormat: TTextFormat read GetTextFormat write SetTextFormat;
    property Encoding: TEncoding read FEncoding write SetEncoding;
    property MacroIsRecording: boolean read FMacroIsRecording write SetMacroRecording;
    property ColorCurrentLine: boolean read FColorCurrentLine write SetColorCurrentLine;
    property OverrideTxtFgColor: boolean read FOverrideTxtFgColor write SetOverrideTxtFgColor;
    property Locked: boolean read FLocked write SetLocked;
    property ProjectFile: boolean read FProjectFile write FProjectFile;
    property OEMView: boolean read fOEMView write SetOEMView;
    property Wordwrap: boolean read GetWordwrap write SetWordwrap;
    property EmphasizedWord: string read fEmphasizedWord write SetEmphasizedWord;
    property EmphasizeWord: boolean read fEmphasizeWord write SetEmphasizeWord;
    property RulerVisible: boolean read fRulerVisible write SetRulerVisible;
    property IncrementalSearchPanel: TIncrementalSearchPanel read fIncrementalSearchPanel write fIncrementalSearchPanel;
  end;

  TEditorList = class(TList)
  private
    fFreeObjectsOnDestroy: boolean;
    function Get(Index: integer): TfmEditor;
    procedure Put(Index: integer; const Value: TfmEditor);
  public
    constructor Create(const FreeObjectsOnDestroy: boolean = FALSE);
    function Add(Editor: TfmEditor): integer;
    procedure Clear; override;
    property Items[Index: integer]: TfmEditor read Get write Put;
  end;

procedure PrepareOpenDlgForFileType(dlg: TOpenDialog; ed: TfmEditor);
procedure BringEditorToFront(Editor: TfmEditor; const InitialSetting: boolean = FALSE);
function CustomIdentToEditorCommand(const Ident: string; var Cmd: longint): boolean;
function CustomEditorCommandToIdent(Cmd: longint; var Ident: string): boolean;

var
  fmEditor: TfmEditor;

var
  FileCount: integer;
  DisableMRUFiles: boolean;
  DisableMinimizeWhenClosedAllFiles: boolean;

implementation

uses
  fMain,
  fFind,
  uCodeTemplate,
  uMacros,
  fBottomWindowContainer,
  uEnvOptions,
  IniFiles,
  fFileCompareResults;

{$R *.DFM}

const
  MEMO_SEPARATORS = ' "@.,:;()[]{}<>=&$#%*/\+-!|'''#09;
  EDIT_POSITIONS_FNAME = 'ConTEXT Positions.ini';

  STAT_XY_PANEL = 0;
  STAT_INSERT_PANEL = 1;
  STAT_SELECTION_PANEL = 2;
  STAT_MACRO_PANEL = 3;
  STAT_MODIFIED_PANEL = 4;
  STAT_TEXTFORMAT_PANEL = 5;
  STAT_FILESIZE_PANEL = 6;
  STAT_MSG_PANEL = 7;

  crGutter = 1;

type
  TMyEdit = class(TCustomSynEdit);
  TMyWinControl = class(TWinControl);

const
  LastGotoLineDialog: integer = 1;

  ////////////////////////////////////////////////////////////////////////////////////////////
  //                                Static functions
  ////////////////////////////////////////////////////////////////////////////////////////////
  //------------------------------------------------------------------------------------------

procedure PrepareOpenDlgForFileType(dlg: TOpenDialog; ed: TfmEditor);
var
  fHighlighters: TStringList;
  i: integer;
begin
  fHighlighters := GetHighlightersList;

  // dodaj custom
  for i := 0 to HIGHLIGHTERS_COUNT - 1 do
    if Highlighters[i].Custom then
      fHighlighters.AddObject(TSynMyGeneralSyn(Highlighters[i].HL).LanguageName,
        Highlighters[i].HL);

  dlg.Filter := 'All files (*.*)|*.*|' + GetHighlightersFilter(fHighlighters);

  if Assigned(ed) then
    dlg.FilterIndex := HighlighterToDlgFilterIndex(dlg.Filter,
      ed.memo.Highlighter)
  else
    dlg.FilterIndex := 1;

  fHighlighters.Free;
end;
//------------------------------------------------------------------------------------------

procedure BringEditorToFront(Editor: TfmEditor; const InitialSetting: boolean =
  FALSE);
begin
  if (Editor <> fmMain.ActiveEditor) then
  begin
    if ((fmMain.FindMaximizedForm <> nil) and not InitialSetting) then
    begin
      SendMessage(fmMain.Handle, WM_SETREDRAW, 0, 0);
      Editor.BringToFront;
      SendMessage(fmMain.Handle, WM_SETREDRAW, 1, 0);
      RedrawWindow(fmMain.Handle, nil, 0, RDW_ERASE or RDW_INVALIDATE or
        RDW_ERASENOW or RDW_UPDATENOW or RDW_ALLCHILDREN);
    end
    else
      Editor.BringToFront;
  end;
end;
//------------------------------------------------------------------------------------------

function CustomIdentToEditorCommand(const Ident: string; var Cmd: longint):
  boolean;
begin
  result := IdentToInt(Ident, Cmd, CustomEditorCommandStrs);
end;
//------------------------------------------------------------------------------------------

function CustomEditorCommandToIdent(Cmd: longint; var Ident: string): boolean;
begin
  result := IntToIdent(Cmd, Ident, CustomEditorCommandStrs);
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                      Messages
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

constructor TEditorList.Create(const FreeObjectsOnDestroy: boolean = FALSE);
begin
  fFreeObjectsOnDestroy := FreeObjectsOnDestroy;
end;
//------------------------------------------------------------------------------------------

function TEditorList.Add(Editor: TfmEditor): integer;
begin
  result := inherited Add(Editor);
end;
//------------------------------------------------------------------------------------------

procedure TEditorList.Clear;
var
  i: integer;
begin
  if fFreeObjectsOnDestroy then
    for i := 0 to Count - 1 do
      Items[i].Free;

  inherited;
end;
//------------------------------------------------------------------------------------------

function TEditorList.Get(Index: integer): TfmEditor;
begin
  result := inherited Get(Index);
end;
//------------------------------------------------------------------------------------------

procedure TEditorList.Put(Index: integer; const Value: TfmEditor);
begin
  inherited Put(Index, Value);
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                      Messages
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.WndProc(var Message: TMessage);
begin
  inherited;

  case Message.Msg of
    WM_SIZE:
      begin
        if FLoaded then
        begin
          pnStatus.Visible := (WindowState <> wsMaximized);
          fmMain.pnMainStatus.SimplePanel := pnStatus.Visible;
          RefreshStatusPanels;
        end;
      end;
    WM_MDIACTIVATE:
      begin
        RefreshStatusPanels;
      end;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.WMSysCommand(var Msg: TWMSysCommand);
begin
  case Msg.CmdType of
    SC_NextWindow:
      begin
        IsNext := True;
        postmessage(Application.Handle, wm_KeyDown, vk_F16, 0);
      end;
    SC_PREVWINDOW:
      begin
        IsPrev := True;
        postmessage(Application.Handle, wm_KeyDown, vk_F16, 0);
      end;
    SC_RESTORE:
      begin
        inherited;
        PostMessage(fmMain.Handle, WM_REPAINTALLMDI, 0, 0)
      end;
  else
    inherited;
  end;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                Code template functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

function TfmEditor.CT_ShouldPopup: boolean;
var
  HL: pTHighlighter;
  s: string;
  i, len, n: integer;
  strCompletions: TStrings;
begin
  result := FALSE;

  HL := GetHighlighterRec(memo.Highlighter);
  if not Assigned(HL) or not Assigned(HL^.CT) then
    EXIT;

  if (HL^.CT.Completions.Count > 0) then
  begin
    s := UpperCase(memo.GetWordAtRowCol(memo.CaretXY));
    len := Length(s);

    if (len > 0) then
    begin
      strCompletions := HL^.CT.Completions;
      i := 0;
      n := 0;
      while (i < strCompletions.Count) do
      begin
        if (s = UpperCase(Copy(strCompletions[i], 1, len))) then
          inc(n);

        if (n > 1) then
          BREAK;

        inc(i);
      end;

      result := (n > 1);
    end
    else
      result := TRUE;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.CT_ShowWindow;
var
  X, Y: integer;
  XY: TPoint;
  dXY: TDisplayCoord;
  fmCTInsert: TfmCTInsert;
  FCharSizeX, FCharSizeY, FCharAscent: integer;
  selected_item: string;
  word_beg, word_end: integer;
  HL: pTHighlighter;

  procedure RetrieveFontData;
  var
    DC: HDC;
    Save: THandle;
    Metric: TTextMetric;
  begin
    DC := GetDC(memo.Handle);
    Save := SelectObject(DC, memo.Font.Handle);
    GetTextMetrics(DC, Metric);
    DeleteObject(Save);
    ReleaseDC(memo.Handle, DC);
    with Metric do
    begin
      FCharSizeX := tmAveCharWidth;
      FCharSizeY := tmHeight + tmExternalLeading;
      FCharAscent := tmAscent;
    end;
  end;

  function AddCompletions(SelectedWord: string): integer;
  var
    i, len: integer;
    strCompletions: TStrings;
    strComments: TStrings;
  begin
    SelectedWord := UpperCase(SelectedWord);
    len := Length(SelectedWord);

    strCompletions := HL^.CT.Completions;
    strComments := HL^.CT.CompletionComments;

    i := 0;
    result := 0;
    while (i < strCompletions.Count) do
    begin
      if (len = 0) or (Pos(SelectedWord, UpperCase(strCompletions[i])) = 1) then
      begin
        fmCTInsert.AddItem(strCompletions[i], strComments[i]);
        inc(result);
      end;
      inc(i);
    end;
  end;

begin
  HL := GetHighlighterRec(memo.Highlighter);
  if not Assigned(HL) or not Assigned(HL^.CT) then
    EXIT;

  fmCTInsert := TfmCTInsert.Create(SELF);

  RetrieveFontData;
  selected_item := GetExtWordUnderCursor(TRUE, word_beg, word_end);
  if (AddCompletions(selected_item) = 0) then
    AddCompletions('');

  dXY := memo.DisplayXY;
  inc(dXY.Row, 1);
  dec(dXY.Column, (memo.CaretX - word_beg));

  XY := memo.RowColumnToPixels(dXY);

  X := XY.X;
  Y := XY.Y + 2;

  // provjeri da li lista izlazi van editora (Y)
  if (Y + fmCTInsert.Height > memo.Height) then
    dec(Y, fmCTInsert.Height + 2 * FCharSizeY);
  // provjeri da li lista izlazi van editora (X)
  if (X + fmCTInsert.Width > memo.Width) then
    X := memo.Width - fmCTInsert.GetWinWidth - 5;
  if (X < 0) then
    X := 0;

  XY := memo.ClientToScreen(Point(X, Y));
  X := XY.X;
  Y := XY.Y;

  with fmCTInsert do
  begin
    SavedCaretPosition := memo.CaretXY;
    OnCTSelect := Ct_OnSelect;
    SetBounds(X, Y, fmCTInsert.GetWinWidth, fmCTInsert.Height);

    if (fmMain.StayOnTop) then
      FormStyle := fsStayOnTop;
    Show;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.CT_OnSelect(Sender: TfmCTInsert; ItemSelected: boolean;
  Item: string);
begin
  if ItemSelected and (Length(Item) > 0) then
  begin
    memo.SelText := Item;
    memo.CommandProcessor(ecAutoCompletion, #01, nil);
  end
  else
  begin
    RemoveSelection;
    memo.CaretXY := Sender.SavedCaretPosition;
  end;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                Property functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetFileName(Value: string);
var
  diff_extension: boolean;
begin
  if (FFileName <> Value) then
  begin
    diff_extension := (UpperCase(ExtractFileExt(FFileName)) <>
      UpperCase(ExtractFileExt(Value)));

    FFileName := Value;
    if (not LockHighlighterChange) and diff_extension or not
      Assigned(memo.Highlighter) then
      fmMain.SetHighlighter(SELF, value);
    CheckIsReadOnly;
    RefreshCaption;
  end;
  LockHighlighterChange := FALSE;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RefreshStatusPanels;
begin
  // XY pozicija kursora
  memoStatusChange(SELF, []);

  // Insert/overwrite
  RefreshInsertOverwrite(memo.InsertMode);
  RefreshMacroRecording(MacroIsRecording);
  RefreshSelectionMode;
  RefreshTextFormat;
  RefreshFileSize;

  // Modified flag
  if Modified then
    WriteStatus(STAT_MODIFIED_PANEL, mlStr(ML_EDIT_MODIFIED, 'Modified'))
  else
    WriteStatus(STAT_MODIFIED_PANEL, '');
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RefreshInsertOverwrite(value: boolean);
begin
  if Value then
    WriteStatus(STAT_INSERT_PANEL, mlStr(ML_EDIT_INSERT, 'Insert'))
  else
    WriteStatus(STAT_INSERT_PANEL, mlStr(ML_EDIT_OVERWRITE, 'Overwrite'));
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RefreshMacroRecording(value: boolean);
begin
  if Value then
    WriteStatus(STAT_MACRO_PANEL, mlStr(ML_EDIT_RECORDING, 'Recording'))
  else
    WriteStatus(STAT_MACRO_PANEL, '');
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RefreshSelectionMode;
begin
  if (memo.SelectionMode = smNormal) then
    WriteStatus(STAT_SELECTION_PANEL, mlStr(ML_EDIT_SEL_NORMAL, 'Sel: Normal'))
  else
    WriteStatus(STAT_SELECTION_PANEL, mlStr(ML_EDIT_SEL_COLUMN, 'Sel: Column'));
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RefreshTextFormat;
begin
  case TextFormat of
    tfNormal:
      WriteStatus(STAT_TEXTFORMAT_PANEL, 'DOS');
    tfUnicode:
      WriteStatus(STAT_TEXTFORMAT_PANEL, 'Unicode');
    tfUnicodeBigEndian:
      WriteStatus(STAT_TEXTFORMAT_PANEL, 'Unicode BE');
    tfUTF8:
      WriteStatus(STAT_TEXTFORMAT_PANEL, 'UTF-8');
    tfUnix:
      WriteStatus(STAT_TEXTFORMAT_PANEL, 'UNIX');
    tfMac:
      WriteStatus(STAT_TEXTFORMAT_PANEL, 'MAC');
  else
    WriteStatus(STAT_TEXTFORMAT_PANEL, '');
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RefreshFileSize;
var
  size: integer;
  F: file;
  OldFileMode: integer;
begin
  size := 0;

  if not NewFile then
  begin
    AssignFile(F, FileName);
{$I-}
    OldFileMode := FileMode;
    FileMode := 0;
    // postavimo file mode na READ_ONLY da mo�emo otvoriti i R/O fajlove
    Reset(F, 1);
    FileMode := OldFileMode;
{$I+}
    if (IOResult = 0) then
    begin
      size := FileSize(F);
      CloseFile(F);
    end;
  end;

  if (size > 0) then
    WriteStatus(STAT_FILESIZE_PANEL, mlStr(ML_EDIT_FILE_SIZE, 'File size:') + ' '
      + IntToStr(size))
  else
    WriteStatus(STAT_FILESIZE_PANEL, '');
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RefreshSelectionStatusPanelMessage;
var
  char_count: integer;
  line_count: integer;
  s: string;
begin
  if SelAvail then
  begin
    line_count := memo.BlockEnd.Line - memo.BlockBegin.Line;

    if (memo.SelectionMode = smColumn) then
      char_count := Abs((memo.BlockEnd.Line - memo.BlockBegin.Line + 1) *
        (memo.BlockEnd.Char - memo.BlockBegin.Char))
    else
      char_count := memo.SelLength;

    if (line_count > 0) then
      s := Format(', %d %s', [line_count, mlStr(ML_EDIT_LINES_COUNT_CAPTION,
          'lines')])
    else
      s := '';

    StatusMsg := Format(mlStr(ML_EDIT_CHARS_COUNT_CAPTION,
      '%d chars%s selected.'), [char_count, s]);
  end
  else
    StatusMsg := '';
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetModified(value: boolean);
begin
  if (FModified <> Value) then
  begin
    FModified := value;

    if Value then
      WriteStatus(STAT_MODIFIED_PANEL, mlStr(ML_EDIT_MODIFIED, 'Modified'))
    else
      WriteStatus(STAT_MODIFIED_PANEL, '');

    RefreshCaption;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetStatusMsg(value: string);
begin
  if (FStatusMsg <> Value) then
  begin
    FStatusMsg := Value;

    WriteStatus(STAT_MSG_PANEL, Value);
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetTextFormat(value: TTextFormat);
begin
  if (FTextFormat <> value) then
  begin
    FTextFormat := Value;
    Modified := TRUE;
    RefreshTextFormat;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetMacroRecording(value: boolean);
begin
  FMacroIsRecording := value;

  if Value then
  begin
    timRecBlinking := TTimer.Create(SELF);
    with timRecBlinking do
    begin
      OnTimer := timRecBlinkingTimer;
      Interval := 500;
      Enabled := TRUE;
    end;
  end
  else
    FreeAndNil(timRecBlinking);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetColorCurrentLine(value: boolean);
var
  X, Y: integer;
begin
  FColorCurrentLine := Value;
  if Value then
  begin
    memo.OnSpecialLineColors := memoSpecialLineColors;

    if not memo.SelAvail then
    begin
      // jedino je ovo na�in da zaobi�em nekakav bug oko highlightanja teku�e linije
      GetCursorPos(X, Y);
      SetCursorPos(X, Y + 1);
      SetCursorPos(X, Y);
    end;
  end
  else
    memo.OnSpecialLineColors := nil;

  memo.Repaint;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetOverrideTxtFgColor(Value: boolean);
begin
  if Value then
  begin
    memo.Options := memo.Options - [eoSpecialLineDefaultFg];
  end
  else
    memo.Options := memo.Options + [eoSpecialLineDefaultFg];

  FOverrideTxtFgColor := Value;
  memo.Repaint;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetLocked(Value: boolean);
begin
  if (FLocked <> Value) then
  begin
    FLocked := Value;
    memo.ReadOnly := Value;
    RefreshCaption;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetMovingRightEdge(Value: boolean);
const
  oldX: integer = 0;
  oldY: integer = 0;
begin
  if (fMovingRightEdge <> Value) then
  begin
    fMovingRightEdge := Value;
    if Value then
    begin
      GetCursorPos(oldX, oldY);
      memo.BlockBegin := memo.BlockEnd;
      UpdateRightEdgeMovingHint;
    end
    else
    begin
      SetCursorPos(oldX, oldY);
      ShowWindow(wndRightEdgeHint.Handle, SW_HIDE);
      if Assigned(wndRightEdgeHint) then
      begin
        wndRightEdgeHint.Free;
        wndRightEdgeHint := nil;
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.WriteStatus(n: integer; msg: string);
begin
  if pnStatus.Visible then
    pnStatus.Panels[n].Text := msg
  else
    fmMain.pnMainStatus.Panels[n].Text := msg;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.UpdateRightEdgeMovingHint;
var
  R: TRect;
  pt: TPoint;
  s: string;
begin
  if not Assigned(wndRightEdgeHint) then
  begin
    wndRightEdgeHint := HintWindowClass.Create(Application);
    wndRightEdgeHint.Color := clInfoBk;
  end;

  s := IntToStr(memo.RightEdge);
  Windows.GetCursorPos(pt);

  with wndRightEdgeHint do
  begin
    R := CalcHintRect(200, s, nil);
    OffsetRect(R, pt.X + 8, pt.Y + 8);
    ActivateHint(R, s);
    SendMessage(Handle, WM_NCPAINT, 1, 0);
    Invalidate;
    Update;
  end;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.CheckIsReadOnly: boolean;
var
  attr: integer;
  old_FReadOnly: boolean;
begin
  old_FReadOnly := FReadOnly;

  attr := FileGetAttr(FileName);
  FReadOnly := (attr <> -1) and ((attr and faReadOnly) > 0);
  result := FReadOnly;

  if (FReadOnly <> old_FReadOnly) then
    RefreshCaption;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.GetReadOnlyString: string;
begin
  if FReadOnly then
    result := ' [' + mlStr(ML_EDIT_READONLY_MARKER, 'ReadOnly') + ']'
  else
    result := '';
end;

function TfmEditor.GetTextFormat: TTextFormat;
begin
  result := FTextFormat;
end;

//------------------------------------------------------------------------------------------

procedure TfmEditor.SetOEMView(const Value: boolean);
begin
  if (fOEMView <> Value) then
  begin
    fOEMView := Value;

    if Value then
    begin
      memo.Font.Name := EditorCfg.OEMFontName;
      memo.Font.Size := EditorCfg.OEMFontSize;
    end
    else
    begin
      memo.Font.Name := EditorCfg.FontName;
      memo.Font.Size := EditorCfg.FontSize;
    end;
  end;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.GetWordwrap: boolean;
begin
  result := memo.WordWrap;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetWordwrap(const Value: boolean);
begin
  memo.WordWrap := Value;
  ApplyRulerSettings;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetEmphasizeWord(const Value: boolean);
begin
  if (fEmphasizeWord <> Value) then
  begin
    fEmphasizeWord := Value;
    if Value then
    begin
      if not Assigned(fEmphasizeWordPlugin) then
        fEmphasizeWordPlugin := TEmphasizeWordPlugin.Create(memo);
      fEmphasizeWordPlugin.Word := fEmphasizedWord;
    end
    else
    begin
      if Assigned(fEmphasizeWordPlugin) then
        FreeAndNil(fEmphasizeWordPlugin);
    end;
    memo.Invalidate;
  end;
end;
procedure TfmEditor.SetEncoding(const Value: TEncoding);
begin
  if (FEncoding <> nil) and (Value.ClassName <> FEncoding.ClassName)  then
    memo.Text := fFileHandler.LoadNewEncoding(memo.Text, Value);
  // reload ???
  FEncoding := value;
end;

//------------------------------------------------------------------------------------------

procedure TfmEditor.SetEmphasizedWord(const Value: string);
begin
  if (fEmphasizedWord <> Value) then
  begin
    fEmphasizedWord := Value;

    if (fEmphasizeWord) then
    begin
      fEmphasizeWordPlugin.Word := Value;
      memo.Invalidate;
    end;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetRulerVisible(const Value: boolean);
begin
  if (fRulerVisible <> Value) then
  begin
    fRulerVisible := Value;

    if Value then
    begin
      fRuler := TRuler.Create(SELF);
      ApplyRulerSettings;
    end
    else
      FreeAndNil(fRuler);
  end;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                Tab functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.AdjustGutterLinesWidth;
begin
  if memo.Gutter.ShowLineNumbers then
    memo.Gutter.DigitCount := Length(IntToStr(memo.Lines.Count));
end;
//------------------------------------------------------------------------------------------

function TfmEditor.MouseOverRightEdge(X, Y: integer): boolean;
var
  right_edge_X: integer;
begin
  if EditorCfg.RightEdgeVisible then
  begin
    right_edge_X := memo.RowColumnToPixels(DisplayCoord(EditorCfg.RightEdge + 1,
      0)).X;
    result := (right_edge_X >= X - 2) and (right_edge_X <= X + 2);
  end
  else
    result := FALSE;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.UpdateAllEditorsRightEdge(NewValue: integer);
var
  ed: TfmEditor;
  n: integer;
begin
  n := 0;
  while fmMain.Enum(ed, n) do
    ed.memo.RightEdge := NewValue;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                Public methods
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetFocusToEditor;
begin
  memo.SetFocus;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.Open(fname: string; const DoLoadEditingPosition: boolean = TRUE): boolean;
var
  ok: boolean;
  rec: TSearchRec;
  str: TMemoryStream;

  function CanBeOpen(FileName: string): boolean;
  var
    stream: TFileStream;
  begin
    try
      stream := TFileStream.Create(FileName, fmOpenRead + fmShareDenyNone);
      stream.Free;
      result := TRUE;
    except
      result := FALSE;
    end;
  end;

begin
  str := nil;
  try
    SetLengthyOperation(TRUE);

    ok := (FindFirst(fname, faAnyFile, rec) = 0) and (rec.Size > 0) and
      CanBeOpen(fname);

    if ok then
    begin
      memo.Lines.Clear;
      str := TMemoryStream.Create;
      str.LoadFromFile(fname);
      memo.Text  := fFileHandler.LoadFromStream(str);
      TextFormat := fFileHandler.TextFormat;
    end
    else
    if (rec.Size = 0) then
      ok := TRUE;

    FindClose(rec);

    if ok then
    begin
      NewFile := FALSE;
      Unnamed := FALSE;

      FileName := fname;
      if not DisableMRUFiles then
      begin
        fmMain.mruFiles.MRUAdd(FileName);
        fmMain.UpdateHistoryPanel;
      end;
      UpdateTimes;
    end;
  except
    ok := FALSE;
  end;

  if ok then
  begin
    if DoLoadEditingPosition then
      LoadEditingPosition;
  end
  else
  begin
    FileName := fname;
    NewFile := not FileExists(fname);
    Unnamed := FALSE;
  end;

  if Assigned(str) then
    str.Free;

  if Assigned(fmFileCompareResults) then
    SendMessage(fmFileCompareResults.Handle, WM_EDITING_FILE_OPENING, 0, integer(SELF));

  DisableMRUFiles := FALSE;
  RefreshFileSize;
  Modified := FALSE;
  result := ok;
  SetLengthyOperation(FALSE);
end;
//------------------------------------------------------------------------------------------

function TfmEditor.Save(const ChangeName: boolean = FALSE): boolean;
var
  ok: boolean;
  fname: string;
begin
  SetLengthyOperation(TRUE);
  ok := FALSE;

  if fFilehandler.PrepareForSave(fname, ChangeName) then
  begin
    fFileHandler.BackupFile;
    ok := fFileHandler.SaveInFormat(memo.Lines, TextFormat, fname);
    SaveFinished(ok, fname);
  end;

  result := ok;
  SetLengthyOperation(FALSE);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SaveFinished(Successfully: boolean; NewFileName: string);
begin
  fmMain.PrjManager.RenameFile(FileName, NewFileName);
  FileName := NewFileName;
  AddLastDir(NewFileName);
  fmMain.mruFiles.MRUAdd(NewFileName);

  if Successfully then
  begin
    UpdateTimes;
    Modified := FALSE;
    NewFile := FALSE;
    Unnamed := FALSE;
    fmMain.FilePosHistory.UpdatePosition(SELF);
    RefreshFileSize;
    CheckIsReadOnly;
    if not EditorCfg.UndoAfterSave then
      memo.ClearUndo;
  end
  else
  begin
    DlgErrorSaveFile(FileName);
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SaveAs;
begin
  Save(TRUE);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.WriteBlockToFile(fname: string);
var
  str: TStringList;
begin
  str := TStringList.Create;

  try
    str.Text := memo.SelText;
    try
      str.SaveToFile(fname);
    except
      DlgErrorSaveFile(fname);
    end;
  finally
    str.Free;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.LoadEditingPosition;
var
  rec: TFilePosRec;
  i: integer;
  HL: pTHighlighter;
begin
  if fmMain.PrjManager.Loading then
    EXIT;

  rec := fmMain.FilePosHistory.GetPositionRec(FileName, i);

  if Assigned(rec) then
  begin
    memo.BeginUpdate;
    try
      memo.WordWrap := rec.Wordwrap;
      memo.CaretXY := BufferCoord(rec.X, rec.Y);
      memo.TopLine := rec.TopLine;

      for i := 0 to rec.BookmarkCount - 1 do
      begin
        if (rec.Bookmarks[i].X > 0) then
        begin
          memo.SetBookMark(rec.Bookmarks[i].Index, rec.Bookmarks[i].X,
            rec.Bookmarks[i].Y);
        end;
      end;

      if (Length(rec.HighlighterName) > 0) then
      begin
        HL := GetHighlighterRecByName(rec.HighlighterName);
        if Assigned(HL) then
          fmMain.SetHighlighter(SELF, '', HL);
      end;
    finally
      memo.EndUpdate;
    end;
  end
  else
  begin
    WordWrap := EditorCfg.WordwrapByDefault;
  end;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.Reload: boolean;
var
  X, Y: integer;
  FirstLine: integer;
begin
  result := false;

  if FileExists(FileName) then
  begin
    GetCursorPos(X, Y);
    FirstLine := memo.TopLine;

    result := Open(FileName);

    if result then
    begin
      memo.TopLine := FirstLine;
      SetCursorPos(X, Y);
    end
    else
      DlgErrorOpenFile(FileName);

    NewFile := FALSE;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ApplyOptions(cfg: pTEditorCfg);
begin
  memo.BeginUpdate;

  try
    with cfg^ do
    begin
      memo.Options := Options;

      // ili jedno, ili drugo - oboje stvara probleme
      if eoScrollPastEol in memo.Options then
        memo.Options := memo.Options - [eoKeepCaretX]
      else
        memo.Options := memo.Options + [eoKeepCaretX];

      if (memo.ExtraLineSpacing <> ExtraLineSpacing) then
        memo.ExtraLineSpacing := ExtraLineSpacing;

      memo.InsertCaret := InsertCaret;
      memo.OverwriteCaret := OverwriteCaret;

      if not fOEMView then
      begin
        memo.Font.Name := FontName;
        memo.Font.Size := FontSize;
      end;

      memo.Gutter.Font.Name := GutterFontName;
      memo.Gutter.Font.Size := GutterFontSize;

      if RightEdgeVisible then
        memo.RightEdge := RightEdge
      else
        memo.RightEdge := 0;

      if GutterVisible then
      begin
        memo.Gutter.Width := GutterWidth;
        memo.Gutter.Cursor := crGutter;
      end
      else
      begin
        memo.Gutter.Width := 0;
        memo.Gutter.Cursor := crDefault;
      end;

      memo.Gutter.ShowLineNumbers := LineNumbers;
      memo.TabWidth := EditorCfg.TabWidth;
      memo.BlockIndent := EditorCfg.BlockIndent;
      memo.TrimTrailingSpaces := EditorCfg.TrimTrailingSpaces;

      if (eoSmartTabs in memo.Options) then
        memo.Options := memo.Options + [eoSmartTabDelete]
      else
        memo.Options := memo.Options - [eoSmartTabDelete];

      case TabsMode of
        tmHardTabs:
          memo.Options := memo.Options - [eoTabsToSpaces];
        tmTabsToSpaces:
          memo.Options := memo.Options + [eoTabsToSpaces];
      end;

      memo.WordwrapGlyph.Visible := ShowWordwrapGlyph;
    end;
  finally
    memo.EndUpdate;
  end;

  RulerVisible := cfg^.RulerVisible;

  ApplyRulerSettings;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ApplyOtherHLColors(HL: TSynCustomHighLighter);
begin
  memo.SelectedColor.Foreground :=
    HL.Attribute[FindAttrIndex(ATTR_SELECTION_STR, HL)].Foreground;
  memo.SelectedColor.Background :=
    HL.Attribute[FindAttrIndex(ATTR_SELECTION_STR, HL)].Background;
  memo.RightEdgeColor := HL.Attribute[FindAttrIndex(ATTR_RIGHTEDGE_STR,
    HL)].Foreground;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.Undo;
begin
  memo.LockPaint(TRUE);
  try
    memo.Undo;
  finally
    memo.LockPaint(FALSE);
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.Redo;
begin
  memo.LockPaint(TRUE);
  try
    memo.Redo;
  finally
    memo.LockPaint(FALSE);
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.GetCursorPos(var X, Y: integer);
begin
  X := memo.CaretX - 1;
  Y := memo.CaretY - 1;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetCursorPos(X, Y: integer);
begin
  memo.CaretXY := BufferCoord(X + 1, Y + 1);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetCursorPosNice;
begin
  memo.EnsureCursorPosVisibleEx(TRUE);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetCurrentLineAtCenter;
//var
  //X, Y, T :integer;
begin
  memo.EnsureCursorPosVisibleEx(TRUE);
  //   GetCursorPos(X,Y);
  //
  //   T:=Y-(memo.LinesInWindow div 2);
  //   if (T<0) then T:=0;
  //   memo.TopLine:=T;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SetCursorOnFirstNonBlank;
var
  X: integer;
  Y: integer;
begin
  Y := memo.CaretY - 1;
  X := 1;
  while (X < Length(memo.Lines[Y])) and CharInSet(memo.Lines[Y][X], [' ', #09]) do
    inc(X);

  memo.CaretX := X;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.GoToLineDialog;
var
  Value: string;
  X, Y: integer;
  c: integer;
begin
  GetCursorPos(X, Y);
  Value := IntToStr(LastGotoLineDialog);

  if InputQuery(mlStr(ML_EDIT_GOTO_CAPTION, 'Go to'),
    mlStr(ML_EDIT_GOTO_TEXT, 'Go to line:'), Value) then
  begin
    Val(Value, Y, c);
    if (c = 0) then
    begin
      LastGotoLineDialog := Y;
      SetCursorPos(X, Y - 1);
      SetCursorPosNice;
    end;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ReformatParagraph;
var
  i, ii: integer;
  EndY: integer;
  s: string;
  outstr: string;
  finished: boolean;
  indent: integer;

  function StrDup(c: char; n: integer): string;
  begin
    result := '';
    while (Length(result) < n) do
      result := result + c;
  end;

begin
  if (Length(memo.Lines[memo.CaretXY.Line - 1]) = 0) then
    EXIT;

  memo.BeginUpdate;

  try
    memo.BlockBegin := BufferCoord(0, memo.CaretXY.Line);
    EndY := memo.CaretXY.Line - 1;
    while (EndY < memo.Lines.Count) and (Length(memo.Lines[EndY]) > 0) do
      inc(EndY);
    memo.BlockEnd := BufferCoord(Length(memo.Lines[EndY - 1]) + 1, EndY);

    s := memo.SelText;

    // saznaj koliki je indent
    indent := 0;
    if (eoAutoIndent in EditorCfg.Options) then
    begin
      while (Length(s) > indent) and (s[indent + 1] = ' ') do
        inc(indent);
    end;

    // ubij sve line breaks
    i := 1;
    repeat
      finished := (i > Length(s));

      if CharInSet(s[i], [#13, #10]) then
      begin
        s[i] := ' ';
        while (i + 1 < Length(s)) and CharInSet(s[i + 1], [' ', #13, #10]) do
          Delete(s, i + 1, 1);
      end;

      inc(i);
    until finished;

    // formiraj izlazni string s indentom
    outstr := '';
    while (Length(s) > 0) do
    begin
      if (Length(outStr) = 0) then
        i := EditorCfg.RightEdge
      else
        i := EditorCfg.RightEdge - indent;

      ii := i;

      if (Length(s) > EditorCfg.RightEdge - indent) then
      begin
        while (i > 0) and (Pos(s[i], MEMO_SEPARATORS) = 0) do
          dec(i);
      end;

      // rije� je dulja od RightEdge
      if (i = 0) then
      begin
        i := ii;
        while (i < Length(s)) and (Pos(s[i], MEMO_SEPARATORS) = 0) do
          inc(i);
      end;

      if (Length(outStr) = 0) then
        outstr := TrimRight(Copy(s, 1, i))
      else
        outstr := outstr + #13#10 + StrDup(' ', indent) + Trim(Copy(s, 1, i));

      Delete(s, 1, i);
      s := Trim(s);
    end;

    memo.SelText := outstr;
  finally
    memo.EndUpdate;
    SetCursorPosNice;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ToggleSelectionMode;
begin
  memo.CommandProcessor(ecToggleSelectionMode, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoToggleSelectionMode;
begin
  if (memo.SelectionMode = smNormal) then
    memo.SelectionMode := smColumn
  else
    memo.SelectionMode := smNormal;

  RefreshSelectionMode;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.IndentBlockEnabled: boolean;
begin
  result := not fLocked and SelAvail;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.InsertCodeFromTemplateEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.InsertTimeStampEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.InvertCaseEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.ReformatParagraphEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.RemoveTrailingSpacesEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.ConvertTabsToSpacesEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.ConvertSpacesToTabsEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.RemoveCommentsEnabled: boolean;
var
  HL: pTHighlighter;
begin
  HL := GetHighlighterRec(memo.Highlighter);
  result := (not fLocked) and Assigned(HL) and ((Length(HL^.CommentBegStr) > 0)
    or (Length(HL^.CommentLineStr) > 0));
end;
//------------------------------------------------------------------------------------------

function TfmEditor.ToggleCommentBlockEnabled: boolean;
var
  HL: pTHighlighter;
begin
  HL := GetHighlighterRec(memo.Highlighter);
  result := (not fLocked) and Assigned(HL) and ((Length(HL^.CommentBegStr) > 0)
    or (Length(HL^.CommentLineStr) > 0));
end;
//------------------------------------------------------------------------------------------

function TfmEditor.ToLowerCaseEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.ToUpperCaseEnabled: boolean;
begin
  result := not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.UnindentBlockEnabled: boolean;
begin
  result := not fLocked and SelAvail;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.CopyFilenameToClipboardEnabled: boolean;
begin
  result := not Unnamed;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.IndentBlock;
begin
  memo.CommandProcessor(ecBlockIndent, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.UnindentBlock;
begin
  memo.CommandProcessor(ecBlockUnindent, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.InvertCase;
begin
  memo.CommandProcessor(ecToggleCaseBlock, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ToUpperCase;
begin
  memo.CommandProcessor(ecUpperCaseBlock, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ToLowerCase;
begin
  memo.CommandProcessor(ecLowerCaseBlock, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ToggleBookmark(n: integer);
begin
  memo.CommandProcessor(ecSetMarker0 + n, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.InsertTimeStamp;
begin
  memo.CommandProcessor(ecInsertTimeStamp, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.InsertCodeFromTemplate;
begin
  if not fLocked then
    memo.CommandProcessor(ecAutoCompletion, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.JumpToBookmark(n: integer);
begin
  RemoveSelection;
  memo.GotoBookMark(n);
  SetCurrentLineAtCenter;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.UpdateMainMenuBookmarks;
var
  i: integer;
  n: integer;
  s: string;
begin
  for i := 0 to fmMain.miJumpToBookmark.Count - 1 do
    fmMain.miJumpToBookmark.Items[i].Caption := '&' + IntToStr(i);

  for i := 0 to memo.Marks.Count - 1 do
  begin
    if Assigned(memo.Marks[i]) then
      s := ' ' + Trim(memo.Lines[memo.Marks[i].Line - 1])
    else
      s := '';

    n := memo.Marks[i].BookmarkNumber;
    fmMain.miJumpToBookmark.Items[n].Caption := '&' + IntToStr(n) + s;
  end;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.FileTypeSuitableForBlockIndent(var HL: pTHighlighter):
  boolean;
begin
  HL := GetHighlighterRec(memo.Highlighter);
  result := Assigned(HL) and HL^.BlockAutoindent and (Length(HL^.BlockBegStr) >
    0) and (Length(HL^.BlockEndStr) > 0);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoBlockIndentEnterKey;
var
  X, Y: integer;
  s: string;
  i: integer;
  OldLine: string;
  NewLine: string;
  BegBlockStr: string;
  EndBlockStr: string;
  RightMarker: string;
  OldLineLen: integer;
  HL: pTHighlighter;
  IndentString: string;
  IndentSize: integer;
begin
  GetCursorPos(X, Y);

  if FileTypeSuitableForBlockIndent(HL) and (Y > 0) then
  begin
    OldLine := TrimRight(memo.Lines[Y - 1]);
    NewLine := memo.Lines[Y];
    OldLineLen := Length(OldLine);
    BegBlockStr := UpperCase(HL^.BlockBegStr);
    EndBlockStr := UpperCase(HL^.BlockEndStr);
    RightMarker := Copy(OldLine, OldLineLen - Length(BegBlockStr) + 1,
      Length(BegBlockStr));

    //////////////////////////////////

    if (OldLineLen > 0) and (UpperCase(RightMarker) = BegBlockStr) then
    begin
      s := Q_TabsToSpaces(OldLine, EditorCfg.TabWidth);
      i := 1;
      while ((i < Length(s)) and (s[i] = ' ')) do
        inc(i);
      IndentSize := i - 1;
      IndentString := StringOfChar(' ', IndentSize);

      if (UpperCase(TrimLeft(NewLine)) <> EndBlockStr) then
      begin
        if not (eoTabsToSpaces in EditorCfg.Options) and (eoTabIndent in
          EditorCfg.Options) and (EditorCfg.TabsMode = tmHardTabs) then
        begin
          IndentString := Q_SpacesToTabs(IndentString, EditorCfg.TabWidth) +
            #09;
        end
        else
          IndentString := IndentString + StringOfChar(' ', EditorCfg.C_BlockIndent);
      end;

      // ako smo lupili enter u sred reda pa se ne�to prenijelo dolje
      if (Length(NewLine) > 0) then
      begin
        memo.Lines[Y] := IndentString + TrimLeft(NewLine);
      end
      else
        memo.Lines[Y] := IndentString;

      SetCursorPos(Length(IndentString), Y);
    end;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoBlockUnindentEnterKey;
var
  X, Y: integer;
  newX: integer;
  BracesNum: integer;
  Line: string;
  LineLen: integer;
  LineNum: integer;
  BegBlockStr: string;
  EndBlockStr: string;
  RightMarker: string;
  HL: pTHighlighter;
  LineOK: boolean;
  IndentChar: char;
begin
  GetCursorPos(X, Y);

  if FileTypeSuitableForBlockIndent(HL) and (Y > 0) then
  begin
    BegBlockStr := UpperCase(HL^.BlockBegStr);
    EndBlockStr := UpperCase(HL^.BlockEndStr);
    Line := memo.Lines[Y];

    LineOK := (((Length(EndBlockStr) = 1) and (Length(TrimLeft(Line)) = 0)) or
      ((Length(EndBlockStr) > 1) and (Length(TrimLeft(Line)) -
      Length(EndBlockStr) = 0))) and
      ((Length(Trim(Line)) = 0) or (UpperCase(Trim(Line)) = EndBlockStr));

    if LineOK then
    begin
      BracesNum := 0;
      LineNum := Y - 1;
      while (LineNum >= 0) do
      begin
        Line := TrimRight(memo.Lines[LineNum]);
        LineLen := Length(Line);

        if (LineLen > 0) then
        begin
          RightMarker := UpperCase(Copy(Line, LineLen - Length(BegBlockStr) + 1,
            Length(BegBlockStr)));

          if (RightMarker = BegBlockStr) then
          begin
            if (BracesNum = 0) then
            begin
              newX := LineLen - Length(TrimLeft(Line));

              if (Length(EndBlockStr) = 1) then
              begin
                // ako nije "allow caret after EOL", ubacuje '}' na krivo mjesto
                if not (eoScrollPastEol in EditorCfg.Options) then
                begin
                  if not (eoTabsToSpaces in EditorCfg.Options) and (eoTabIndent
                    in EditorCfg.Options) and (EditorCfg.TabsMode = tmHardTabs) then
                    IndentChar := #09
                  else
                    IndentChar := ' ';

                  Line := TrimRight(memo.Lines[Y]);
                  while (Length(Line) < newX) do
                    Line := Line + IndentChar;

                  memo.Lines[Y] := Line;
                end;
              end
              else
              begin
                Line := TrimRight(memo.Lines[Y]);
                RightMarker := Copy(Line, Length(Line) - Length(EndBlockStr) +
                  1, Length(EndBlockStr));

                Line := '';
                while (Length(Line) < newX) do
                  Line := Line + ' ';
                Line := Line + RightMarker;
                memo.Lines[Y] := Line;
                inc(newX, Length(RightMarker));
              end;

              SetCursorPos(newX, Y);
              BREAK;
            end;
            dec(BracesNum);
          end
          else
          begin
            if (Length(EndBlockStr) = 1) and (RightMarker = EndBlockStr) then
              inc(BracesNum)
            else
            begin
              if (Length(EndBlockStr) > 1) then
              begin
                while (Length(Line) > 0) and (Pos(UpCase(Line[Length(Line)]),
                  EndBlockStr) = 0) do
                  SetLength(Line, Length(Line) - 1);
                RightMarker := UpperCase(Copy(Line, Length(Line) -
                  Length(EndBlockStr) + 1, Length(EndBlockStr)));

                if (RightMarker = EndBlockStr) then
                  inc(BracesNum);
              end;
            end;
          end;
        end;

        dec(LineNum);
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.IsTimeToBlockUnindent(PressedChar: char): boolean;
var
  HL: pTHighlighter;
  EndBlockStr: string;
  Line: string;
  RightMarker: string;
  X, Y: integer;
begin
  result := FALSE;
  if FileTypeSuitableForBlockIndent(HL) then
  begin
    EndBlockStr := UpperCase(HL^.BlockEndStr);

    if (EndBlockStr = PressedChar) then
    begin
      result := TRUE;
    end
    else
    begin
      GetCursorPos(X, Y);
      Line := memo.Lines[Y];
      RightMarker := UpperCase(Copy(Line, Length(Line) - Length(EndBlockStr) +
        1, Length(EndBlockStr)));

      result := (RightMarker = EndBlockStr) and (X >= Length(Line) - 1);
    end;
  end;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.PreparedToMatchBraces: boolean;
begin
  result := TRUE;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.MatchBraces;
begin
  if CharInSet(memo.GetCharAtCursor, ['(', '[', '{', '<', ')', ']', '}', '>']) then
    memo.CommandProcessor(ecMatchBracket, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SelectTextInBraces;
begin
  if CharInSet(memo.GetCharAtCursor, ['(', '[', '{', '<', ')', ']', '}', '>']) then
    memo.CommandProcessor(ecSelTextInBraces, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoSelectTextInBraces;
var
  blockbeg: TBufferCoord;
  blockend: TBufferCoord;
begin
  blockbeg := memo.CaretXY;
  memo.CommandProcessor(ecMatchBracket, #0, nil);
  blockend := memo.CaretXY;

  if (blockbeg.Line < blockend.Line) or (blockbeg.Char < blockend.Char) then
  begin
    memo.BlockBegin := BufferCoord(blockbeg.Char + 1, blockbeg.Line);
    memo.BlockEnd := blockend;
  end
  else
  begin
    memo.BlockBegin := blockbeg;
    memo.BlockEnd := BufferCoord(blockend.Char + 1, blockend.Line);
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoInsertTimeStamp;
begin
  memo.SelText := DateTimeToStr(Now);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoSelectAllColumnar;
var
  MaxLineLen: integer;
begin
  MaxLineLen := TSynEditStringList(memo.Lines).LengthOfLongestLine;
  memo.BlockBegin := BufferCoord(0, 0);
  memo.BlockEnd := BufferCoord(MaxLineLen + 1, memo.Lines.Count);
  memo.CaretXY := memo.BlockEnd;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DefineUserCommands;

  procedure AddKey(const ACmd: TSynEditorCommand; const AKey: word;
    const AShift: TShiftState);
  begin
    with memo.Keystrokes.Add do
    begin
      Key := AKey;
      Shift := AShift;
      Command := ACmd;
    end;
  end;

begin
  AddKey(ecLoCase, VK_F5, [ssCtrl]);
  AddKey(ecUpCase, VK_F5, [ssAlt]);
  AddKey(ecToggleCase, VK_F5, []);
  AddKey(ecGoToLine, word('G'), [ssCtrl]);
  AddKey(ecReformatParagraph, word('B'), [ssCtrl]);
  AddKey(ecToggleSelectionMode, word('L'), [ssCtrl]);
  AddKey(ecFind, word('F'), [ssCtrl]);
  AddKey(ecFindNext, VK_F3, []);
  AddKey(ecFindPrevious, VK_F3, [ssShift]);
  AddKey(ecSortBlock, VK_F2, [ssShift]);
  AddKey(ecFillBlock, word('I'), [ssCtrl]);
  AddKey(ecAutoCompletion, word('J'), [ssCtrl]);
  AddKey(ecToggleCommentBlock, word('C'), [ssCtrl, ssShift]);
  AddKey(ecSelTextInBraces, word('M'), [ssCtrl, ssShift]);
  AddKey(ecInsertTimeStamp, word('T'), [ssCtrl, ssShift]);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ApplyRulerSettings;
begin
  if Assigned(fRuler) then
  begin
    fRuler.CharWidth := memo.CharWidth;
    fRuler.LeftIndent := memo.RowColumnToPixels(DisplayCoord(memo.LeftChar, 1)).X
      + 2;
    ;
    fRuler.CurrentX := memo.DisplayX;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoSort;
var
  str, str2: TStringList;
  selBegY, selEndY: integer;
  blockBeg, blockEnd: TBufferCoord;
  i: integer;
  X, Y: integer;

  procedure SelectNormalBlock;
  begin
    selBegY := blockBeg.Line - 1;
    selEndY := blockEnd.Line - 1;

    memo.BlockBegin := BufferCoord(1, blockBeg.Line);
    memo.BlockEnd := blockEnd;

    if (blockEnd.Char < 2) then
      dec(selEndY)
    else
    begin
      if (memo.Lines.Count < blockEnd.Line + 1) then
      begin
        memo.Lines.Add('');
        memo.BlockBegin := BufferCoord(1, blockBeg.Line);
      end;
      memo.BlockEnd := BufferCoord(1, blockEnd.Line + 1);
    end;
  end;

begin
  if not memo.SelAvail then
    EXIT;
  if Locked then
    EXIT;

  blockBeg := memo.BlockBegin;
  blockEnd := memo.BlockEnd;
  GetCursorPos(X, Y);

  str := TStringList.Create;

  try
    case memo.SelectionMode of
      smNormal, smLine:
        begin
          SelectNormalBlock;

          for i := selBegY to selEndY do
            str.Add(memo.Lines[i]);
          str.Sort;

          memo.SelText := str.Text;
        end;
      smColumn:
        begin
          str.Text := memo.SelText;

          memo.SelectionMode := smNormal;
          SelectNormalBlock;

          for i := selBegY to selEndY do
            str.Objects[i - selBegY] := pointer(i);
          str.Sort;

          str2 := TStringList.Create;
          try
            for i := 0 to str.Count - 1 do
              str2.Add(memo.Lines[integer(str.Objects[i])]);

            memo.SelText := str2.Text;
            memo.SelectionMode := smColumn;
          finally
            str2.Free;
          end;
        end;
    end;
  finally
    str.Free;
  end;

  memo.BlockBegin := blockBeg;
  memo.BlockEnd := blockEnd;
  SetCursorPos(X, Y);
end;
//------------------------------------------------------------------------------------------

function TfmEditor.FillBlock(ptr: pointer): pointer;
var
  blockBeg, blockEnd: TBufferCoord;
  X, Y: integer;
  i: integer;
  pattern: string;
  str: TStringList;
  s: string;
  fillstring: string;
  last_line: boolean;
  rec: pTMacroCmdFill;
begin
  result := nil;

  if (memo.SelectionMode <> smColumn) or not memo.SelAvail then
    EXIT;

  if not Assigned(ptr) then
  begin
    fillstring := '';
    if not InputQuery(mlStr(ML_FILLBLOCK_CAPT, 'Fill block'),
      mlStr(ML_FILLBLOCK_TEXT, 'Enter text to fill selected block with:'),
      fillstring) then
      EXIT;
  end
  else
    fillstring := string(pTMacroCmdFill(ptr).Str);

  if (Length(fillstring) > 0) then
  begin
    GetCursorPos(X, Y);
    blockBeg := memo.BlockBegin;
    blockEnd := memo.BlockEnd;

    // pro�iri selekciju
    memo.SelectionMode := smNormal;
    memo.BlockBegin := BufferCoord(1, blockBeg.Line);

    last_line := (blockEnd.Line >= memo.Lines.Count);

    if not last_line then
      memo.BlockEnd := BufferCoord(1, blockEnd.Line + 1)
    else
      memo.BlockEnd := BufferCoord(Length(memo.Lines[blockEnd.Line - 1]) + 1,
        blockEnd.Line);

    str := TStringList.Create;
    try
      str.Text := memo.SelText;
      // definiraj pattern
      pattern := '';
      repeat
        pattern := pattern + fillstring;
      until (Length(pattern) >= Abs(blockEnd.Char - blockBeg.Char));
      SetLength(pattern, Abs(blockEnd.Char - blockBeg.Char));

      if (str.Count = 0) then
        str.Add('');

      for i := 0 to str.Count - 1 do
      begin
        s := str[i];
        while (Length(s) < Min(blockBeg.Char, blockEnd.Char) - 1) do
          s := s + ' ';

        Delete(s, Min(blockBeg.Char, blockEnd.Char), Length(pattern));
        Insert(pattern, s, Min(blockBeg.Char, blockEnd.Char));

        str[i] := s;
      end;

      if not last_line then
        memo.SelText := str.Text
      else
        memo.SelText := Copy(str.Text, 1, Length(str.Text) - 2);

      // vrati selekciju
      SetCursorPos(X, Y);
      memo.SelectionMode := smColumn;
      memo.BlockBegin := blockBeg;
      memo.BlockEnd := blockEnd;
    finally
      str.Free;
    end;

    if MacroIsRecording then
    begin
      rec := AllocMacroCmdData(mdtFill);
      rec^.Str := ShortString(fillstring);
      result := rec;
    end
    else
      result := nil;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoRemoveTrailingSpaces;
begin
  Modified := memo.RemoveTrailingSpaces or Modified;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoConvertTabsAndSpaces(Conversion: TTabsConversion);
var
  s: string;
begin
  s := IntToStr(EditorCfg.TabWidth);

  if InputQuery(mlStr(ML_TAB_CONVERSION_CAPTION, 'Tab Conversion'),
    mlStr(ML_TAB_CONVERSION_QUERY, 'Tab width:'), s) then
    Modified := memo.ConvertTabsAndSpaces(Conversion, StrToIntDef(s,
      EditorCfg.TabWidth)) or Modified;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoRemoveComments;
begin
  SetLengthyOperation(TRUE);
  try
    Modified := memo.RemoveComments or Modified;
  finally
    SetLengthyOperation(FALSE);
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RemoveTrailingSpaces;
begin
  memo.CommandProcessor(ecRemoveTrailingSpaces, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ConvertSpacesToTabs;
begin
  memo.CommandProcessor(ecConvertSpacesToTabs, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RemoveComments;
begin
  memo.CommandProcessor(ecRemoveComments, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ConvertTabsToSpaces;
begin
  memo.CommandProcessor(ecConvertTabsToSpaces, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ToggleCommentBlock;
type
  TSelTyp = (tsOneLine, tsLines, tsAnchor);
var
  cbeg, cend: string;
  HL: pTHighlighter;
  i: integer;
  s: string;
  blockBeg, blockEnd: TBufferCoord;
  X, Y: integer;
  do_comment: boolean;
  sel_typ: TSelTyp;
  dX: integer;
  str: TStringList;
  has_block_comment: boolean;
  cbeg_len: integer;
  cend_len: integer;
  strBegComment, strEndComment, strLineComment: TStringList;
  CommentBegStr, CommentEndStr: string;
  CommentLineStr: string;

  function InsertBegComment(s: string): string;
  begin
    result := cbeg + ' ' + s;
  end;

  function InsertEndComment(s: string): string;
  begin
    if (cend_len > 0) then
      result := s + ' ' + cend
    else
      result := s;
  end;

  function CRLFAtEnd(s: string): boolean;
  var
    l: integer;
  begin
    l := Length(s);
    result := (l >= 2) and (s[l - 1] = #13) and (s[l] = #10);
  end;

  function RemoveBegComment(s: string): string;
  begin
    if (Pos(cbeg, UpperCase(s)) = 1) then
    begin
      cbeg_len := Length(cbeg);
      Delete(s, 1, cbeg_len);
      if (Length(s) > 0) and (s[1] = ' ') then
      begin
        Delete(s, 1, 1);
        inc(cbeg_len);
      end;
    end;
    result := s;
  end;

  function RemoveEndComment(s: string): string;
  var
    has_crlf: boolean;
  begin
    if (Length(cend) > 0) then
    begin
      cend_len := Length(cend);
      has_crlf := CRLFAtEnd(s);
      if has_crlf then
        SetLength(s, Length(s) - 2);
      if (UpperCase(Copy(s, Length(s) - cend_len + 1, cend_len)) = cend) then
      begin
        SetLength(s, Length(s) - cend_len);
        if (Length(s) > 0) and (s[Length(s)] = ' ') then
        begin
          SetLength(s, Length(s) - 1);
          inc(cend_len);
        end;
      end;
      if has_crlf then
        s := s + #13#10;
    end;
    result := s;
  end;

  function Calc_dX: integer;
  var
    dX: integer;
  begin
    dX := 0;
    case sel_typ of
      tsOneLine:
        dX := cbeg_len;
      tsAnchor:
        begin
          if (blockBeg.Line = blockEnd.Line) then
            dX := cbeg_len + cend_len
          else
            dX := cend_len;
        end;
      tsLines:
        dX := 0;
    end;

    if not do_comment then
      dX := -dX;

    result := dX;
  end;

begin
  HL := GetHighlighterRec(memo.Highlighter);
  if not Assigned(HL) then
    EXIT;

  strBegComment := TStringList.Create;
  strEndComment := TStringList.Create;
  strLineComment := TStringList.Create;

  StrToStrings(HL^.CommentBegStr, ' ', strBegComment);
  StrToStrings(HL^.CommentEndStr, ' ', strEndComment);
  StrToStrings(HL^.CommentLineStr, ' ', strLineComment);

  if ((strBegComment.Count > 0) and (strEndComment.Count > 0)) or
    (strLineComment.Count > 0) then
  begin
    SetLengthyOperation(TRUE);

    if (strBegComment.Count > 0) and (strEndComment.Count > 0) then
    begin
      CommentBegStr := strBegComment[0];
      CommentEndStr := strEndComment[0];
    end
    else
    begin
      CommentBegStr := '';
      CommentEndStr := '';
    end;

    if (strLineComment.Count > 0) then
      CommentLineStr := strLineComment[0]
    else
      CommentLineStr := '';

    GetCursorPos(X, Y);

    blockBeg := memo.BlockBegin;
    blockEnd := memo.BlockEnd;

    // pro�iri selekciju
    memo.SelectionMode := smNormal;

    // skuzi tip selekcije
    if memo.SelAvail then
    begin
      s := memo.SelText;
      if CRLFAtEnd(s) then
        sel_typ := tsLines
      else
        sel_typ := tsAnchor;
    end
    else
    begin
      s := memo.LineText;
      sel_typ := tsOneLine;
    end;

    case sel_typ of
      tsOneLine, tsLines:
        begin
          if (Length(CommentLineStr) > 0) then
            cbeg := CommentLineStr
          else
          begin
            cbeg := CommentBegStr;
            cend := CommentEndStr;
          end;
        end;
      tsAnchor:
        begin
          if (Length(CommentBegStr) > 0) then
          begin
            cbeg := CommentBegStr;
            cend := CommentEndStr;
          end
          else
            cbeg := CommentLineStr;
        end;
    end;

    cbeg := UpperCase(cbeg);
    cend := UpperCase(cend);
    cbeg_len := Length(cbeg);
    cend_len := Length(cend);

    do_comment := not (Pos(cbeg, s) = 1);
    has_block_comment := Length(cend) > 0;

    if do_comment then
    begin
      // inkrementiramo jer dodajemo i spejsove
      inc(cbeg_len);
      if (cend_len > 0) then
        inc(cend_len);

      case sel_typ of
        tsOneLine:
          begin
            s := InsertBegComment(s);
            s := InsertEndComment(s);
          end;
        tsAnchor, tsLines:
          begin
            str := TStringList.Create;
            if CRLFAtEnd(s) then
              SetLength(s, Length(s) - 2);
            str.Text := s;

            if (sel_typ = tsLines) then
            begin
              while (str.Count < blockEnd.Line - blockBeg.Line) do
                str.Add('');
            end;

            if has_block_comment then
            begin
              if (str.Count > 0) then
              begin
                str[0] := InsertBegComment(str[0]);
                str[str.Count - 1] := InsertEndComment(str[str.Count - 1]);
              end;
            end
            else
            begin
              for i := 0 to str.Count - 1 do
                str[i] := InsertBegComment(str[i]);
            end;

            if (sel_typ = tsAnchor) then
            begin
              if CRLFAtEnd(str.Text) then
                s := Copy(str.Text, 1, Length(str.Text) - 2)
              else
                s := str.Text;
            end
            else
              s := str.Text;
            str.Free;
          end;
      end;
    end
    else
    begin
      case sel_typ of
        tsOneLine:
          begin
            s := RemoveBegComment(s);
            s := RemoveEndComment(s);
          end;
        tsAnchor, tsLines:
          begin
            str := TStringList.Create;
            if CRLFAtEnd(s) then
              SetLength(s, Length(s) - 2);
            str.Text := s;

            for i := 0 to str.Count - 1 do
            begin
              str[i] := RemoveBegComment(str[i]);
              str[i] := RemoveEndComment(str[i]);
            end;

            if (sel_typ = tsAnchor) then
            begin
              if CRLFAtEnd(str.Text) then
                s := Copy(str.Text, 1, Length(str.Text) - 2)
              else
                s := str.Text;
            end
            else
              s := str.Text;
            str.Free;
          end;
      end;
    end;

    dX := Calc_dX;

    if (sel_typ in [tsLines, tsAnchor]) then
    begin
      memo.SelText := s;
      memo.BlockBegin := blockBeg;
      memo.BlockEnd := BufferCoord(blockEnd.Char + dX, blockEnd.Line);
    end
    else
    begin
      memo.BlockBegin := BufferCoord(1, Y + 1);
      memo.BlockEnd := BufferCoord(Length(memo.LineText) + 1, Y + 1);
      memo.SelText := s;
      SetCursorPos(X + dX, Y);
    end;

    SetCursorPosNice;
    SetLengthyOperation(FALSE);
  end;

  strBegComment.Free;
  strEndComment.Free;
  strLineComment.Free;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.InsertFileAtCurrentPosition(fname: string): boolean;
var
  str: TStringList;
  i: integer;
  ok: boolean;
begin
  SetLengthyOperation(TRUE);
  ok := FALSE;
  str := TStringList.Create;
  try
    try
      str.LoadFromFile(fname);

      if (EditorCfg.TabsMode = tmTabsToSpaces) then
        for i := 0 to str.Count - 1 do
          str[i] := ConvertTabs(str[i], EditorCfg.TabWidth);

      memo.SelText := str.Text;
      SetCursorPosNice;
      ok := TRUE;
    except
    end;
  finally
    str.Free;
  end;
  result := ok;
  SetLengthyOperation(FALSE);
end;
//------------------------------------------------------------------------------------------

function TfmEditor.AppendFile(fname: string): boolean;
var
  str: TStringList;
  i: integer;
  ok: boolean;
begin
  SetLengthyOperation(TRUE);
  ok := FALSE;
  str := TStringList.Create;
  try
    try
      str.LoadFromFile(fname);

      if (EditorCfg.TabsMode = tmTabsToSpaces) then
        for i := 0 to str.Count - 1 do
          str[i] := ConvertTabs(str[i], EditorCfg.TabWidth);

      memo.CommandProcessor(ecEditorBottom, #0, nil);
      if (memo.CaretX > 1) then
        memo.CommandProcessor(ecLineBreak, #0, nil);

      memo.SelText := str.Text;
      SetCursorPos(0, memo.Lines.Count - 1);
      SetCursorPosNice;
      ok := TRUE;
    except
    end;
  finally
    str.Free;
  end;
  result := ok;
  SetLengthyOperation(FALSE);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoCopyFilenameToClipboard;
begin
  if CopyFilenameToClipboardEnabled then
    Clipboard.SetTextBuf(PChar(fFileName));
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.CopyFilenameToClipboard;
begin
  memo.CommandProcessor(ecCopyFilenameToClipboard, #0, nil);
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                               Find/replace functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

function TfmEditor.FindAllOccurences(const ASearch: string; AOptions:
  TSynSearchOptions): boolean;
var
  i, ii: integer;
  SearchEngine: TSynEditSearchCustom;
  s: string;
  res: TFindTextResult;
begin
  result := FALSE;

  try
    SearchEngine := memo.SearchEngine;
    SearchEngine.Options := AOptions;
    SearchEngine.Pattern := ASearch;

    for i := 0 to memo.Lines.Count - 1 do
    begin
      s := memo.Lines[i];
      if (SearchEngine.FindAll(s) > 0) then
      begin
        for ii := 0 to SearchEngine.ResultCount - 1 do
        begin
          res := TFindTextResult.Create(fFileName, s,
            BufferCoord(SearchEngine.Results[ii], i), SearchEngine.Lengths[ii]);
          fmBottomWindowContainer.SearchResults.Add(res);

          //          found_text:=Copy(s, SearchEngine.Results[ii], SearchEngine.Lengths[ii]);
          //          fmMain.pnFound.Add(SELF, BufferCoord(SearchEngine.Results[ii]+1, i+1), s, found_text);
          result := TRUE;
        end;
        fmBottomWindowContainer.SearchResults.Repaint;
      end;
    end;
  finally
  end;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.GetExtWordUnderCursor(select: boolean; var word_beg,
  word_end: integer): string;
var
  s, ss: string;
  X, Y: integer;
begin
  GetCursorPos(X, Y);
  s := memo.Lines[Y];
  ss := '';
  word_beg := 0;

  if (X <= Length(s)) then
  begin
    while (X > 0) and (Pos(s[X], MEMO_SEPARATORS) = 0) do
      dec(X);
    inc(X);
    word_beg := X;
    while (X <= Length(s)) and (Pos(s[X], MEMO_SEPARATORS) = 0) do
    begin
      ss := ss + s[X];
      inc(X);
    end;
  end;

  word_end := word_beg + Length(ss);

  if select and (Length(ss) > 0) then
  begin
    memo.BlockBegin := BufferCoord(word_end, Y + 1);
    memo.BlockEnd := BufferCoord(memo.BlockBegin.Char + (word_beg - word_end), Y
      + 1);
  end;

  result := ss;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.GetWordUnderCursor: string;
var
  word_beg, word_end: integer;
begin
  result := GetExtWordUnderCursor(FALSE, word_beg, word_end);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.RemoveSelection;
begin
  memo.SelLength := 0;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.DoFind(ptr: pointer): PChar;
var
  rec: pTMacroCmdFind;
begin
  result := nil;
  fmFind.editor := SELF;
  fmFind.replace_dlg := FALSE;

  if not fmMain.Macros.Playing then
  begin
    fmFind.ShowModal;

    if MacroIsRecording and (fmFind.modal_result <> mrCancel) then
    begin
      rec          := AllocMacroCmdData(mdtFindReplace);
      rec^.StrFind := ShortString(fmFind.LastSearchString);
      rec^.Cfg     := fmFind.FindCfg;
      result       := pointer(rec);
    end;
  end
  else
  begin
    fmFind.F3_find := TRUE;
    if Assigned(ptr) then
    begin
      rec := pTMacroCmdFind(ptr);
      fmFind.cbFind.Text := String(rec^.StrFind);
      fmFind.FindCfg     := rec^.Cfg;
      fmFind.DoFindNext(rec^.Cfg.Direction);
    end;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoFindNext(Direction: TFindDirection);
begin
  with fmFind do
  begin
    editor := SELF;
    F3_find := TRUE;
    replace_dlg := FALSE;

    FindCfg.Origin := foFromCursor;
    FindCfg.Scope := fsCurrentFile;
    FindCfg.Direction := Direction;
    FindCfg.RegExp := UseRegExp;
  end;

  if (fmFind.LastSearchString <> '') then
    fmFind.DoFindNext(Direction)
  else
    DoFind(nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.Replace;
begin
  if Locked then
    EXIT;

  fmFind.editor := SELF;
  fmFind.replace_dlg := TRUE;
  fmFind.ShowModal;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                   Edit Functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

function TfmEditor.SelAvail: boolean;
begin
  result := memo.SelAvail;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.CutEnabled: boolean;
begin
  result := SelAvail and not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.CopyEnabled: boolean;
begin
  result := SelAvail;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.PasteEnabled: boolean;
begin
  result := Clipboard.HasFormat(CF_TEXT) and not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.DeleteEnabled: boolean;
begin
  result := SelAvail and not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.SortTextEnabled: boolean;
begin
  result := SelAvail and not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.UndoEnabled: boolean;
begin
  result := memo.CanUndo and not fLocked;
end;
//------------------------------------------------------------------------------------------

function TfmEditor.RedoEnabled: boolean;
begin
  result := memo.CanRedo and not fLocked;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.CopySelection;
begin
  memo.CommandProcessor(ecCopy, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.CutSelection;
begin
  memo.CommandProcessor(ecCut, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DeleteSelection;
begin
  memo.CommandProcessor(ecDeleteChar, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoFillBlockDialog;
begin
  memo.CommandProcessor(ecFillBlock, #0, nil);
end;
//------------------------------------------------------------------------------------------

function TfmEditor.FillBlockEnabled: boolean;
begin
  result := not fLocked and SelAvail and (memo.SelectionMode = smColumn);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.PasteSelection;
begin
  if Assigned(fIncrementalSearchPanel) then
    fIncrementalSearchPanel.PasteFromClipboard
  else
    memo.CommandProcessor(ecPaste, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.SelectAll;
begin
  memo.CommandProcessor(ecSelectAll, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.Sort;
begin
  memo.CommandProcessor(ecSortBlock, #0, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.Find;
begin
  memo.CommandProcessor(ecFind, #00, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FindNext;
begin
  memo.CommandProcessor(ecFindNext, #00, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FindPrevious;
begin
  memo.CommandProcessor(ecFindPrevious, #00, nil);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.DoIncrementalSearchDialog;
begin
  if not Assigned(fIncrementalSearchPanel) then
  begin
    fIncrementalSearchPanel := TIncrementalSearchPanel.Create(dockBottom, SELF);
    with fIncrementalSearchPanel do
    begin
      Parent := dockBottom;
    end;
  end
  else
    FreeAndNil(fIncrementalSearchPanel);
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                  Functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.RefreshCaption;
var
  s: string;
  attr: string;
begin
  attr := '';
  if Modified then
    attr := attr + '*';
  if Locked then
    attr := attr + '#';

  if (Length(attr) > 0) then
    attr := ' ' + attr;
  s := FileName + attr;

  s := s + GetReadOnlyString;

  Caption := s;
  fmMain.RenameTab(SELF, s);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.UpdateTimes;
begin
  FileAge(FileName, FileTime);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.CheckFileTime;
type
  TFileState = (fsNormal, fsChanged, fsDeleted);
var
  FileState: TFileState;
  dNewFileTime: TDateTime;
const
  already_showing: boolean = FALSE;
begin
  if NewFile then
  begin
    already_showing := FALSE;
    EXIT;
  end;

  if already_showing then
    EXIT;

  FileState := fsNormal;
  CheckIsReadOnly;

  if not FileExists(FileName) then
    FileState := fsDeleted
  else
  begin
    FileAge(FileName, dNewFileTime);
    if FileTime <> dNewFileTime then
      FileState := fsChanged;
  end;

  // napravimo mali delay jer izgleda da TMainInstance, MessageDlg i Application.OnActivate
     // ne sura�uju ba� najbolje kad se dogode u istom trenutku
//  Sleep(50);

  case FileState of
    fsNormal: ;
    fsChanged:
      if not EnvOptions.AutoUpdateChangedFiles then
      begin
        already_showing := TRUE;
        if (MessageDlg(Format(mlStr(ML_EDIT_WARN_FILE_CHANGED,
          'File ''%s'' has been changed. Reload from disk?'), [FileName]),
          mtWarning, [mbYes, mbNo], 0) = mrYes) then
          Reload;
      end
      else
        Reload;
    fsDeleted:
      begin
        already_showing := TRUE;
        case MessageDlg(Format(mlStr(ML_EDIT_WARN_FILE_CHANGED,
          'File ''%s'' has been deleted. Keep file in editor?'), [FileName]),
          mtWarning, [mbYes, mbNo], 0) of
          mrYes:
            begin
              Modified := TRUE;
              NewFile := TRUE;
              fKeepedUnexistedFile := TRUE;
            end;
          mrNo:
            begin
              Modified := FALSE;
              Close;
            end;
        end;
      end;
  end;

  already_showing := FALSE;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.CheckCurrentLineForWordwrap;
var
  i: integer;
  X, Y: integer;
  dX: integer;
  s: string;
begin
  if not EditorCfg.RightEdgeVisible then
    EXIT;

  GetCursorPos(X, Y);
  if (X <= EditorCfg.RightEdge) then
    EXIT;

  // napravi wordwrap
  s := memo.Lines[memo.CaretY - 1];
  i := X;

  while (i > 0) and (Pos(s[i], MEMO_SEPARATORS) = 0) do
    dec(i);

  if (i = 0) then
    EXIT;

  dX := X - i;

  SetCursorPos(i, Y);
  memo.CommandProcessor(ecLineBreak, #13, nil);
  GetCursorPos(X, Y);
  SetCursorPos(X + dX, Y);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.ShellExecFile;
begin
  if Modified and not Save then
    EXIT;

  ShellExecuteExternalFile(FileName);
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                  Memo events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoChange(Sender: TObject);
begin
  Modified := TRUE;
  DefaultEmptyFile := FALSE;
  AdjustGutterLinesWidth;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoProcessCommand(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  case Command of
    ecInsertMode, ecOverwriteMode, ecToggleMode:
      RefreshInsertOverwrite(not memo.InsertMode);
    ecTab:
      if (memo.SelAvail) then
      begin
        Command := ecNone;
        memo.CommandProcessor(ecBlockIndent, #0, nil);
      end;
    ecShiftTab:
      if (memo.SelAvail) then
      begin
        Command := ecNone;
        memo.CommandProcessor(ecBlockUnindent, #0, nil);
      end;
    ecChar, ecLineBreak:
      begin
        if (not CharInSet(AChar, ['a'..'z', 'A'..'Z'])) and IsTimeToBlockUnindent(AChar) then
          DoBlockUnindentEnterKey;
        fNewLineInserted := (Command = ecLineBreak);
      end;
    ecAutoCompletion:
      begin
        // provjerimo AChar da se ne zavrtimo u petlji, ja postavljam AChar u nekom trenutku
        if (AChar = #00) and CT_ShouldPopup then
        begin
          CT_ShowWindow;
          Command := ecNone;
        end;
      end;
    ecMatchBracket:
      if not PreparedToMatchBraces then
        Command := ecNone;
    ecSelectAll:
      if (memo.SelectionMode = smColumn) then
      begin
        DoSelectAllColumnar;
        Command := ecNone;
      end;
  end;

  if (Command <> ecNone) and Assigned(fmMain.Macros) then
    fmMain.Macros.AddMacroCommand(SELF, Command, AChar, Data);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoProcessUserCommand(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  case Command of
    ecGoToLine:
      GoToLineDialog;
    ecReformatParagraph:
      ReformatParagraph;
    ecToggleSelectionMode:
      DoToggleSelectionMode;
    ecFind:
      begin
        Data := DoFind(Data);
        if MacroIsRecording and not Assigned(Data) then
          Command := ecNone;
      end;
    ecFindNext:
      DoFindNext(fdNext);
    ecFindPrevious:
      DoFindNext(fdPrev);
    ecSortBlock:
      DoSort;
    ecFillBlock:
      begin
        Data := FillBlock(Data);
        if MacroIsRecording and not Assigned(Data) then
          Command := ecNone;
      end;
    ecRemoveTrailingSpaces:
      DoRemoveTrailingSpaces;
    ecToggleCommentBlock:
      ToggleCommentBlock;
    ecSelTextInBraces:
      DoSelectTextInBraces;
    ecInsertTimeStamp:
      DoInsertTimeStamp;
    ecCopyFilenameToClipboard:
      DoCopyFilenameToClipboard;
    ecConvertSpacesToTabs:
      DoConvertTabsAndSpaces(tcSpacesToTabs);
    ecConvertTabsToSpaces:
      DoConvertTabsAndSpaces(tcTabsToSpaces);
    ecRemoveComments:
      DoRemoveComments;
  end;

  if (Command <> ecNone) and Assigned(fmMain.Macros) then
    fmMain.Macros.AddMacroCommand(SELF, Command, AChar, Data);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoCommandProcessed(Sender: TObject;
  var Command: TSynEditorCommand; var AChar: Char; Data: Pointer);
begin
  case Command of
    ecChar:
      if (AChar <> ' ') then
        CheckCurrentLineForWordwrap;
    ecUndo:
      Modified := memo.CanUndo;
    ecLineBreak:
      DoBlockIndentEnterKey;
    ecDeleteLastChar..ecClearAll, ecInsertLine:
      AdjustGutterLinesWidth;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoStatusChange(Sender: TObject;
  Changes: TSynStatusChanges);
begin
  if (scCaretY in Changes) and not (memo.SelAvail or fNewLineInserted or
    memo.DisableAutoTrimLine) then
    memo.TrimLine(fPreviousCaretY);

  fNewLineInserted := FALSE;

  if (scSelection in Changes) then
    RefreshSelectionMode;

  if Assigned(memo.OnSpecialLineColors) and (memo.CaretY <> fPreviousCaretY) then
  begin
    memo.InvalidateLine(fPreviousCaretY);
    memo.InvalidateLine(memo.CaretY);
  end;

  if (memo.CaretY <> fPreviousCaretY) then
    fPreviousCaretY := memo.CaretY;

  WriteStatus(STAT_XY_PANEL, Format('Ln %d, Col %d', [memo.CaretXY.Line,
    memo.CaretXY.Char]));

  if Assigned(fRuler) then
  begin
    fRuler.CurrentXOffset := memo.LeftChar - 1;
    //    if (scLeftChar in Changes) then
    //      fRuler.CurrentXOffset:=memo.LeftChar;
    if (scCaretX in Changes) then
      fRuler.CurrentX := memo.DisplayX;
  end;

  RefreshSelectionStatusPanelMessage;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoDropFiles(Sender: TObject; X, Y: Integer;
  Files: TStrings);
begin
  fmMain.OpenMultipleFiles(Files);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoSpecialLineColors(Sender: TObject; Line: Integer;
  var Special: Boolean; var FG, BG: TColor);
var
  HL: TSynHighlighterAttributes;
begin
  if (Line = memo.CaretY) and not memo.SelAvail then
  begin
    Special := TRUE;
    if Assigned(memo.Highlighter) then
    begin
      HL := memo.Highlighter.Attribute[FindAttrIndex(ATTR_CURRENT_LINE_STR,
        memo.Highlighter)];
      FG := HL.Foreground;
      BG := HL.Background;
    end;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoKeyPress(Sender: TObject; var Key: Char);
begin
  if EditorCfg.HideMouseWhenTyping and (memo.Cursor <> crNone) then
    memo.Cursor := crNone;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  XY: TDisplayCoord;
begin
  if (Button = mbLeft) and (memo.Gutter.Visible) and (X < memo.Gutter.Width) then
  begin
    XY := memo.PixelsToRowColumn(X, Y);
    fMouseDownOnGutter := TRUE;
    fMouseDownOnGutterY := XY.Row;
  end
  else
    fMouseDownOnGutter := FALSE;

  MovingRightEdge := MouseOverRightEdge(X, Y);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  right_edge_X: integer;
begin
  // pokazivanje skrivenog pointera kod tipkanja
  if (memo.Cursor = crNone) then
    memo.Cursor := crIBeam;

  if MovingRightEdge then
  begin
    TMyEdit(memo).MouseCapture := FALSE;
    right_edge_X := memo.PixelsToRowColumn(X, Y).Column - 1;
    if (right_edge_X > 3) then
    begin
      EditorCfg.RightEdge := right_edge_X;
      UpdateAllEditorsRightEdge(right_edge_X);
      UpdateRightEdgeMovingHint;
      OptionsChanged := TRUE;
    end;
  end;

  // detekcija jel pointer iznad desne margine
  if not MovingRightEdge then
    if MouseOverRightEdge(X, Y) then
      memo.Cursor := crHSplit
    else
      memo.Cursor := crIBeam;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  XY: TDisplayCoord;
  MaxLineLen: integer;
begin
  MovingRightEdge := FALSE;

  XY := memo.PixelsToRowColumn(X, Y);
  if fMouseDownOnGutter and (fMouseDownOnGutterY = XY.Row) then
  begin
    fMouseDownOnGutterY := XY.Row;
    fMouseDownOnGutter := FALSE;
    memo.LeftChar := 1;
    memo.CaretXY := BufferCoord(1, memo.CaretXY.Line);
    memo.BlockBegin := BufferCoord(1, memo.CaretXY.Line);

    MaxLineLen := TSynEditStringList(memo.Lines).LengthOfLongestLine;

    if memo.CaretXY.Line = memo.Lines.Count then
      memo.BlockEnd := BufferCoord(MaxLineLen + 1, memo.CaretXY.Line)
    else
      memo.BlockEnd := BufferCoord(1, memo.CaretXY.Line + 1);

  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoPaintTransient(Sender: TObject; Canvas: TCanvas;
  TransientType: TTransientType);

  function CharToPixels(P: TBufferCoord): TPoint;
  begin
    Result := memo.RowColumnToPixels(memo.BufferToDisplayPos(P));
  end;

var
  Token: string;
  Start, TokenType: Integer;
  Attri: TSynHighlighterAttributes;
  n: integer;
  HTMLBraces: boolean;
type
  TTestPos = (tpOpening, tpClosing);

const
  OpenChars: array[0..2] of Char = ('{', '[', '(');
  CloseChars: array[0..2] of Char = ('}', ']', ')');
  OpenCharsHTML: array[0..3] of Char = ('{', '[', '(', '<');
  CloseCharsHTML: array[0..3] of Char = ('}', ']', ')', '>');

  function GetMatchingBracketEx(APoint: TBufferCoord; AdjustForTabs: Boolean):
      TBufferCoord;
  const
    Brackets: array[0..7] of char = ('(', ')', '[', ']', '{', '}', '<', '>');

    procedure AdjustPosForTabs(var XPos: Integer; YPos: Integer);
    var
      i: Integer;
      TmpStr: string;
    begin
      TmpStr := Copy(memo.Lines[YPos - 1], 1, XPos);
      i := pos(TSynTabChar, TmpStr);
      while i > 0 do
      begin
        inc(XPos, (memo.TabWidth - 1));
        TmpStr := Copy(TmpStr, i + 1, length(TmpStr));
        i := pos(TSynTabChar, TmpStr);
      end;
    end;

  var
    Line: string;
    i, PosX, PosY, Len: integer;
    Test, BracketInc, BracketDec: char;
    NumBrackets: integer;
    dumbstr: string;
    attr: TSynHighlighterAttributes;
    p: TBufferCoord;
    isCommentOrString: boolean;
  begin
    result := BufferCoord(0, 0);
    // get char at caret
    PosX := APoint.Char;
    PosY := APoint.Line;
    Line := memo.LineText;
    if Length(Line) >= PosX then
    begin
      Test := Line[PosX];
      // is it one of the recognized brackets?
      for i := Low(Brackets) to High(Brackets) do
        if Test = Brackets[i] then
        begin
          // this is the bracket, get the matching one and the direction
          BracketInc := Brackets[i];
          BracketDec := Brackets[i xor 1]; // 0 -> 1, 1 -> 0, ...
          // search for the matching bracket (that is until NumBrackets = 0)
          NumBrackets := 1;
          if Odd(i) then
          begin
            repeat
              if (PosY < memo.TopLine) then
                EXIT;
              // search until start of line
              while PosX > 1 do
              begin
                Dec(PosX);
                Test := Line[PosX];
                p.Char := PosX;
                p.Line := PosY;
                if (Test = BracketInc) or (Test = BracketDec) then
                begin
                  if memo.GetHighlighterAttriAtRowCol(p, dumbstr, attr) then
                    isCommentOrString :=
                      (attr = memo.Highlighter.StringAttribute) or (attr =
                      memo.Highlighter.CommentAttribute)
                  else
                    isCommentOrString := false;
                  if (Test = BracketInc) and (not isCommentOrString) then
                    Inc(NumBrackets)
                  else if (Test = BracketDec) and (not isCommentOrString) then
                  begin
                    Dec(NumBrackets);
                    if NumBrackets = 0 then
                    begin
                      // matching bracket found, set caret and bail out
                      if AdjustForTabs then
                        AdjustPosForTabs(PosX, PosY);
                      Result := P;
                      exit;
                    end;
                  end;
                end;
              end;
              // get previous line if possible
              if PosY = 1 then
                break;
              Dec(PosY);
              Line := memo.Lines[PosY - 1];
              PosX := Length(Line) + 1;
            until FALSE;
          end
          else
          begin
            repeat
              if (PosY > memo.TopLine + memo.LinesInWindow) then
                EXIT;
              // search until end of line
              Len := Length(Line);
              while PosX < Len do
              begin
                Inc(PosX);
                Test := Line[PosX];
                p.Char := PosX;
                p.Line := PosY;
                if (Test = BracketInc) or (Test = BracketDec) then
                begin
                  if memo.GetHighlighterAttriAtRowCol(p, dumbstr, attr) then
                    isCommentOrString :=
                      (attr = memo.Highlighter.StringAttribute) or (attr =
                      memo.Highlighter.CommentAttribute)
                  else
                    isCommentOrString := false;
                  if (Test = BracketInc) and (not isCommentOrString) then
                    Inc(NumBrackets)
                  else if (Test = BracketDec) and (not isCommentOrString) then
                  begin
                    Dec(NumBrackets);
                    if NumBrackets = 0 then
                    begin
                      // matching bracket found, set caret and bail out
                      if AdjustForTabs then
                        AdjustPosForTabs(PosX, PosY);
                      Result := P;
                      exit;
                    end;
                  end;
                end;
              end;
              // get next line if possible
              if PosY = memo.Lines.Count then
                Break;
              Inc(PosY);
              Line := memo.Lines[PosY - 1];
              PosX := 0;
            until False;
          end;
          // don't test the other brackets, we're done
          break;
        end;
    end;
  end;

  procedure TestChars(A1, A2: array of char; TestPos: TTestPos);
  var
    i: integer;
    P1, P2: TPoint;
    C1, C2: TBufferCoord;
    FgAttr: integer;
    BrushColor: TColor;
    CurrentLineFg: TColor;
    CurrentLineBg: TColor;
    HL: TSynHighlighterAttributes;

    function SamePoint(P1, P2: TPoint): boolean;
    begin
      result := (P1.X = P2.X) and (P1.Y = P2.Y);
    end;

    function IsPointInSelection(Value: TBufferCoord): boolean;
    var
      ptBegin, ptEnd: TBufferCoord;
    begin
      with memo do
      begin
        ptBegin := BlockBegin;
        ptEnd := BlockEnd;
        if (Value.Line >= ptBegin.Line) and (Value.Line <= ptEnd.Line) and
          ((ptBegin.Line <> ptEnd.Line) or (ptBegin.Char <> ptEnd.Char)) then
        begin
          if SelectionMode = smLine then
            Result := TRUE
          else if (SelectionMode = smColumn) then
          begin
            if (ptBegin.Char > ptEnd.Char) then
              Result := (Value.Char >= ptEnd.Char) and (Value.Char <
                ptBegin.Char)
            else if (ptBegin.Char < ptEnd.Char) then
              Result := (Value.Char >= ptBegin.Char) and (Value.Char <
                ptEnd.Char)
            else
              Result := FALSE;
          end
          else
            Result := ((Value.Line > ptBegin.Line) or (Value.Char >=
              ptBegin.Char)) and
              ((Value.Line < ptEnd.Line) or (Value.Char < ptEnd.Char));
        end
        else
          Result := FALSE;
      end;
    end;

    procedure GetAttributeForPoint(P: TBufferCoord);
    begin
      if (TransientType = ttAfter) then
      begin

        if (memo.SelAvail) then
        begin
          if IsPointInSelection(P) then
            BrushColor := memo.SelectedColor.Background
          else
            BrushColor := memo.Highlighter.Attribute[FgAttr].Background;
        end
        else
        begin

          if ColorCurrentLine and (P.Line = memo.CaretY) then
          begin
            BrushColor := CurrentLineBg;

            if (eoSpecialLineDefaultFg in memo.Options) then
              memo.Canvas.Font.Color := Attri.Foreground
            else
              memo.Canvas.Font.Color := CurrentLineFg;
          end
          else
          begin
            BrushColor := memo.Highlighter.Attribute[FgAttr].Background;
            memo.Canvas.Font.Color := Attri.Foreground;
          end;
        end;

        memo.Canvas.Brush.Style := bsSolid;
        memo.Canvas.Font.Color := memo.Highlighter.Attribute[FgAttr].Foreground;
      end
      else
      begin

        if (memo.SelAvail) and IsPointInSelection(P) then
        begin
          BrushColor := memo.SelectedColor.Background;
          memo.Canvas.Font.Color := memo.SelectedColor.Foreground;
        end
        else
        begin
          if ColorCurrentLine and (P.Line = memo.CaretY) then
          begin
            BrushColor := CurrentLineBg;

            if (eoSpecialLineDefaultFg in memo.Options) then
              memo.Canvas.Font.Color := Attri.Foreground
            else
              memo.Canvas.Font.Color := CurrentLineFg;
          end
          else
          begin
            BrushColor := Attri.Background;
            memo.Canvas.Font.Color := Attri.Foreground;
          end;
        end;

      end;
    end;

  begin
    i := Low(A1);
    while (i <= High(A2)) do
    begin
      if (Token = A1[i]) then
      begin
        FgAttr := FindAttrIndex(ATTR_MATCHED_BRACES, memo.Highlighter);

        if (FgAttr > 0) then
        begin
          C2 := GetMatchingBracketEx(memo.CaretXY, FALSE);

          if (C2.Char > 0) and (C2.Line > 0) then
          begin
            memo.Canvas.Brush.Style := bsClear;
            memo.Canvas.Font.Assign(memo.Font);
            memo.Canvas.Font.Style := Attri.Style;

            BrushColor := memo.Canvas.Brush.Color;

            if ColorCurrentLine then
            begin
              HL :=
                memo.Highlighter.Attribute[FindAttrIndex(ATTR_CURRENT_LINE_STR,
                memo.Highlighter)];
              CurrentLineFg := HL.Foreground;
              CurrentLineBg := HL.Background;
            end;

            // prvi karakter
            C1 := memo.CaretXY;
            GetAttributeForPoint(C1);
            memo.Canvas.Brush.Color := BrushColor;
            P1 := CharToPixels(memo.CaretXY);
            if (P1.X > memo.Gutter.Width) then
              memo.Canvas.TextOut(P1.X, P1.Y, A1[i]);

            // drugi karakter
            GetAttributeForPoint(C2);
            P2 := CharToPixels(C2);
            memo.Canvas.Brush.Color := BrushColor;
            if (P2.X > memo.Gutter.Width) then
              memo.Canvas.TextOut(P2.X, P2.Y, A2[i]);

            EXIT;
          end;
        end;
        BREAK;
      end;

      inc(i);
    end;
  end;

begin
  memo.GetHighlighterAttriAtRowColEx(memo.CaretXY, Token, TokenType, Start,
    Attri);

  if (Length(Token) = 1) and (memo.CaretX <= Length(memo.LineText)) then
  begin
    n := FindAttrIndex('Symbol', memo.Highlighter);

    if (n > 0) and (memo.Highlighter.Attribute[n] = Attri) then
    begin
      HTMLBraces := (memo.Highlighter = fmMain.hlHtml) or (memo.Highlighter =
        fmMain.hlXML);

      if HTMLBraces then
      begin
        TestChars(OpenCharsHTML, CloseCharsHTML, tpOpening);
        TestChars(CloseCharsHTML, OpenCharsHTML, tpClosing);
      end
      else
      begin
        TestChars(OpenChars, CloseChars, tpOpening);
        TestChars(CloseChars, OpenChars, tpClosing);
      end;
      memo.Canvas.Brush.Style := bsSolid;
    end;
  end;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                      Events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.timRecBlinkingTimer(Sender: TObject);
var
  s: string;
begin
  if pnStatus.Visible then
    s := pnStatus.Panels[STAT_MACRO_PANEL].Text
  else
    s := fmMain.pnMainStatus.Panels[STAT_MACRO_PANEL].Text;

  if (Length(s) = 0) then
    RefreshMacroRecording(TRUE)
  else
    RefreshMacroRecording(FALSE);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.pnStatusResize(Sender: TObject);
begin
  // XP Repaint bug
  with (Sender as TStatusBar) do
    if HandleAllocated then
      InvalidateRect(Handle, nil, True);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  // da se ne skrolaju drugi prozori dok se skrola editor
  Handled := TRUE;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                  Drag'n'drop
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.FOnTimTextDrag(Sender: TObject);
var
  XY: TPoint;
  dX, dY: integer;
begin
  Windows.GetCursorPos(XY);

  XY := ScreenToClient(XY);
  dX := 0;
  dY := 0;

  if (XY.Y < memo.Top + 20) then
    dY := -1
  else if (XY.Y > memo.Top + memo.Height - 20) then
    dY := 1
  else if (XY.X < memo.Left + 20) then
    dX := -1
  else if (XY.X > memo.Left + memo.Width - 20) then
    dX := 1;

  if (dX <> 0) then
    memo.LeftChar := memo.LeftChar + dX;

  if (dY <> 0) then
    memo.TopLine := memo.TopLine + dY;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept := (Sender = memo) or ((fmMain.FilePanelVisible) and
    Assigned(fmMain.FilePanel.DragFiles));

  if (Sender = memo) then
    FDragTopLine := memo.TopLine;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.memoDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if (fmMain.FilePanelVisible) and Assigned(fmMain.FilePanel.DragFiles) then
    fmMain.OpenMultipleFiles(fmMain.FilePanel.DragFiles.FileList);
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                  Form events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmEditor.InvokeHelpFile;
var
  s: string;
  OldHelp: string;
  HL: pTHighlighter;
begin
  HL := GetHighlighterRec(memo.Highlighter);
  if not Assigned(HL) then
    EXIT;

  if (memo.SelAvail) then
    s := memo.SelText
  else
    s := GetWordUnderCursor;

  if (UpperCase(ExtractFileExt(HL^.HelpFile)) = '.HLP') then
  begin
    OldHelp := Application.HelpFile;
    Application.HelpFile := HL^.HelpFile;

    // a jebemu.. ne znam �ta je od ovog dvoje bolje...
    Application.HelpCommand(HELP_KEY, integer(PChar(s)));
    //  Application.HelpCommand(HELP_PARTIALKEY,integer(PChar(s)));

    Application.HelpFile := OldHelp;
  end
  else
  begin
    ShellExecuteExternalFile(HL^.HelpFile);
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  key: word;
  ss: TShiftState;
begin
  key := TranslateShortcut(Msg, ss);

  if not fmMain.Macros.Play(SELF, key, ss) then
  begin
    case Key of
      VK_INSERT:
        if (ss = [ssShift]) then
        begin
          PasteSelection;
          Handled := TRUE;
        end;
      VK_BACK:
        if (ss = [ssShift]) then
        begin
          memo.CommandProcessor(ecDeleteLastChar, #0, nil);
          Handled := TRUE;
        end;
      VK_RETURN:
        if (ss = [ssShift]) then
        begin
          memo.CommandProcessor(ecLineBreak, #0, nil);
          Handled := TRUE;
        end;
      VK_END:
        if (ss = []) then
        begin
          memo.TrimLine(memo.CaretY);
        end;
      VK_F1:
        begin
          InvokeHelpFile;
          Handled := TRUE;
        end;
    end;
  end
  else
    Handled := TRUE;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormCreate(Sender: TObject);
begin
  fFileHandler := TEditorFileHandler.Create(SELF);

  fPreviousCaretY := -1;
  mlApplyLanguageToForm(SELF, 'fmEditor');

  DefineUserCommands;
  NewFile := TRUE;

  // gutter cursor
  Screen.Cursors[crGutter] := LoadCursor(HInstance, 'CUR_LINE_SELECT');

  ApplyOptions(@EditorCfg);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormShow(Sender: TObject);
begin
  FLoaded := TRUE;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  fmMain.PrjManager.UpdateEditorOnClose(SELF);

  uCodeTemplate.RemoveMemoFromList(memo);
  fmMain.RemoveTab(SELF);

  if EnvOptions.MinimizeIfNoFiles and
    Assigned(Application) and
    Assigned(fmMain) and
    (fmMain.tabFiles.Tabs.Count = 0) and
    not DisableMinimizeWhenClosedAllFiles then
    Application.Minimize;

  if (fmMain.tabFiles.Tabs.Count = 0) then
  begin
    fmMain.pnMainStatus.SimplePanel := TRUE;
    PostMessage(fmMain.Handle, WM_CLEAR_ICON_CAPTION, 0, 0);
    fmMain.ActiveEditor := nil;
  end;

  if Assigned(fmFileCompareResults) then
    PostMessage(fmFileCompareResults.Handle, WM_EDITING_FILE_CLOSING, 0, integer(SELF));

  Action := caFree;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if Modified then
  begin
    BringEditorToFront(SELF);
    case MessageDlg(Format(mlStr(ML_EDIT_WARN_FILE_NOT_SAVED,
      'File ''%s'' is modified. Save changes?'), [FileName]),
      mtWarning, [mbYes, mbNo, mbCancel], 0) of
      mrYes:
        CanClose := Save;
      mrNo:
        CanClose := TRUE;
      mrCancel:
        CanClose := FALSE;
    end;
  end
  else
    CanClose := TRUE;

  if CanClose then
  begin
    if (NewFile and (not fKeepedUnexistedFile)) then
    begin
      try
        DeleteFile(FileName);
      except
      end;
    end;

    if (not NewFile and not ProjectFile) then
      fmMain.FilePosHistory.UpdatePosition(SELF);

    if Assigned(fIncrementalSearchPanel) then
      FreeAndNil(fIncrementalSearchPanel);
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormActivate(Sender: TObject);
begin
  fmMain.ActiveEditor := SELF;
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormDeactivate(Sender: TObject);
begin
  if Assigned(fIncrementalSearchPanel) then
    FreeAndNil(fIncrementalSearchPanel);
end;
//------------------------------------------------------------------------------------------

procedure TfmEditor.FormDestroy(Sender: TObject);
begin
  RulerVisible := FALSE;

  if Assigned(timRecBlinking) then
    FreeAndNil(timRecBlinking);

  if Assigned(fEmphasizeWordPlugin) then
    FreeAndNil(fEmphasizeWordPlugin);

  FreeAndNil(fFileHandler);
end;
//------------------------------------------------------------------------------------------

end.

