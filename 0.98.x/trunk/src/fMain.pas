// Copyright (c) 2009, ConTEXT Project Ltd
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// Neither the name of ConTEXT Project Ltd nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

unit fMain;

interface

{$I ConTEXT.inc}

uses
  MainInstance, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ComCtrls, CommCtrl, fEditor, ExtCtrls, ClipBrd, Registry, SynEdit,
  uCommon, uFileHist, StdCtrls, ShellAPI, Buttons, JclFileUtils, fFilePane,
  uFileIconPool, TBXOfficeXPTheme, winhelpviewer,

  SynHighlighterText, SynHighlighterPas, SynHighlighterCpp,
  SynHighlighterHTML, SynHighlighterJava, SynHighlighterJScript,
  SynHighlighterSQL,
  SynHighlighterPython, SynHighlighterCSS,
  uHighlighterProcs, RegExpo, fAbout, fOptions, uMacros, SynEditHighlighter,
  SynHighlighterPHP, uCustomHL, SynHighlighterMyGeneral, SynHighlighterTclTk,
  SynEditKeyCmds, Math, TrayIcon, ComCtrls95,
  SynHighlighterXML, SynHighlighterMPerl, uProject,
  SynHighlighterFortran, SynHighlighterVB, SynHighlighterFoxpro, ImgList,
  SynHighlighterInno, TB2Item, TB2Dock, TB2Toolbar, TBX, ActnList,
  TB2ExtItems, TBXExtItems, TBXSwitcher, TBXMDI, TB2MRU, TBXDkPanels,
  fBottomWindowContainer, JclSysInfo, AppEvnts;
  
type
  TfmMain = class(TForm)
    MainInstance: TMainInstance;
    hlJavascript: TSynJScriptSyn;
    hlJava: TSynJavaSyn;
    hlHtml: TSynHTMLSyn;
    hlCpp: TSynCppSyn;
    hlPas: TSynPasSyn;
    hlSQL: TSynSQLSyn;
    hlPython: TSynPythonSyn;
    hlTxt: TSynTextSyn;
    pnMainBack: TPanel;
    hlPHP: TSynPHPSyn;
    hlTCL: TSynTclTkSyn;
    TrayIcon: TMyTrayIcon;
    tabFiles: TTab95Control;
    hlXML: TSynXMLSyn;
    hlPerl: TSynMPerlSyn;
    hlFortran: TSynFortranSyn;
    Bevel1: TBevel;
    hlVisualBasic: TSynVBSyn;
    hlFox: TSynFoxproSyn;
    ilToolbar: TImageList;
    hlInnoSetup: TSynInnoSyn;
    dockTop: TTBXDock;
    tbMainMenu: TTBXToolbar;
    miFile: TTBXSubmenuItem;
    miNew: TTBXItem;
    miOpen: TTBXItem;
    miSave: TTBXItem;
    miSaveAs: TTBXItem;
    miSaveAllFiles: TTBXItem;
    miCopyTo: TTBXItem;
    miRename: TTBXItem;
    miFilePrnSep: TTBXSeparatorItem;
    miPrint: TTBXItem;
    miPageSetup: TTBXItem;
    miPrintPreview: TTBXItem;
    miFileBlockSep: TTBXSeparatorItem;
    miInsertFileAtCurrentPosition: TTBXItem;
    miAppendFile: TTBXItem;
    miWriteBlockToFile: TTBXItem;
    miExport: TTBXSubmenuItem;
    miExportToHTML: TTBXItem;
    miExportToRTF: TTBXItem;
    miFileCloseSep: TTBXSeparatorItem;
    miClose: TTBXItem;
    miCloseAll: TTBXItem;
    N1: TTBXSeparatorItem;
    miRecentFiles: TTBXSubmenuItem;
    miFileRecentProjects: TTBXSubmenuItem;
    N6: TTBXSeparatorItem;
    miExit: TTBXItem;
    miView: TTBXSubmenuItem;
    miShowToolbar: TTBXItem;
    miShowFileTabs: TTBXItem;
    miSearchResults: TTBXItem;
    miConsoleOutput: TTBXItem;
    miViewFilePanel: TTBXItem;
    miViewFileList: TTBXItem;
    miViewBookmarkSeparator: TTBXSeparatorItem;
    miSetBookmark: TTBXSubmenuItem;
    miJumpToBookmark: TTBXSubmenuItem;
    miGoToLine: TTBXItem;
    N2: TTBXSeparatorItem;
    miShowSpecialCharacters: TTBXItem;
    miViewOEMCharset: TTBXItem;
    N4: TTBXSeparatorItem;
    miLockFileForChanges: TTBXItem;
    miProject: TTBXSubmenuItem;
    miProjectNew: TTBXItem;
    miProjectOpen: TTBXItem;
    miProjectClose: TTBXItem;
    N11: TTBXSeparatorItem;
    miProjectOpenAllFiles: TTBXItem;
    miProjectCloseAllFiles: TTBXItem;
    N3: TTBXSeparatorItem;
    miProjectRecent: TTBXSubmenuItem;
    N9: TTBXSeparatorItem;
    miProjectManageFileList: TTBXItem;
    miTools: TTBXSubmenuItem;
    miRecordMacro: TTBXItem;
    miPlayMacro: TTBXItem;
    miManageMacros: TTBXItem;
    miToolsSep1: TTBXSeparatorItem;
    miUserCommand1: TTBXItem;
    miUserCommand2: TTBXItem;
    miUserCommand3: TTBXItem;
    miUserCommand4: TTBXItem;
    miShellExecute: TTBXItem;
    N8: TTBXSeparatorItem;
    miFileCompare: TTBXItem;
    miTextStatistics: TTBXItem;
    miToolsSep2: TTBXSeparatorItem;
    miSetHighlighter: TTBXSubmenuItem;
    miCustomizeTypes: TTBXItem;
    N5: TTBXSeparatorItem;
    miConversion: TTBXSubmenuItem;
    miConvertToDOS: TTBXItem;
    miConvertToUnicode: TTBXItem;
    miConvertToUNIX: TTBXItem;
    miConvertToMAC: TTBXItem;
    miOptions: TTBXSubmenuItem;
    miPreferences: TTBXItem;
    miCodeTemplate: TTBXItem;
    miWordwrap: TTBXItem;
    miStayOnTop: TTBXItem;
    N7: TTBXSeparatorItem;
    miExportRegistrySettings: TTBXItem;
    miWindow: TTBXSubmenuItem;
    miCascade: TTBXItem;
    miTileHorizontal: TTBXItem;
    miTileVertical: TTBXItem;
    miNextWindow: TTBXItem;
    miPreviousWindow: TTBXItem;
    miWindowMenuSeparator: TTBXSeparatorItem;
    miHelp: TTBXSubmenuItem;
    miHelpContents: TTBXItem;
    N10: TTBXSeparatorItem;
    miAbout: TTBXItem;
    tbToolbar: TTBXToolbar;
    TBXItem5: TTBXItem;
    TBXItem4: TTBXItem;
    TBXItem3: TTBXItem;
    TBXItem2: TTBXItem;
    TBXItem1: TTBXItem;
    TBXSeparatorItem1: TTBXSeparatorItem;
    TBXItem7: TTBXItem;
    TBXItem6: TTBXItem;
    TBXSeparatorItem2: TTBXSeparatorItem;
    TBXItem8: TTBXItem;
    TBXItem9: TTBXItem;
    TBXItem10: TTBXItem;
    TBXItem11: TTBXItem;
    TBXItem12: TTBXItem;
    TBXSeparatorItem3: TTBXSeparatorItem;
    TBXItem13: TTBXItem;
    TBXItem14: TTBXItem;
    TBXItem15: TTBXItem;
    TBXSeparatorItem4: TTBXSeparatorItem;
    TBXItem16: TTBXItem;
    TBXItem17: TTBXItem;
    TBXSeparatorItem5: TTBXSeparatorItem;
    TBXItem18: TTBXItem;
    TBXItem19: TTBXItem;
    TBXItem20: TTBXItem;
    TBXItem21: TTBXItem;
    TBXSeparatorItem6: TTBXSeparatorItem;
    alMain: TActionList;
    acFile: TAction;
    acNew: TAction;
    acOpen: TAction;
    acSave: TAction;
    acSaveAs: TAction;
    acSaveAllFiles: TAction;
    acCopyTo: TAction;
    acRename: TAction;
    acPrint: TAction;
    acPageSetup: TAction;
    acPrintPreview: TAction;
    acInsertFileAtCurrentPosition: TAction;
    acAppendFile: TAction;
    acWriteBlockToFile: TAction;
    acExport: TAction;
    acClose: TAction;
    acCloseAll: TAction;
    acRecentFiles: TAction;
    acFileRecentProjects: TAction;
    acExit: TAction;
    acExportToHTML: TAction;
    acExportToRTF: TAction;
    acShowToolbar: TAction;
    acShowFileTabs: TAction;
    acSearchResults: TAction;
    acConsoleOutput: TAction;
    acViewFilePanel: TAction;
    acViewFileList: TAction;
    acSetBookmark: TAction;
    acJumpToBookmark: TAction;
    acGoToLine: TAction;
    acShowSpecialCharacters: TAction;
    acViewOEMCharset: TAction;
    acLockFileForChanges: TAction;
    acView: TAction;
    acProjectNew: TAction;
    acProjectOpen: TAction;
    acProject: TAction;
    acProjectClose: TAction;
    acProjectOpenAllFiles: TAction;
    acProjectCloseAllFiles: TAction;
    acProjectFiles: TAction;
    acProjectRecent: TAction;
    acProjectManageFileList: TAction;
    acTools: TAction;
    acRecordMacro: TAction;
    acPlayMacro: TAction;
    acManageMacros: TAction;
    acUserCommand1: TAction;
    acUserCommand2: TAction;
    acUserCommand3: TAction;
    acUserCommand4: TAction;
    acShellExecute: TAction;
    acFileCompare: TAction;
    acTextStatistics: TAction;
    acSetHighlighter: TAction;
    acConversion: TAction;
    acCustomizeTypes: TAction;
    acConvertToDOS: TAction;
    acConvertToUnicode: TAction;
    acConvertToUNIX: TAction;
    acConvertToMAC: TAction;
    acOptions: TAction;
    acPreferences: TAction;
    acCodeTemplate: TAction;
    acWordwrap: TAction;
    acStayOnTop: TAction;
    acExportRegistrySettings: TAction;
    acWindow: TAction;
    acCascade: TAction;
    acTileHorizontal: TAction;
    acTileVertical: TAction;
    acNextWindow: TAction;
    acPreviousWindow: TAction;
    acHelp: TAction;
    acHelpOnKeyword: TAction;
    acHelpContents: TAction;
    acAbout: TAction;
    cbHighLighters: TTBXComboBoxItem;
    acEdit: TAction;
    acFormat: TAction;
    acEditUndo: TAction;
    acEditRedo: TAction;
    acEditCut: TAction;
    acEditCopy: TAction;
    acEditPaste: TAction;
    acEditDelete: TAction;
    acEditSelectAll: TAction;
    acEditFind: TAction;
    acEditReplace: TAction;
    acEditFindNext: TAction;
    acEditFindPrevious: TAction;
    acEditToggleSelectionMode: TAction;
    acEditSortText: TAction;
    acEditMatchBraces: TAction;
    acEditSelMatchBraces: TAction;
    acFormatIndentBlock: TAction;
    acFormatUnindentBlock: TAction;
    acFormatToLowerCase: TAction;
    acFormatToUpperCase: TAction;
    acFormatInvertCase: TAction;
    acFormatReformatParagraph: TAction;
    acFormatFillBlock: TAction;
    acFormatInsertCodeFromTemplate: TAction;
    acFormatCommentUncommentCode: TAction;
    acFormatInsertTimeStamp: TAction;
    acFormatRemoveTrailingSpaces: TAction;
    TBXSubmenuItem1: TTBXSubmenuItem;
    TBXSubmenuItem2: TTBXSubmenuItem;
    TBXSwitcher: TTBXSwitcher;
    TBXItem22: TTBXItem;
    TBXItem23: TTBXItem;
    TBXItem24: TTBXItem;
    TBXItem25: TTBXItem;
    TBXItem26: TTBXItem;
    TBXItem27: TTBXItem;
    TBXItem28: TTBXItem;
    TBXItem29: TTBXItem;
    TBXItem30: TTBXItem;
    TBXItem31: TTBXItem;
    TBXSeparatorItem7: TTBXSeparatorItem;
    TBXSeparatorItem8: TTBXSeparatorItem;
    TBXItem32: TTBXItem;
    TBXSeparatorItem9: TTBXSeparatorItem;
    TBXItem33: TTBXItem;
    TBXItem34: TTBXItem;
    TBXItem35: TTBXItem;
    TBXItem36: TTBXItem;
    TBXItem39: TTBXItem;
    TBXItem40: TTBXItem;
    TBXItem41: TTBXItem;
    TBXItem42: TTBXItem;
    TBXItem43: TTBXItem;
    TBXItem44: TTBXItem;
    TBXItem45: TTBXItem;
    TBXItem46: TTBXItem;
    TBXItem47: TTBXItem;
    TBXItem48: TTBXItem;
    TBXItem49: TTBXItem;
    TBXSeparatorItem10: TTBXSeparatorItem;
    TBXSeparatorItem11: TTBXSeparatorItem;
    TBXMDIHandler1: TTBXMDIHandler;
    groupOpenWindows: TTBGroupItem;
    groupHighlighters: TTBGroupItem;
    TBXSubmenuItem3: TTBXSubmenuItem;
    groupProjectFiles: TTBGroupItem;
    cntProjectFilesMRU: TTBItemContainer;
    mruFiles: TTBMRUList;
    TBMRUListItem1: TTBMRUListItem;
    mruProjects: TTBMRUList;
    TBMRUListItem2: TTBMRUListItem;
    TBXMRUListItem1: TTBXMRUListItem;
    dockLeft: TTBXDock;
    dockBottom: TTBXDock;
    dockRight: TTBXDock;
    TBXPopupMenu1: TTBXPopupMenu;
    TBXItem37: TTBXItem;
    TBXSeparatorItem12: TTBXSeparatorItem;
    TBXItem38: TTBXItem;
    TBXItem50: TTBXItem;
    TBXItem51: TTBXItem;
    TBXItem52: TTBXItem;
    TBXSeparatorItem13: TTBXSeparatorItem;
    TBXItem53: TTBXItem;
    pnMainStatus: TStatusBar;
    popTray: TTBXPopupMenu;
    popTrayExit: TTBXItem;
    dpFilePanel: TTBXDockablePanel;
    hlCSS: TSynCssSyn;
    popFileTabs: TTBXPopupMenu;
    TBXItem54: TTBXItem;
    acTrayRestore: TAction;
    TBXItem55: TTBXItem;
    dpBottom: TTBXDockablePanel;
    acEditCopyFilename: TAction;
    TBXItem56: TTBXItem;
    TBXSeparatorItem14: TTBXSeparatorItem;
    TBXItem57: TTBXItem;
    TBXItem58: TTBXItem;
    acEditIncrementalSearch: TAction;
    TBXItem59: TTBXItem;
    TBXSeparatorItem15: TTBXSeparatorItem;
    acViewRuler: TAction;
    TBXItem60: TTBXItem;
    acFileChangeToFileDir: TAction;
    TBXItem61: TTBXItem;
    acHTMLTidy: TAction;
    TBXSeparatorItem16: TTBXSeparatorItem;
    TBXSubmenuItem4: TTBXSubmenuItem;
    acHTMLTidyManage: TAction;
    TBXItem62: TTBXItem;
    TBXSeparatorItem17: TTBXSeparatorItem;
    groupTidyProfiles: TTBGroupItem;
    acFileRevert: TAction;
    acFileRevertToSaved: TAction;
    acFileRevertToBackup: TAction;
    TBXSubmenuItem5: TTBXSubmenuItem;
    TBXSeparatorItem18: TTBXSeparatorItem;
    TBXItem63: TTBXItem;
    TBXItem64: TTBXItem;
    acCloseBottomWindow: TAction;
    acFormatConvertTabsToSpaces: TAction;
    acFormatConvertSpacesToTabs: TAction;
    TBXItem65: TTBXItem;
    TBXItem66: TTBXItem;
    TBXSeparatorItem19: TTBXSeparatorItem;
    acFormatRemoveComments: TAction;
    TBXItem67: TTBXItem;
    procedure FormShow(Sender: TObject);
    procedure tabFilesChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure WindowMenu_OnClick(Sender: TObject);
    procedure FormShortCut(var Msg: TWMKey; var Handled: Boolean);
    procedure OnApplicationActivate(Sender: TObject);
    procedure OnApplicationDeactivate(Sender: TObject);
    procedure OnApplicationMinimize(Sender: TObject);
    procedure acSetBookmarkExecute(Sender: TObject);
    procedure acJumpToBookmarkExecute(Sender: TObject);
    procedure acBookmarkJumpExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tabFilesMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormDragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
    procedure FormDragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure pnMainStatusResize(Sender: TObject);
    procedure acDummyExecute(Sender: TObject);
    procedure acNewExecute(Sender: TObject);
    procedure acOpenExecute(Sender: TObject);
    procedure acSaveExecute(Sender: TObject);
    procedure acSaveAsExecute(Sender: TObject);
    procedure acSaveAllFilesExecute(Sender: TObject);
    procedure acCopyToExecute(Sender: TObject);
    procedure acRenameExecute(Sender: TObject);
    procedure acPrintExecute(Sender: TObject);
    procedure acPageSetupExecute(Sender: TObject);
    procedure acPrintPreviewExecute(Sender: TObject);
    procedure acInsertFileAtCurrentPositionExecute(Sender: TObject);
    procedure acAppendFileExecute(Sender: TObject);
    procedure acWriteBlockToFileExecute(Sender: TObject);
    procedure acCloseExecute(Sender: TObject);
    procedure acCloseAllExecute(Sender: TObject);
    procedure acExitExecute(Sender: TObject);
    procedure acExportToHTMLExecute(Sender: TObject);
    procedure acExportToRTFExecute(Sender: TObject);
    procedure acShowToolbarExecute(Sender: TObject);
    procedure acShowFileTabsExecute(Sender: TObject);
    procedure acSearchResultsExecute(Sender: TObject);
    procedure acConsoleOutputExecute(Sender: TObject);
    procedure acViewFilePanelExecute(Sender: TObject);
    procedure acViewFileListExecute(Sender: TObject);
    procedure acGoToLineExecute(Sender: TObject);
    procedure acShowSpecialCharactersExecute(Sender: TObject);
    procedure acViewOEMCharsetExecute(Sender: TObject);
    procedure acLockFileForChangesExecute(Sender: TObject);
    procedure acViewExecute(Sender: TObject);
    procedure acFileExecute(Sender: TObject);
    procedure alMainUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure acUserCommandExecute(Sender: TObject);
    procedure acRecordMacroExecute(Sender: TObject);
    procedure acPlayMacroExecute(Sender: TObject);
    procedure acManageMacrosExecute(Sender: TObject);
    procedure acShellExecuteExecute(Sender: TObject);
    procedure acFileCompareExecute(Sender: TObject);
    procedure acTextStatisticsExecute(Sender: TObject);
    procedure acCustomizeTypesExecute(Sender: TObject);
    procedure acConversionExecute(Sender: TObject);
    procedure acProjectNewExecute(Sender: TObject);
    procedure acProjectExecute(Sender: TObject);
    procedure acProjectOpenExecute(Sender: TObject);
    procedure acProjectOpenFileExecute(Sender: TObject);
    procedure acProjectCloseExecute(Sender: TObject);
    procedure acProjectOpenAllFilesExecute(Sender: TObject);
    procedure acProjectCloseAllFilesExecute(Sender: TObject);
    procedure acProjectFilesExecute(Sender: TObject);
    procedure acProjectManageFileListExecute(Sender: TObject);
    procedure acToolsExecute(Sender: TObject);
    procedure acPreferencesExecute(Sender: TObject);
    procedure acCodeTemplateExecute(Sender: TObject);
    procedure acWordwrapExecute(Sender: TObject);
    procedure acStayOnTopExecute(Sender: TObject);
    procedure acExportRegistrySettingsExecute(Sender: TObject);
    procedure acCascadeExecute(Sender: TObject);
    procedure acTileHorizontalExecute(Sender: TObject);
    procedure acTileVerticalExecute(Sender: TObject);
    procedure acNextWindowExecute(Sender: TObject);
    procedure acPreviousWindowExecute(Sender: TObject);
    procedure acHelpOnKeywordExecute(Sender: TObject);
    procedure acHelpContentsExecute(Sender: TObject);
    procedure acAboutExecute(Sender: TObject);
    procedure acWindowExecute(Sender: TObject);
    procedure acSetHighlighterExecute(Sender: TObject);
    procedure mruFilesClick(Sender: TObject; const Filename: String);
    procedure mruProjectsClick(Sender: TObject; const Filename: String);
    procedure acEditUndoExecute(Sender: TObject);
    procedure acEditRedoExecute(Sender: TObject);
    procedure acEditCutExecute(Sender: TObject);
    procedure acEditCopyExecute(Sender: TObject);
    procedure acEditPasteExecute(Sender: TObject);
    procedure acEditDeleteExecute(Sender: TObject);
    procedure acEditSelectAllExecute(Sender: TObject);
    procedure acEditFindExecute(Sender: TObject);
    procedure acEditReplaceExecute(Sender: TObject);
    procedure acEditFindNextExecute(Sender: TObject);
    procedure acEditFindPreviousExecute(Sender: TObject);
    procedure acEditToggleSelectionModeExecute(Sender: TObject);
    procedure acEditSortTextExecute(Sender: TObject);
    procedure acEditMatchBracesExecute(Sender: TObject);
    procedure acEditSelMatchBracesExecute(Sender: TObject);
    procedure acFormatIndentBlockExecute(Sender: TObject);
    procedure acFormatUnindentBlockExecute(Sender: TObject);
    procedure acFormatToLowerCaseExecute(Sender: TObject);
    procedure acFormatToUpperCaseExecute(Sender: TObject);
    procedure acFormatInvertCaseExecute(Sender: TObject);
    procedure acFormatReformatParagraphExecute(Sender: TObject);
    procedure acFormatFillBlockExecute(Sender: TObject);
    procedure acFormatInsertCodeFromTemplateExecute(Sender: TObject);
    procedure acFormatCommentUncommentCodeExecute(Sender: TObject);
    procedure acFormatInsertTimeStampExecute(Sender: TObject);
    procedure acFormatRemoveTrailingSpacesExecute(Sender: TObject);
    procedure dpFilePanelClose(Sender: TObject);
    procedure acTrayRestoreExecute(Sender: TObject);
    procedure dpBottomClose(Sender: TObject);
    procedure tabFilesTabShift(Sender: TObject);
    procedure acEditCopyFilenameExecute(Sender: TObject);
    procedure acEditIncrementalSearchExecute(Sender: TObject);
    procedure acViewRulerExecute(Sender: TObject);
    procedure acFileChangeToFileDirExecute(Sender: TObject);
    procedure tabFilesChanging(Sender: TObject; var AllowChange: Boolean);
    procedure tabFilesMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure tabFilesMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure acHTMLTidyManageExecute(Sender: TObject);
    procedure acHTMLTidyExecute(Sender: TObject);
    procedure acFileRevertExecute(Sender: TObject);
    procedure acFileRevertToSavedExecute(Sender: TObject);
    procedure acFileRevertToBackupExecute(Sender: TObject);
    procedure acCloseBottomWindowExecute(Sender: TObject);
    procedure acFormatConvertTabsToSpacesExecute(Sender: TObject);
    procedure acFormatConvertSpacesToTabsExecute(Sender: TObject);
    procedure acFormatRemoveCommentsExecute(Sender: TObject);
  private
    FActiveEditor        :TfmEditor;
    FFullScreen          :boolean;
    FFileTabsVisible     :boolean;
    FStayOnTop           :boolean;
    FVisibleFileTabIcons :boolean;
    FMultilineTabs       :boolean;
    FLockPaintingRefCnt  :integer;
    FFileIconPool        :TFileIconPool;
    fFormInitialMaximized: boolean;


    FUserCommandCtrl     :array[0..3] of record
                                           mi   :TTBXItem;
                                           action: TCustomAction;
                                         end;

    FFilePanel       :TfmFilePanel;

    fFilePanelVisible: boolean;
    fBottomWindowVisible: boolean;

    procedure SetActiveEditor(value:TfmEditor);
    procedure SetFullScreen(value:boolean);
    procedure SetFileTabsVisible(value:boolean);
    procedure SetMultilineTabs(Value:boolean);
    procedure SetFilePanelVisible(const Value: boolean);
    procedure SetStayOnTop(Value:boolean);
    procedure SetVisibleFileTabIcons(Value:boolean);
    procedure DefineHighlighters;
    procedure SaveChangedCustomHighlighters;

    procedure LoadSettings;
    procedure SaveSettings;
    procedure LoadLanguageConfig;
    procedure LoadSysTrayIcon;

    procedure FileTimesCheck;
    function  ValidFileName(fname:string):boolean;
    procedure CreateBookmarkMenuItems;
    procedure PrepareAppForLargeFontMess;
    procedure DoCommandLine;

    procedure SwitchToNext;
    procedure SwitchToPrev;
    procedure ToggleBottomWindow(CurrentView: TBottomWindowCurrentView);
    {$IFDEF SUPPORTS_HTML_TIDY}
      procedure UpdateHTMLTidyProfiles;
    {$ENDIF}

    procedure WMDropFiles(var Msg: TMessage); message WM_DROPFILES;
    procedure MultiInstancesAllowed(var Msg: TMessage); message wmMultiInstanceAllowed;
    procedure WMLockPainting(var Msg: TMessage); message wmLockPainting;
    procedure AppMessage(var Msg: TMsg; var Handled: boolean);
    procedure SetBottomWindowVisible(const Value: boolean);
  protected
    procedure WndProc(var Message: TMessage); override;
  public
    Macros              :TMacros;
    DefaultlbItemHeight :integer;
    FilePosHistory      :TFilePosHistory;
    PrjManager          :TProjectManager;
    ExitingContext      :boolean;

    function  CreateNewDocument(UseDefaultsForNewDocument:boolean): TfmEditor;
    function  CreateOpenDialog(const FilterWithCurrentFile:boolean = TRUE):TOpenDialog;
    function  OpenFile(fname:string): boolean; 
    function  OpenProjectFile(fname:string; const CheckIfExists:boolean = FALSE):boolean;
    procedure OpenFileFromCommandLine(fname:string);
    procedure OpenMultipleFiles(Files:TStrings; const CheckIfExists:boolean = FALSE);
    function  OpenPrintAndCloseFile(fname:string):boolean;
    function  FindOpenedFile(fname:string):TfmEditor;

    function  Enum(var editor:TfmEditor; var n:integer):boolean;
    function  GetEditorList: TEditorList;
    function  GetEditorStrList: TStringList;
    function  GetCurrentEditorIndex:integer;
    function  FindMaximizedForm:TForm;
    procedure RenameTab(ed:TfmEditor; TabCaption:string);
    procedure SelectTab(ed:TfmEditor);
    procedure RemoveTab(ed:TfmEditor);
    procedure UpdateTabsSize;
    procedure SetHighlighter(ed:TfmEditor; fname:string; const HL:pTHighlighter = nil);
    procedure SetPropriateHighlighterCombo;
    procedure ApplyOtherColors;
    procedure ApplyEditorOptions;
    procedure RefreshUserExecHints;
    function  IsMenuShortcut(SC:TShortCut):boolean;
    procedure UpdateHistoryPanel;
    procedure ShowBottomWindow(CurrentView: TBottomWindowCurrentView);

    function  LockPainting(OnlyIfMaximized: boolean): boolean;
    procedure UnlockPainting(OnlyIfMaximized: boolean);

    procedure InstanceFileOpenNotify(var Msg: tMessage); message wmMainInstanceOpenFile;

    destructor Destroy; override;
  published
    property  ActiveEditor        :TfmEditor read FActiveEditor write SetActiveEditor;
    property  FullScreen          :boolean read FFullScreen write SetFullScreen;
    property  FileTabsVisible     :boolean read FFileTabsVisible write SetFileTabsVisible;
    property  MultilineTabs       :boolean read FMultilineTabs write SetMultilineTabs;
    property  FilePanelVisible :boolean read fFilePanelVisible write SetFilePanelVisible;
    property  StayOnTop           :boolean read FStayOnTop write SetStayOnTop;
    property  VisibleFileTabIcons :boolean read FVisibleFileTabIcons write SetVisibleFileTabIcons;
    property  FilePanel: TfmFilePanel read FFilePanel;
    property  FileIconPool        :TFileIconPool read FFileIconPool;
    property BottomWindowVisible: boolean read fBottomWindowVisible write SetBottomWindowVisible;
  end;

var
  fmMain: TfmMain;

var
  DefaultWindowsAnimated :boolean;

  // MDI next/prev
  IsNext              :boolean;
  IsPrev              :boolean;


implementation

{$R *.dfm}

uses
  fFind, fDTestPrintPreview, fDPageSetup, fMacroStart, uMultiLanguage,
  fCustomizeFileTypes, fMacroSelect, fMacroManage, fExport, uCodeTemplate, uPrinting,
  uCmdLine, fFileList, fFileCompare, fFileCompareResults,
  fTextStats, fBottomWindowOutputConsole,
  {$IFDEF SUPPORTS_HTML_TIDY}
    uHTMLTidy,
    fHTMLTidyManageProfiles,
  {$ENDIF}
  uEnvOptions;

////////////////////////////////////////////////////////////////////////////////////////////
//                               Property functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.SetActiveEditor(value:TfmEditor);
begin
  if (FActiveEditor<>value) then begin
    FActiveEditor:=value;

    RefreshUserExecHints;
    SelectTab(value);
    SetPropriateHighlighterCombo;
  end;                      
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetFullScreen(value:boolean);
begin
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetFileTabsVisible(value:boolean);
begin
  if (FFileTabsVisible<>Value) then begin
    FFileTabsVisible:=Value;
    tabFiles.Visible:=FFileTabsVisible;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetMultilineTabs(Value:boolean);
begin
  if (FMultilineTabs<>Value) then begin
    FMultilineTabs:=Value;
    tabFiles.MultiLine:=Value;
    UpdateTabsSize;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetFilePanelVisible(const Value: boolean);
begin
  if (fFilePanelVisible<>Value) then begin
    fFilePanelVisible:=Value;

    if Value and not Assigned(FilePanel) then begin
      FFilePanel:=TfmFilePanel.Create(dpFilePanel);
      FFilePanel.Parent:=dpFilePanel;
      FFilePanel.Show;

      if PrjManager.Active then
        FFilePanel.Project:=PrjManager;
    end;

    if not Value and Assigned(FilePanel) and (ActiveEditor<>nil) then
      SendMessage(ActiveEditor.Handle, WM_SETFOCUS, 0, 0);

    dpFilePanel.Visible:=Value;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetStayOnTop(Value:boolean);
begin
  if (FStayOnTop<>Value) then begin
    FStayOnTop:=Value;

    if Value then 
      SetWindowPos(Handle,HWND_TOPMOST,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE)
    else
      SetWindowPos(Handle,HWND_NOTOPMOST,0,0,0,0,SWP_NOMOVE+SWP_NOSIZE);

    miStayOnTop.Checked:=Value;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetVisibleFileTabIcons(Value:boolean);
begin
  if Value then
    tabFiles.Images:=FileIconPool.ImageList
  else
    tabFiles.Images:=nil;

  FVisibleFileTabIcons:=Value;
  UpdateTabsSize;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetBottomWindowVisible(const Value: boolean);
begin
  if (fBottomWindowVisible<>Value) then begin
    fBottomWindowVisible:=Value;

    if Value then begin
      ShowBottomWindow(bwNone);
    end else
      dpBottom.Visible:=FALSE;
  end;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Messages
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.WndProc(var Message: TMessage);
var
  i  :integer;
begin
  case Message.Msg of
    WM_REPAINTALLMDI:
      begin
        LockPainting(FALSE);
        for i:=0 to MDIChildCount-1 do
          SwitchToNext;
        UnlockPainting(FALSE);
      end;
    WM_CLEAR_ICON_CAPTION:
      TrayIcon.ToolTip:='ConTEXT';
    WM_CHECK_FILETIMES:
      FileTimesCheck;
    else
      inherited;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.WMDropFiles(var Msg: TMessage);
var
  i, iNumberDropped :integer;
  szPathName        :array[0..260] of char;
  Point             :TPoint;
  str               :TStringList;
begin
  try
    iNumberDropped:=DragQueryFile(THandle(Msg.wParam), Cardinal(-1), nil, 0);
    DragQueryPoint(THandle(Msg.wParam), Point);

    str:=TStringList.Create;
    for i:=0 to iNumberDropped-1 do begin
      DragQueryFile(THandle(Msg.wParam), i, szPathName, SizeOf(szPathName));
      str.Add(szPathName);
    end;

    OpenMultipleFiles(str);
    str.Free;
  finally
    Msg.Result := 0;
    DragFinish(THandle(Msg.wParam));
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.MultiInstancesAllowed(var Msg: tMessage);
begin
  Msg.Result:=integer(EnvOptions.MultipleInstances);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.WMLockPainting(var Msg: TMessage); 
begin
  if (Msg.LParam=1) then
    LockPainting(FALSE)
  else
    UnlockPainting(FALSE);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.InstanceFileOpenNotify(var Msg: tMessage);
var
  str_len :integer;
  p       :PChar;
  s       :string;
  str     :TStringList;
  start   :integer;
  run     :integer;
const
  buff    :PChar = nil;
  ptr     :PChar = nil;
  MAX_BUFF_SIZE  = 16000;
begin
  TrayIcon.Active:=FALSE;

  str_len:=Msg.LParam;
  p:=StrAlloc(str_len+1);

  GlobalGetAtomName(Msg.wParam, p, str_len+1);

  if not Assigned(buff) then begin
    buff:=AllocMem(MAX_BUFF_SIZE);
    ptr:=buff;
  end else
    ptr:=StrEnd(buff);

  StrCopy(ptr,p);
  StrDispose(p);

  if ((StrEnd(buff)-1)^=MI_TERMINATOR_CHAR) then begin
    (StrEnd(buff)-1)^:=#00;

    s:=Trim(StrPas(buff))+MI_DELIMITER_CHAR;
    FreeMem(buff);
    buff:=nil;
    
    str:=TStringList.Create;

    start:=1; run:=1;
    while (run<=Length(s)) do begin
      if (s[run]=MI_DELIMITER_CHAR) then begin
        str.Add(Copy(s,start,run-start));
        start:=run+1;
      end;
      inc(run);
    end;

    CmdLine_Init;
    CmdLine_Analyze(str);
    CmdLine_Execute;
    CmdLine_Done;

    str.Free;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.AppMessage(var Msg: TMsg; var Handled: boolean);
begin
  if (IsNext or IsPrev) and (Msg.wParam = vk_F16) and
       (Msg.message = wm_KeyDown) then
    begin
      if IsNext then SwitchToNext
      else if IsPrev then SwitchToPrev;
      IsNext := False;
      IsPrev := False;
      Handled := True;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SwitchToNext;
var
  n      :integer;
begin
  n:=GetCurrentEditorIndex;

  if (n=-1) and (MDIChildCount>0) then EXIT;

  inc(n);
  if (n>MDIChildCount-1) then
    n:=0;

  if (n>-1) then
    BringEditorToFront(TfmEditor(tabFiles.Tabs.Objects[n]));
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SwitchToPrev;
var
  n      :integer;
begin
  n:=GetCurrentEditorIndex;

  if (n=-1) and (MDIChildCount>0) then EXIT;

  dec(n);
  if (n<0) then
    n:=MDIChildCount-1;

  if (n>-1) then
    BringEditorToFront(TfmEditor(tabFiles.Tabs.Objects[n]));
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
function TfmMain.LockPainting(OnlyIfMaximized: boolean): boolean;
begin
  if OnlyIfMaximized and not (WindowState=wsMaximized) then begin
    result:=FALSE;
    EXIT;
  end;

  if (FLockPaintingRefCnt=0) then
    LockWindowUpdate(Handle);

  inc(FLockPaintingRefCnt);
  result:=TRUE;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.UnlockPainting(OnlyIfMaximized:boolean);
begin
  if OnlyIfMaximized and not (WindowState=wsMaximized) then EXIT;

  dec(FLockPaintingRefCnt);

  if (FLockPaintingRefCnt=0) then
    LockWindowUpdate(0);
end;
//------------------------------------------------------------------------------------------
function TfmMain.GetCurrentEditorIndex:integer;
var
  ed :TfmEditor;
begin
  ed:=ActiveEditor;

  if Assigned(ed) then
    result:=tabFiles.Tabs.IndexOfObject(ed)
  else
    result:=-1;
end;
//------------------------------------------------------------------------------------------
function TfmMain.Enum(var editor:TfmEditor; var n:integer):boolean;
begin
  result:=(n<tabFiles.Tabs.Count);

  if result then begin
    editor:=TfmEditor(tabFiles.Tabs.Objects[n]);
    inc(n);
  end;
end;
//------------------------------------------------------------------------------------------
function TfmMain.GetEditorList: TEditorList;
var
  i: integer;
begin
  result:=TEditorList.Create;
  for i:=0 to tabFiles.Tabs.Count-1 do
    result.Add(TfmEditor(tabFiles.Tabs.Objects[i]));
end;
//------------------------------------------------------------------------------------------
function TfmMain.FindMaximizedForm:TForm;
var
  i :integer;
begin
  result:=nil;
  i:=0;
  while (i<fmMain.MDIChildCount) do begin
    if (fmMain.MDIChildren[i].WindowState=wsMaximized) then begin
      result:=TfmEditor(fmMain.MDIChildren[i]);
      BREAK;
    end;
    inc(i);
  end;
end;
//------------------------------------------------------------------------------------------
function TfmMain.CreateNewDocument(UseDefaultsForNewDocument:boolean): TfmEditor;
var
  NewEditor: TfmEditor;
  first: boolean;
  NewTabIndex: integer;
  locked: boolean;

  procedure ShowBackPanel;
  begin
    if not first and (FindMaximizedForm=nil) then EXIT;

    if not first then
      pnMainBack.Color:=ActiveEditor.memo.Highlighter.WhitespaceAttribute.Background
    else
      pnMainBack.Color:=clWindow;

    pnMainBack.Visible:=TRUE;
  end;

  procedure SetDocumentDefaults;
  var
    HL :pTHighlighter;
  begin
    HL:=GetHighlighterRecByName(EditorCfg.DefaultHighlighter);
    if Assigned(HL) then
      SetHighlighter(NewEditor,'',HL)
    else
      SetHighlighter(NewEditor, '', @Highlighters[0]);

    NewEditor.TextFormat:=EditorCfg.DefaultTextFormat;
    NewEditor.Wordwrap:=EditorCfg.WordwrapByDefault;
    NewEditor.Modified:=FALSE;
  end;

begin
  first:=not Assigned(ActiveMDIChild);

  locked:=LockPainting(TRUE);
  SetAnimation(FALSE);

  ShowBackPanel;

  NewEditor:=TfmEditor.Create(SELF);

  NewEditor.NewFile:=TRUE;
  NewEditor.Unnamed:=TRUE;

  if UseDefaultsForNewDocument then
    SetDocumentDefaults;

  if first and not PrjManager.Loading then
    NewEditor.WindowState:=wsMaximized;

  pnMainBack.Visible:=FALSE;

  inc(FileCount);

  NewTabIndex:=tabFiles.TabIndex+1;

  if NewTabIndex<tabFiles.Tabs.Count then begin
    tabFiles.Tabs.InsertObject(NewTabIndex, NewEditor.FileName, NewEditor);
    tabFiles.TabHints.Insert(NewTabIndex, NewEditor.FileName);
    tabFiles.ImageIndexes.Insert(NewTabIndex, IntToStr(FileIconPool.NewFileIndex));
  end else begin
    tabFiles.Tabs.AddObject(NewEditor.FileName, NewEditor);
    tabFiles.TabHints.Add(NewEditor.FileName);
    tabFiles.ImageIndexes.Add(IntToStr(FileIconPool.NewFileIndex));
  end;

  // sve neki apdejtovi
  RenameTab(NewEditor, NewEditor.FileName);
  tabFiles.TabWidth:=1;
  tabFiles.TabWidth:=0;

  tabFiles.TabIndex:=NewTabIndex;
  UpdateTabsSize;

  SetAnimation(TRUE);

  if locked then
    UnlockPainting(TRUE);

  result:=NewEditor;
end;
//------------------------------------------------------------------------------------------
function TfmMain.CreateOpenDialog(const FilterWithCurrentFile:boolean = TRUE):TOpenDialog;
var
  dlg :TOpenDialog;
begin
  dlg:=TOpenDialog.Create(SELF);
  dlg.Options:=[ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing];

  if FilterWithCurrentFile then
    PrepareOpenDlgForFileType(dlg, ActiveEditor)
  else
    PrepareOpenDlgForFileType(dlg,nil);

  result:=dlg;
end;
//------------------------------------------------------------------------------------------
function TfmMain.OpenFile(fname:string):boolean;
var
  Editor: TfmEditor;

  procedure CloseDefaultFile;
  var
    ed     :TfmEditor;
    ed_new :TfmEditor;
    i      :integer;
  const
    default_file_closed: boolean = FALSE;
  begin
    if not default_file_closed then begin
      i:=0;
      while Enum(ed,i) do begin
        if ed.DefaultEmptyFile then begin
          ed_new:=ActiveEditor;
          ed.Close;
          BringEditorToFront(ed_new);
          default_file_closed:=TRUE;
          BREAK;
        end;
      end;
    end;
  end;

begin
  result:=TRUE;

  fname:=GetFileLongName(fname);
  Editor:=FindOpenedFile(fname);

  if Assigned(Editor) then
    BringEditorToFront(Editor)
  else begin
    result:=FileExists(fname);
    if result then begin
      Editor:=CreateNewDocument(FALSE);
      result:=Editor.Open(fname);
      dec(FileCount);
      RefreshUserExecHints;

      if result then begin
        CloseDefaultFile;
        if Assigned(PrjManager) and PrjManager.Active and (PrjManager.GetFileIndex(fname)<>-1) then begin
          Editor.ProjectFile:=TRUE;
          TPrjFileData(PrjManager.fPrjFiles[PrjManager.GetFileIndex(fname)]).Opened:=TRUE;
          if FilePanelVisible and Assigned(FilePanel.ProjectForm) then
            FilePanel.ProjectForm.RefreshFileList;
        end;
      end else begin
        acCloseExecute(SELF);
        mruFiles.Remove(fname);
        UpdateHistoryPanel;
      end;
    end;
  end;

  if not result then
    DlgErrorOpenFile(fname);
end;
//------------------------------------------------------------------------------------------
function TfmMain.OpenProjectFile(fname:string; const CheckIfExists:boolean = FALSE):boolean;
begin
  fname:=GetFileLongName(fname);
  result:=FALSE;

  if not CheckIfExists or (CheckIfExists and FileExists(fname)) then begin
//    miCloseAllClick(SELF);
    result:=PrjManager.Open(fname);
  end else
    DlgErrorOpenFile(fname);

  if result then begin
    mruProjects.Add(fname);

    if FilePanelVisible then
      FilePanel.ProjectBrowserVisible:=TRUE;
  end else
    mruProjects.Remove(fname);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.OpenFileFromCommandLine(fname:string);
begin
  if (Length(ExtractFilePath(fname))=0) then
    fname:=PathAddSeparator(GetCurrentDir)+fname;

  if FileExists(fname) then
    OpenFile(fname)
  else begin
    CreateNewDocument(TRUE);
    ActiveEditor.NewFile:=TRUE;
    ActiveEditor.Unnamed:=FALSE;
    fname:=GetFileLongName(fname);

    if ValidFileName(fname) then begin
      CreateEmptyFile(fname);

      if Assigned(ActiveEditor) then
        ActiveEditor.FileName:=fname;
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.OpenMultipleFiles(Files:TStrings; const CheckIfExists:boolean = FALSE);
var
  locked :boolean;
  i      :integer;
begin
  if not Assigned(Files) then EXIT;

  locked:=Files.Count>2;

  if locked then LockPainting(FALSE);

  if Assigned(FilePanel) then
    FilePanel.LockHistoryUpdate:=TRUE;

  Screen.Cursor:=crHourGlass;
  try
    for i:=0 to Files.Count-1 do begin
      if not CheckIfExists or (CheckIfExists and FileExists(Files[i])) then
        OpenFile(Files[i]);
    end;
  finally
    if locked then UnlockPainting(FALSE);
    Screen.Cursor:=crDefault;

    if Assigned(FilePanel) then
      FilePanel.LockHistoryUpdate:=FALSE;
  end;
end;
//------------------------------------------------------------------------------------------
function TfmMain.OpenPrintAndCloseFile(fname:string):boolean;
begin
  result:=OpenFile(fname);
  if result then begin
    if Assigned(fActiveEditor) then begin
      acPrintExecute(SELF);
      fActiveEditor.Close;
    end;
  end;
end;
//------------------------------------------------------------------------------------------
function TfmMain.FindOpenedFile(fname:string):TfmEditor;
var
  n: integer;
  ed: TfmEditor;
begin
  result:=nil;
  fname:=UpperCase(GetFileLongName(fname));

  n:=0;
  while Enum(ed,n) do begin
    if (UpperCase(ed.FileName)=fname) then begin
      result:=ed;
      BREAK;
    end;
  end;
end;
//------------------------------------------------------------------------------------------
function TfmMain.GetEditorStrList: TStringList;
begin
  result:=TStringList.Create;
  result.Assign(tabFiles.Tabs);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.RenameTab(ed:TfmEditor; TabCaption:string);
var
  n :integer;
begin
  n:=tabFiles.Tabs.IndexOfObject(ed);

  if (n>-1) then begin
    tabFiles.Tabs[n]:=MakeDoubleAmpersand(ExtractFileName(TabCaption));
    tabFiles.TabHints[n]:=ed.FileName;

    if not ed.Unnamed then
      tabFiles.ImageIndexes[n]:=IntToStr(FileIconPool.GetIconIndex(ed.FileName))
    else
      tabFiles.ImageIndexes[n]:=IntToStr(FileIconPool.NewFileIndex);

    UpdateTabsSize;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SelectTab(ed:TfmEditor);
var
  n :integer;
begin
  n:=tabFiles.Tabs.IndexOfObject(ed);

  if (n>-1) then
    tabFiles.TabIndex:=n;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.RemoveTab(ed:TfmEditor);
var
  n :integer;
begin
  n:=tabFiles.Tabs.IndexOfObject(ed);

  if (n>-1) then begin
    tabFiles.Tabs.Delete(n);
    tabFiles.TabHints.Delete(n);
    tabFiles.ImageIndexes.Delete(n);
    UpdateTabsSize;
  end;

  if (tabFiles.Tabs.Count>0) then begin
    if (n>tabFiles.Tabs.Count-1) then
      dec(n);
    tabFiles.TabIndex:=n;
    tabFilesChange(SELF);
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.UpdateTabsSize;
var
  H :integer;
  n :integer;
begin
  tabFiles.Visible:=(tabFiles.Tabs.Count>0) and FFileTabsVisible;

  if tabFiles.Visible then begin
    if MultilineTabs then begin
      n:=TabCtrl_GetRowCount(tabFiles.Handle);

      if (n>0) then
        H:=19*TabCtrl_GetRowCount(tabFiles.Handle)+4
      else
        H:=0;
    end else
      H:=23;

    tabFiles.Height:=H;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetPropriateHighlighterCombo;
var
  i  :integer;
begin
  if Assigned(fActiveEditor) then begin
    i:=0;
    while (i<cbHighlighters.Strings.Count) do begin
      if (fActiveEditor.memo.Highlighter=TSynCustomHighLighter(cbHighlighters.Strings.Objects[i])) then begin
        cbHighlighters.ItemIndex:=i;
        BREAK;
      end;
      inc(i);
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SetHighlighter(ed:TfmEditor; fname:string; const HL:pTHighlighter = nil);
var
  exHL :pTHighlighter;

  procedure SetHL(ed:TfmEditor; pHL:pTHighlighter);
  var
    HL  :TSynCustomHighLighter;
  begin
    HL:=pHL^.HL;

    ed.memo.HighLighter:=HL;
    ed.ColorCurrentLine:=pHL^.ColorCurrentLine;
    ed.OverrideTxtFgColor:=pHL^.OverrideTxtFgColor;

    ed.memo.SelectedColor.Foreground:=HL.Attribute[FindAttrIndex(ATTR_SELECTION_STR,HL)].Foreground;
    ed.memo.SelectedColor.Background:=HL.Attribute[FindAttrIndex(ATTR_SELECTION_STR,HL)].Background;
    ed.memo.RightEdgeColor:=HL.Attribute[FindAttrIndex(ATTR_RIGHTEDGE_STR,HL)].Foreground;

    ed.ApplyRulerSettings;
  end;

begin
  ed.memo.HighLighter:=nil;

  exHL:=HL;

  if Assigned(exHL) then
    SetHL(ed,exHL)
  else begin
    exHL:=FindHighlighterForFile(fname);
    SetHL(ed,exHL);
  end;

  uCodeTemplate.CreateCodeTemplate(exHL);
  AddMemoToList(ed.memo);

  SetPropriateHighlighterCombo;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.ApplyOtherColors;
var
  i, n  :integer;
  ed    :TfmEditor;
  HL    :TSynCustomHighLighter;
begin
  for i:=0 to HIGHLIGHTERS_COUNT-1 do begin
    HL:=HighLighters[i].HL;

    n:=0;
    while Enum(ed,n) do begin
      if (ed.memo.HighLighter=HL) then begin
        ed.ApplyOtherHLColors(HL);
        ed.ColorCurrentLine:=HighLighters[i].ColorCurrentLine;
        ed.OverrideTxtFgColor:=HighLighters[i].OverrideTxtFgColor;
      end;

      ed.ApplyOptions(@EditorCfg);
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.ApplyEditorOptions;
var
  n  :integer;
  ed :TfmEditor;
begin
  n:=0;
  while Enum(ed,n) do
    ed.ApplyOptions(@EditorCfg);

  hlSQL.SQLDialect:=EnvOptions.SQLDialect;

  RefreshUserExecHints;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.RefreshUserExecHints;
var
  i  :integer;
const
  FirstTimeCalled :boolean = TRUE;
  DefaultCaption  :array[0..3] of string = ('','','','');

  procedure SetMenuHint(MenuItem: TTBXItem; Value,Default:string);
  begin
    if (Length(Value)>0) then
      MenuItem.Caption:=Value
    else
      MenuItem.Caption:=Default;
  end;

begin
  if FirstTimeCalled then begin
    for i:=0 to 3 do
      DefaultCaption[i]:=FUserCommandCtrl[i].mi.Caption;
    FirstTimeCalled:=FALSE;
  end;

  if (Assigned(fActiveEditor) and (not fActiveEditor.NewFile)) then begin
    for i:=0 to 3 do with FUserCommandCtrl[i] do begin
      action.Hint:=ExecUserGetHint(i, fActiveEditor.FileName);
      SetMenuHint(mi, action.Hint, DefaultCaption[i]);
    end;
  end else begin
    for i:=0 to 3 do with FUserCommandCtrl[i] do begin
      action.Hint:=mlStr(ML_MAIN_HINT_NOTDEFINED,'[not defined]');
      SetMenuHint(mi, '', DefaultCaption[i]);
    end;
  end;
end;
//------------------------------------------------------------------------------------------
function TfmMain.IsMenuShortcut(SC:TShortCut):boolean;
var
  i: integer;
begin
  result:=FALSE;

  i:=0;
  while (i<alMain.ActionCount) do begin
    result:=(TCustomAction(alMain.Actions[i]).ShortCut=SC);
    if result then
      BREAK;
    inc(i);
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.UpdateHistoryPanel;
begin
  if Assigned(FilePanel) then
    FilePanel.UpdateHistoryList;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.DefineHighlighters;
var
  n  :integer;
  HL :TSynCustomHighLighter;
  i  :integer;
  mi :TTBXItem;
  strHighlighters: TStringList;

  procedure AddHL(n:integer; HL:TSynCustomHighLighter; CommentLineStr, CommentBegStr, CommentEndStr, BlockBegStr, BlockEndStr:string; BlockAutoindent:boolean);
  var
    s        :string;
    LangName :string;
  begin
    s:=HL.DefaultFilter;
    Delete(s,1,Pos('|',HL.DefaultFilter));
    HighLighters[n].Ext:=s;
    HighLighters[n].Custom:=HL is TSynMyGeneralSyn;
    HighLighters[n].HL:=HL;

    HighLighters[n].CommentLineStr:=CommentLineStr;
    HighLighters[n].CommentBegStr:=CommentBegStr;
    HighLighters[n].CommentEndStr:=CommentEndStr;
    HighLighters[n].BlockAutoindent:=BlockAutoindent;
    HighLighters[n].BlockBegStr:=BlockBegStr;
    HighLighters[n].BlockEndStr:=BlockEndStr;

    if not HighLighters[n].Custom then
      LangName:=HL.LanguageName
    else
      LangName:=TSynMyGeneralSyn(HL).LanguageName;

    HighLighters[n].Name:=LangName;
    strHighlighters.AddObject(LangName, HL);

    if not HighLighters[n].Custom then begin
      AddAdditionalToHighlighter(HL);
    end else begin
      HighLighters[n].ColorCurrentLine:=TSynMyGeneralSyn(HL).CurrLineHighlighted;
      HighLighters[n].OverrideTxtFgColor:=TSynMyGeneralSyn(HL).OverrideTxtFgColor;
      HighLighters[n].HelpFile:=TSynMyGeneralSyn(HL).HelpFile;
    end;
  end;

  procedure AddCustomHL(n:integer; HL:TSynMyGeneralSyn);
  var
    LineComment, CommentBegStr, CommentEndStr :string;
  begin
    TSynMyGeneralSyn(HL).GetCommentStrings(LineComment, CommentBegStr, CommentEndStr);
    AddHL(n, HL, LineComment, CommentBegStr, CommentEndStr,
          TSynMyGeneralSyn(HL).BlockBegStr, TSynMyGeneralSyn(HL).BlockEndStr,
          TSynMyGeneralSyn(HL).BlockAutoindent);
  end;

begin

  // default opcije za sve editore
  with EditorCfg do begin
    Options:=DEFAULT_OPTIONS;

    FindTextAtCursor:=TRUE;
    ExtraLineSpacing:=0;
    InsertCaret:=ctVerticalLine;
    OverwriteCaret:=ctBlock;
    RightEdge:=80;
    TabWidth:=8;
  end;

  strHighlighters:=TStringList.Create;

  HIGHLIGHTERS_COUNT:=IMPLEMENTED_HIGHLIGHTERS_COUNT;

  AddHL(00,hlTxt, '', '', '', '', '', FALSE);
  AddHL(01,hlPas, '//', '{', '}', 'begin', 'end', TRUE);
  AddHL(02,hlCpp, '//', '/*', '*/', '{', '}', TRUE);
  AddHL(03,hlPerl, '#', '', '', '{', '}', TRUE);
  AddHL(04,hlHtml, '', '<!--', '-->', '', '', FALSE);
  AddHL(05,hlCSS, '', '/*', '*/', '{', '}', FALSE);
  AddHL(06,hlXML, '', '<!--', '-->', '', '', FALSE);
  AddHL(07,hlPHP, '//', '/*', '*/', '{', '}', TRUE);
  AddHL(08,hlSQL, '--', '/*', '*/', 'begin', 'end', TRUE);
  AddHL(09,hlVisualBasic, '''', '', '', '', '', FALSE);
  AddHL(10,hlJava, '//', '/*', '*/', '{', '}', TRUE);
  AddHL(11,hlJavascript, '//', '/*', '*/', '{', '}', TRUE);
  AddHL(12,hlPython, '#', '', '', '{', '}', TRUE);
  AddHL(13,hlTCL, '#', '', '', '', '', FALSE);
  AddHL(14,hlFortran, '', '', '', '', '', FALSE);
  AddHL(15,hlFox, '&&', '', '', '', '', FALSE);
  AddHL(16,hlInnoSetup, ';', '', '', '', '', FALSE);

  LoadCustomHLFiles;
  n:=0;
  while EnumCustomHL(HL,n) do begin
    AddCustomHL(HIGHLIGHTERS_COUNT,TSynMyGeneralSyn(HL));
    inc(HIGHLIGHTERS_COUNT);
  end;

  strHighlighters.Sort;
  cbHighlighters.Strings.Assign(strHighlighters);

  groupHighlighters.Clear;

  for i:=0 to cbHighlighters.Strings.Count-1 do begin
    mi:=TTBXItem.Create(miSetHighlighter);
    mi.Caption:=cbHighlighters.Strings[i];
    mi.Tag:=integer(cbHighlighters.Strings.Objects[i]);
    mi.OnClick:=acSetHighlighterExecute;
    groupHighlighters.Add(mi);
  end;

  strHighlighters.Free;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SaveChangedCustomHighlighters;
var
  i  :integer;
  ed :TfmEditor;
begin
  for i:=0 to HIGHLIGHTERS_COUNT-1 do
    if Assigned(HighLighters[i].HL) and (HighLighters[i].HL is TSynMyGeneralSyn) and HighLighters[i].ChangedAttr then begin
      SaveCustomHLFile(@HighLighters[i]);
      HighLighters[i].ChangedAttr:=FALSE;

      ed:=FindOpenedFile(TSynMyGeneralSyn(HighLighters[i].HL).SourceFileName);
      if Assigned(ed) then
        ed.CheckFileTime;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.LoadSettings;
var
  reg     :TRegistry;
  i,ii    :integer;
  key     :string;
  WinPos  :TWindowPlacement;
  s       :string;

  procedure LoadAdditionalHLSettings(HL:pTHighLighter);
    function AdjustExt(s:string):string;
    begin
      while (Pos(' .',s)>0) do begin
        Insert(';',s,Pos(' .',s));
        s[Pos(' .',s)]:='*';
        OptionsChanged:=TRUE;
      end;
      if (Length(s)>0) and (s[1]=';') then
        Delete(s,1,1);

      result:=Trim(s);
    end;
  begin
    with reg do begin
      OpenKey(REG_KEY+'HighLighters\'+HL^.HL.Name,TRUE);
      HL^.ColorCurrentLine:=ReadRegistryBool(reg,'ColorCurrentLine',FALSE);
      HL^.OverrideTxtFgColor:=ReadRegistryBool(reg,'OverrideTxtFgColor',FALSE);
      HL^.Ext:=AdjustExt(ReadRegistryString(reg,'Extensions',HL^.Ext));
      HL^.BlockBegStr:=ReadRegistryString(reg,'BlockBegStr',HL^.BlockBegStr);
      HL^.BlockEndStr:=ReadRegistryString(reg,'BlockEndStr',HL^.BlockEndStr);
      HL^.BlockAutoindent:=ReadRegistryBool(reg,'BlockAutoindent',TRUE);
      CopyExtToDefaultFilter(HL);

      CloseKey;
    end;
  end;

  function SafeHeight(H:integer):integer;
  begin
    if (H>10) and (H<Height-10) then
      result:=H
    else
      result:=60;
  end;

begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CURRENT_USER;

  TBRegLoadPositions(SELF, HKEY_CURRENT_USER, REG_KEY+Name);

  // Global section
  with reg do begin
    OpenKey(REG_KEY+'Global',TRUE);

    WinPos.length:=SizeOf(TWindowPlacement);
    GetWindowPlacement(Handle,@WinPos);
    WinPos.rcNormalPosition.Left:=ReadRegistryInteger(reg,'FormLeft',Left);
    WinPos.rcNormalPosition.Top:=ReadRegistryInteger(reg,'FormTop',Top);
    WinPos.rcNormalPosition.Right:=ReadRegistryInteger(reg,'FormWidth',Width)+WinPos.rcNormalPosition.Left;
    WinPos.rcNormalPosition.Bottom:=ReadRegistryInteger(reg,'FormHeight',Height)+WinPos.rcNormalPosition.Top;
    WinPos.showCmd:=SW_HIDE;       // da ne bljesne pri maksimizaciji
    SetWindowPlacement(Handle,@WinPos);

    fFormInitialMaximized:=ReadRegistryBool(reg,'FormMaximized', FALSE);

    BottomWindowVisible:=ReadRegistryBool(reg, 'BottomWindowVisible', TRUE);

    FileTabsVisible:=ReadRegistryBool(reg,'FileTabsVisible',TRUE);
    FilePosHistory.Enabled:=ReadRegistryBool(reg,'SaveFilePositions',TRUE);
    StayOnTop:=ReadRegistryBool(reg,'StayOnTop',FALSE);
    VisibleFileTabIcons:=ReadRegistryBool(reg,'VisibleFileTabIcons',TRUE);
    MultilineTabs:=ReadRegistryBool(reg,'MultilineTabs',TRUE);

    EditorCfg.RightEdgeVisible:=ReadRegistryBool(reg,'WordWrap',FALSE);
    EditorCfg.PrjManagerRelPath:=ReadRegistryBool(reg,'PrjManagerRelPath',FALSE);
  end;

  // Editor options
  with reg do begin
    OpenKey(REG_KEY+'Editor',TRUE);

    if ReadRegistryBool(reg,'AutoIndent',TRUE) then Include(EditorCfg.Options,eoAutoIndent) else
                                                    Exclude(EditorCfg.Options,eoAutoIndent);
    if ReadRegistryBool(reg,'DragDropEditing',TRUE) then Include(EditorCfg.Options,eoDragDropEditing) else
                                                         Exclude(EditorCfg.Options,eoDragDropEditing);
    if ReadRegistryBool(reg,'ScrollPastEol',TRUE) then Include(EditorCfg.Options,eoScrollPastEol) else
                                                       Exclude(EditorCfg.Options,eoScrollPastEol);
    if ReadRegistryBool(reg,'EnhanceHomeKey',FALSE) then Include(EditorCfg.Options,eoEnhanceHomeKey) else
                                                         Exclude(EditorCfg.Options,eoEnhanceHomeKey);
    if ReadRegistryBool(reg,'SmartTabs',TRUE) then Include(EditorCfg.Options,eoSmartTabs) else
                                                   Exclude(EditorCfg.Options,eoSmartTabs);
    EditorCfg.TrimTrailingSpaces:=ReadRegistryBool(reg,'TrimTrailingSpaces',TRUE);
//    if ReadRegistryBool(reg,'TrimTrailingSpaces',TRUE) then Include(EditorCfg.Options,eoTrimTrailingSpaces) else
//                                                   Exclude(EditorCfg.Options,eoTrimTrailingSpaces);
    if ReadRegistryBool(reg,'GroupUndo',TRUE) then Include(EditorCfg.Options,eoGroupUndo) else
                                                   Exclude(EditorCfg.Options,eoGroupUndo);
    if ReadRegistryBool(reg,'TabsInBlockIndent',TRUE) then Include(EditorCfg.Options,eoTabsInBlockIndent) else
                                                   Exclude(EditorCfg.Options,eoTabsInBlockIndent);
    if ReadRegistryBool(reg,'ShowSpecialChars',FALSE) then Include(EditorCfg.Options,eoShowSpecialChars) else
                                                   Exclude(EditorCfg.Options,eoShowSpecialChars);

    EditorCfg.FindTextAtCursor:=ReadRegistryBool(reg,'FindTextAtCursor',TRUE);
    EditorCfg.GutterVisible:=ReadRegistryBool(reg,'GutterVisible',TRUE);
    EditorCfg.LineNumbers:=ReadRegistryBool(reg,'LineNumbers',FALSE);
    EditorCfg.UndoAfterSave:=ReadRegistryBool(reg,'UndoAfterSave',TRUE);
    EditorCfg.HideMouseWhenTyping:=ReadRegistryBool(reg,'HideMouseWhenTyping',TRUE);

    EditorCfg.ExtraLineSpacing:=ReadRegistryInteger(reg,'ExtraLineSpacing',0);
    EditorCfg.InsertCaret:=TSynEditCaretType(ReadRegistryInteger(reg,'InsertCaretShape',ord(ctVerticalLine)));
    EditorCfg.OverwriteCaret:=TSynEditCaretType(ReadRegistryInteger(reg,'OverwriteCaretShape',ord(ctBlock)));
    EditorCfg.RightEdge:=ReadRegistryInteger(reg,'RightEdge',80);
    EditorCfg.GutterWidth:=ReadRegistryInteger(reg,'GutterWidth',30);
    EditorCfg.TabWidth:=ReadRegistryInteger(reg,'TabWidth',DEFAULT_TAB_WIDTH);
    EditorCfg.BlockIndent:=ReadRegistryInteger(reg,'BlockIndent',2);
    EditorCfg.FontName:=ReadRegistryString(reg,'FontName','Courier New');
    EditorCfg.FontSize:=ReadRegistryInteger(reg,'FontSize',10);
    EditorCfg.OEMFontName:=ReadRegistryString(reg,'OEMFontName','Terminal');
    EditorCfg.OEMFontSize:=ReadRegistryInteger(reg,'OEMFontSize',14);
    EditorCfg.GutterFontName:=ReadRegistryString(reg,'GutterFontName','Courier New');
    EditorCfg.GutterFontSize:=ReadRegistryInteger(reg,'GutterFontSize',8);
    EditorCfg.ShowFindReplaceInfoDlg:=ReadRegistryBool(reg,'ShowFindReplaceInfoDlg',TRUE);
    EditorCfg.ShowExecInfoDlg:=ReadRegistryBool(reg,'ShowExecInfoDlg',FALSE);
    EditorCfg.RulerVisible:=ReadRegistryBool(reg, 'RulerVisible', TRUE);
    EditorCfg.TabsMode:=TTabsMode(ReadRegistryInteger(reg,'TabsMode',ord(tmTabsToSpaces)));
    EditorCfg.C_BlockIndent:=ReadRegistryInteger(reg,'CBlockIndent',2);
    EditorCfg.DefaultHighlighter:=ReadRegistryString(reg,'DefaultHighlighter','');
    EditorCfg.DefaultTextFormat:=TTextFormat(ReadRegistryInteger(reg,'DefaultTextFormat',ord(tfNormal)));
    EditorCfg.WordwrapByDefault:=ReadRegistryBool(reg, 'WordwrapByDefault', FALSE);
    EditorCfg.ShowWordwrapGlyph:=ReadRegistryBool(reg,'ShowWordwrapGlyph', TRUE);
  end;

  // Colors
  for i:=0 to HIGHLIGHTERS_COUNT-1 do begin
    with reg do begin
//      if Assigned(HighLighters[i].HL) and not (HighLighters[i].Custom) and not (HighLighters[i].Multi) then begin
      if Assigned(HighLighters[i].HL) and not (HighLighters[i].Custom) then begin
        HighLighters[i].HL.LoadFromRegistry(HKEY_CURRENT_USER,REG_KEY+'HighLighters\'+HighLighters[i].HL.Name);
        LoadAdditionalHLSettings(@HighLighters[i]);

        OpenKey(REG_KEY+'HighLighters\'+HighLighters[i].HL.Name,TRUE);
        HighLighters[i].HelpFile:=ReadRegistryString(reg,'HelpFile','');
      end;
    end;
  end;

  mruFiles.LoadFromRegIni(TRegIniFile(reg), REG_KEY+'mruFiles');
  mruProjects.LoadFromRegIni(TRegIniFile(reg), REG_KEY+'mruProjects');

  // FilePanel - kad se pojavi, postavit ce tekuci direktorij na svoj defaultni
  with reg do begin
    OpenKey(REG_KEY+'FilePanel',TRUE);
    FilePanelVisible:=ReadRegistryBool(reg,'Visible',TRUE);
  end;

  // User exec keys
  key:=REG_KEY+'UserExecKeys';
  with reg do begin
    OpenKey(key,TRUE);
    EditorCfg.UserExecSetCount:=ReadRegistryInteger(reg,'Count',0);
    for i:=0 to EditorCfg.UserExecSetCount-1 do begin
      OpenKey(key+'\'+IntToStr(i),TRUE);
      EditorCfg.UserExecCfg[i].Ext:=ReadRegistryString(reg,'Extensions','');
      for ii:=0 to MAX_USEREXEC_KEYS_COUNT-1 do begin
        OpenKey(key+'\'+IntToStr(i)+'\F'+IntToStr(9+ii),TRUE);
        EditorCfg.UserExecCfg[i].Def[ii].ExecCommand:=ReadRegistryString(reg,'ExecCommand','');
        EditorCfg.UserExecCfg[i].Def[ii].StartDir:=ReadRegistryString(reg,'StartDir','');
        EditorCfg.UserExecCfg[i].Def[ii].Params:=ReadRegistryString(reg,'Params','');
        EditorCfg.UserExecCfg[i].Def[ii].Hint:=ReadRegistryString(reg,'Hint','');
        EditorCfg.UserExecCfg[i].Def[ii].Window:=ReadRegistryInteger(reg,'Window',0);
        EditorCfg.UserExecCfg[i].Def[ii].SaveMode:=TUserExecSaveMode(ReadRegistryInteger(reg,'SaveMode',ord(uesCurrentFile)));
        EditorCfg.UserExecCfg[i].Def[ii].CaptureOutput:=ReadRegistryBool(reg,'CaptureOutput',FALSE);
        EditorCfg.UserExecCfg[i].Def[ii].ScrollConsole:=ReadRegistryBool(reg,'ScrollConsole',TRUE);
        EditorCfg.UserExecCfg[i].Def[ii].PauseAfterExecution:=ReadRegistryBool(reg,'PauseAfterExecution',FALSE);
        EditorCfg.UserExecCfg[i].Def[ii].IdlePriority:=ReadRegistryBool(reg,'IdlePriority', FALSE);
        EditorCfg.UserExecCfg[i].Def[ii].UseShortName:=ReadRegistryBool(reg,'UseShortName',FALSE);
        EditorCfg.UserExecCfg[i].Def[ii].ParserRule:=ReadRegistryString(reg,'ParserRule','');
      end;
    end;
  end;

  // load last files
  if (EnvOptions.StartAction=saOpenLastFiles) then begin
    reg.OpenKey(REG_KEY+'LastOpenFiles',TRUE);

    EditorCfg.LastOpenProject:=ReadRegistryString(reg,'Project','');
    for i:=0 to ReadRegistryInteger(reg,'FilesCount',0) do begin
      s:=ReadRegistryString(reg,'File'+IntToStr(i),'');
      if (Length(s)>0) then
        EditorCfg.LastOpenFilesList.Add(s);
    end;
    EditorCfg.LastActiveFile:=ReadRegistryString(reg,'ActiveFile','');
  end;

  fmFind.LoadConfig(REG_KEY);

  hlSQL.SQLDialect:=EnvOptions.SQLDialect;

  reg.Free;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.SaveSettings;
var
  reg     :TRegistry;
  i,ii    :integer;
  WinPos  :TWindowPlacement;
  key     :string;

  procedure SaveAdditionalHLSettings(HL:pTHighLighter);
  begin
    with reg do begin
      OpenKey(REG_KEY+'HighLighters\'+HL^.HL.Name,TRUE);
      WriteBool('ColorCurrentLine',HL^.ColorCurrentLine);
      WriteBool('OverrideTxtFgColor',HL^.OverrideTxtFgColor);
      WriteString('Extensions',HL^.Ext);
      WriteString('BlockBegStr',HL^.BlockBegStr);
      WriteString('BlockEndStr',HL^.BlockEndStr);
      WriteBool('BlockAutoindent',HL^.BlockAutoindent);
      CloseKey;
    end;
  end;

  procedure UpdateLastOpenFilesList;
  var
    i  :integer;
    ed :TfmEditor;
  begin
    if PrjManager.Active then
      EditorCfg.LastOpenProject:=PrjManager.FileName
    else
      EditorCfg.LastOpenProject:='';

    EditorCfg.LastOpenFilesList.Clear;
    for i:=0 to tabFiles.Tabs.Count-1 do begin
      ed:=TfmEditor(tabFiles.Tabs.Objects[i]);
      if not ed.ProjectFile and not ed.NewFile then
        EditorCfg.LastOpenFilesList.Add(ed.FileName);
    end;

    if (fActiveEditor<>nil) and not (fActiveEditor.NewFile) then
      EditorCfg.LastActiveFile:=fActiveEditor.FileName
    else
      EditorCfg.LastActiveFile:='';
  end;

begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CURRENT_USER;

  TBRegSavePositions(SELF, HKEY_CURRENT_USER, REG_KEY+Name);

  // Global section
  with reg do begin
    OpenKey(REG_KEY+'Global',TRUE);

    WinPos.length:=SizeOf(TWindowPlacement);
    GetWindowPlacement(Handle,@WinPos);

    WriteInteger('FormLeft',WinPos.rcNormalPosition.Left);
    WriteInteger('FormTop',WinPos.rcNormalPosition.Top);
    WriteInteger('FormWidth',WinPos.rcNormalPosition.Right-WinPos.rcNormalPosition.Left);
    WriteInteger('FormHeight',WinPos.rcNormalPosition.Bottom-WinPos.rcNormalPosition.Top);
    WriteBool('FormMaximized',WindowState=wsMaximized);

    WriteBool('BottomWindowVisible', dpBottom.Visible);    

    if not PrjManager.Active then begin
      if Assigned(ActiveMDIChild) then
        WriteBool('EditorMaximized',ActiveMDIChild.WindowState=wsMaximized)
      else
        WriteBool('EditorMaximized',TRUE);
    end;

    WriteBool('FileTabsVisible',FileTabsVisible);
    WriteBool('SaveFilePositions',FilePosHistory.Enabled);
    WriteString('Language',EditorCfg.Language);
    WriteBool('StayOnTop',StayOnTop);
    WriteBool('VisibleFileTabIcons',VisibleFileTabIcons);
    WriteBool('MultilineTabs',MultilineTabs);

    WriteBool('WordWrap',EditorCfg.RightEdgeVisible);
    WriteBool('PrjManagerRelPath',EditorCfg.PrjManagerRelPath);
  end;

  if OptionsChanged then begin
    // Editor options
    with reg do begin
      OpenKey(REG_KEY+'Editor',TRUE);

      WriteBool('AutoIndent',eoAutoIndent in EditorCfg.Options);
      WriteBool('DragDropEditing',eoDragDropEditing in EditorCfg.Options);
      WriteBool('ScrollPastEol',eoScrollPastEol in EditorCfg.Options);
      WriteBool('EnhanceHomeKey',eoEnhanceHomeKey in EditorCfg.Options);
      WriteBool('SmartTabs',eoSmartTabs in EditorCfg.Options);
      WriteBool('TrimTrailingSpaces',EditorCfg.TrimTrailingSpaces);
//      WriteBool('TrimTrailingSpaces',eoTrimTrailingSpaces in EditorCfg.Options);
      WriteBool('GroupUndo',eoGroupUndo in EditorCfg.Options);
      WriteBool('TabsInBlockIndent',eoTabsInBlockIndent in EditorCfg.Options);
      WriteBool('ShowSpecialChars',eoShowSpecialChars in EditorCfg.Options);

      WriteBool('FindTextAtCursor',EditorCfg.FindTextAtCursor);
      WriteBool('GutterVisible',EditorCfg.GutterVisible);
      WriteBool('LineNumbers',EditorCfg.LineNumbers);
      WriteBool('UndoAfterSave',EditorCfg.UndoAfterSave);
      WriteBool('HideMouseWhenTyping',EditorCfg.HideMouseWhenTyping);
      WriteInteger('ExtraLineSpacing',EditorCfg.ExtraLineSpacing);
      WriteInteger('InsertCaretShape',ord(EditorCfg.InsertCaret));
      WriteInteger('OverwriteCaretShape',ord(EditorCfg.OverwriteCaret));
      WriteInteger('RightEdge',EditorCfg.RightEdge);
      WriteInteger('GutterWidth',EditorCfg.GutterWidth);
      WriteInteger('TabWidth',EditorCfg.TabWidth);
      WriteInteger('BlockIndent',EditorCfg.BlockIndent);
      WriteString('FontName',EditorCfg.FontName);
      WriteInteger('FontSize',EditorCfg.FontSize);
      WriteString('OEMFontName',EditorCfg.OEMFontName);
      WriteInteger('OEMFontSize',EditorCfg.OEMFontSize);
      WriteString('GutterFontName',EditorCfg.GutterFontName);
      WriteInteger('GutterFontSize',EditorCfg.GutterFontSize);
      WriteBool('ShowFindReplaceInfoDlg',EditorCfg.ShowFindReplaceInfoDlg);
      WriteBool('ShowExecInfoDlg',EditorCfg.ShowExecInfoDlg);
      WriteBool('RulerVisible', EditorCfg.RulerVisible);
      WriteInteger('TabsMode',ord(EditorCfg.TabsMode));
      WriteInteger('CBlockIndent',EditorCfg.C_BlockIndent);
      WriteString('DefaultHighlighter',EditorCfg.DefaultHighlighter);
      WriteInteger('DefaultTextFormat',ord(EditorCfg.DefaultTextFormat));
      WriteBool('WordwrapByDefault', EditorCfg.WordwrapByDefault);
      WriteBool('ShowWordwrapGlyph', EditorCfg.ShowWordwrapGlyph);
    end;

    // Colors
    for i:=0 to HIGHLIGHTERS_COUNT-1 do begin
      if Assigned(HighLighters[i].HL) then begin
        if not (HighLighters[i].Custom) then begin
          HighLighters[i].HL.SaveToRegistry(HKEY_CURRENT_USER,REG_KEY+'HighLighters\'+HighLighters[i].HL.Name);
          SaveAdditionalHLSettings(@HighLighters[i]);
          reg.OpenKey(REG_KEY+'HighLighters\'+HighLighters[i].HL.Name,TRUE);
          reg.WriteString('HelpFile',HighLighters[i].HelpFile);
        end;
      end;
    end;

    // User exec keys
    key:=REG_KEY+'UserExecKeys';
    with reg do begin
      OpenKey(key,TRUE);
      WriteInteger('Count',EditorCfg.UserExecSetCount);
      for i:=0 to EditorCfg.UserExecSetCount-1 do begin
        OpenKey(key+'\'+IntToStr(i),TRUE);
        WriteString('Extensions',EditorCfg.UserExecCfg[i].Ext);
        for ii:=0 to MAX_USEREXEC_KEYS_COUNT-1 do begin
          OpenKey(key+'\'+IntToStr(i)+'\F'+IntToStr(9+ii),TRUE);
          WriteString('ExecCommand',EditorCfg.UserExecCfg[i].Def[ii].ExecCommand);
          WriteString('StartDir',EditorCfg.UserExecCfg[i].Def[ii].StartDir);
          WriteString('Params',EditorCfg.UserExecCfg[i].Def[ii].Params);
          WriteString('Hint',EditorCfg.UserExecCfg[i].Def[ii].Hint);
          WriteInteger('Window',EditorCfg.UserExecCfg[i].Def[ii].Window);
          WriteInteger('SaveMode',ord(EditorCfg.UserExecCfg[i].Def[ii].SaveMode));
          WriteBool('CaptureOutput',EditorCfg.UserExecCfg[i].Def[ii].CaptureOutput);
          WriteBool('ScrollConsole',EditorCfg.UserExecCfg[i].Def[ii].ScrollConsole);
          WriteBool('PauseAfterExecution', EditorCfg.UserExecCfg[i].Def[ii].PauseAfterExecution);
          WriteBool('IdlePriority', EditorCfg.UserExecCfg[i].Def[ii].IdlePriority);
          WriteBool('UseShortName',EditorCfg.UserExecCfg[i].Def[ii].UseShortName);
          WriteString('ParserRule',EditorCfg.UserExecCfg[i].Def[ii].ParserRule);
        end;
      end;
    end;
  end;

  // FilePanel
  with reg do begin
    OpenKey(REG_KEY+'FilePanel',TRUE);
    WriteBool('Visible',FilePanelVisible);
  end;

  fmFind.SaveConfig(reg, REG_KEY);
  mruFiles.SaveToRegIni(TRegIniFile(reg), REG_KEY+'mruFiles');
  mruProjects.SaveToRegIni(TRegIniFile(reg), REG_KEY+'mruProjects');

  // save last files
  with reg do begin
    DeleteKey(REG_KEY+'LastOpenFiles');

    if (EnvOptions.StartAction=saOpenLastFiles) then begin
      UpdateLastOpenFilesList;
      OpenKey(REG_KEY+'LastOpenFiles',TRUE);

      if (Length(EditorCfg.LastOpenProject)>0) then
        WriteString('Project',EditorCfg.LastOpenProject);

      if (EditorCfg.LastOpenFilesList.Count>0) then begin
        WriteInteger('FilesCount',EditorCfg.LastOpenFilesList.Count);
        for i:=0 to EditorCfg.LastOpenFilesList.Count-1 do
          WriteString('File'+IntToStr(i),EditorCfg.LastOpenFilesList[i]);
      end;

      if (Length(EditorCfg.LastActiveFile)>0) then
        WriteString('ActiveFile',EditorCfg.LastActiveFile);
    end;
  end;

  reg.Free;

  OptionsChanged:=FALSE;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.LoadLanguageConfig;
var
  reg     :TRegistry;
begin
  reg:=TRegistry.Create;
  reg.RootKey:=HKEY_CURRENT_USER;

  try
    // Global section
    with reg do begin
      OpenKey(REG_KEY+'Global',TRUE);
      EditorCfg.Language:=ReadRegistryString(reg,'Language','');
    end;
  finally
    reg.Free;
  end;

  if (Length(EditorCfg.Language)>0) then begin
    mlLoadLanguageFile(EditorCfg.Language);
    mlApplyLanguageToForm(SELF,'fmMain');
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.LoadSysTrayIcon;
var
  IconResName: string;
begin
  case GetWindowsVersion of
    wvWinME, wvWin2000, wvWin2003:
      IconResName:='ICO_CONTEXT_16X16X256';
    wvWinXP:
      IconResName:='ICO_CONTEXT_16X16XP';
    else
      IconResName:='ICO_CONTEXT_16X16X16';
  end;

  TrayIcon.Icon.Handle:=LoadIcon(hInstance, PChar(IconResName));
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.FileTimesCheck;
var
  n     :integer;
  ed    :TfmEditor;
  str   :TStringList;
begin
  if not EnvOptions.DetectFileChanges or ExitingContext then EXIT;

  str:=TStringList.Create;

  try
    n:=0;
    while Enum(ed,n) do
      str.AddObject('',ed);

    for n:=0 to str.Count-1 do
      if Assigned(TfmEditor(str.Objects[n])) then
        TfmEditor(str.Objects[n]).CheckFileTime;
  finally
    str.Free;
  end;
end;
//------------------------------------------------------------------------------------------
function TfmMain.ValidFileName(fname:string):boolean;
var
  F :file;
begin
  AssignFile(F,fname);
  {$I-}
    Rewrite(F);
  {$I+}
  result:=(IOResult=0);

  if result then begin
    CloseFile(F);
    DeleteFile(fname);
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.CreateBookmarkMenuItems;
var
  i   :integer;
  mi  :TTBXItem;
begin
  for i:=0 to 9 do begin
    mi:=TTBXItem.Create(miSetBookmark);
    mi.Caption:='&'+IntToStr(i);
    mi.OnClick:=acSetBookmarkExecute;
    mi.Tag:=i;
    mi.ShortCut:=ShortCut($30+i,[ssShift,ssCtrl]);
    miSetBookmark.Add(mi);

    mi:=TTBXItem.Create(miJumpToBookmark);
    mi.Caption:='&'+IntToStr(i);
    mi.OnClick:=acBookmarkJumpExecute;
    mi.Tag:=i;
    mi.ShortCut:=ShortCut($30+i,[ssCtrl]);
    miJumpToBookmark.Add(mi);
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.PrepareAppForLargeFontMess;
begin
//  DefaultlbItemHeight:=pnFound.ListBox.Canvas.TextHeight('Ty')+1;
//  pnFound.ListBox.ItemHeight:=DefaultlbItemHeight;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.ToggleBottomWindow(CurrentView: TBottomWindowCurrentView);
begin
  if BottomWindowVisible then begin
    if (fmBottomWindowContainer.CurrentView=CurrentView) then
      BottomWindowVisible:=FALSE
    else
      ShowBottomWindow(CurrentView);
  end else
    ShowBottomWindow(CurrentView);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.ShowBottomWindow(CurrentView: TBottomWindowCurrentView);
begin
  if not Assigned(fmBottomWindowContainer) then begin
    fmBottomWindowContainer:=TfmBottomWindowContainer.Create(dpBottom);
    fmBottomWindowContainer.Parent:=dpBottom;
    fmBottomWindowContainer.Show;
  end;

  if (CurrentView<>bwNone) then
    fmBottomWindowContainer.CurrentView:=CurrentView;

  dpBottom.Visible:=TRUE;
  fBottomWindowVisible:=TRUE;
end;
//------------------------------------------------------------------------------------------
{$IFDEF SUPPORTS_HTML_TIDY}
  procedure TfmMain.UpdateHTMLTidyProfiles;
  var
    str: TStringList;
    i: integer;
    Item: TTBXItem;
  begin
    groupTidyProfiles.Clear;

    str:=HTMLTidy.ProfileList;
    for i:=0 to str.Count-1 do begin
      Item:=TTBXItem.Create(groupTidyProfiles);
      Item.Caption:=str[i];
      groupTidyProfiles.Add(Item);
    end;
    str.Free;
  end;
{$ENDIF}
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                     Actions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acDummyExecute(Sender: TObject);
begin
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.alMainUpdate(Action: TBasicAction; var Handled: Boolean);
var
  Editor: TfmEditor;
  n: integer;
  SomeFileChanged: boolean;
  AssignedEditor: boolean;
begin
  n:=0;
  SomeFileChanged:=FALSE;
  while (not SomeFileChanged) and Enum(Editor, n) do
    SomeFileChanged:=Editor.Modified;

  AssignedEditor:=Assigned(fActiveEditor);

  acSave.Enabled:=AssignedEditor and fActiveEditor.Modified;
  acSaveAs.Enabled:=AssignedEditor;
  acSaveAllFiles.Enabled:=SomeFileChanged;
  acClose.Enabled:=AssignedEditor;
  acCloseAll.Enabled:=AssignedEditor;
  acPrint.Enabled:=AssignedEditor;
  acPrintPreview.Enabled:=AssignedEditor;
  acWordWrap.Enabled:=AssignedEditor;
  acViewRuler.Enabled:=AssignedEditor;
  acShowSpecialCharacters.Enabled:=AssignedEditor;

  acEditCut.Enabled:=AssignedEditor and fActiveEditor.CutEnabled;
  acEditCopy.Enabled:=AssignedEditor and fActiveEditor.CopyEnabled;
  acEditPaste.Enabled:=AssignedEditor and fActiveEditor.PasteEnabled;
  acEditUndo.Enabled:=AssignedEditor and fActiveEditor.UndoEnabled;
  acEditRedo.Enabled:=AssignedEditor and fActiveEditor.RedoEnabled;
  acEditFind.Enabled:=AssignedEditor;
  acEditFindNext.Enabled:=AssignedEditor;
  acEditReplace.Enabled:=AssignedEditor and not fActiveEditor.Locked;
  acEditDelete.Enabled:=AssignedEditor and fActiveEditor.DeleteEnabled;
  acEditSortText.Enabled:=AssignedEditor and fActiveEditor.SortTextEnabled;
  acEditCopyFilename.Enabled:=AssignedEditor and fActiveEditor.CopyFilenameToClipboardEnabled;

  acFormatIndentBlock.Enabled:=AssignedEditor and fActiveEditor.IndentBlockEnabled;
  acFormatUnindentBlock.Enabled:=AssignedEditor and fActiveEditor.UnindentBlockEnabled;
  acFormatToLowerCase.Enabled:=AssignedEditor and fActiveEditor.ToLowerCaseEnabled;
  acFormatToUpperCase.Enabled:=AssignedEditor and fActiveEditor.ToUpperCaseEnabled;
  acFormatInvertCase.Enabled:=AssignedEditor and fActiveEditor.InvertCaseEnabled;
  acFormatReformatParagraph.Enabled:=AssignedEditor and fActiveEditor.ReformatParagraphEnabled;
  acFormatFillBlock.Enabled:=AssignedEditor and fActiveEditor.FillBlockEnabled;
  acFormatInsertCodeFromTemplate.Enabled:=AssignedEditor and fActiveEditor.InsertCodeFromTemplateEnabled;
  acFormatCommentUncommentCode.Enabled:=AssignedEditor and fActiveEditor.ToggleCommentBlockEnabled;
  acFormatInsertTimeStamp.Enabled:=AssignedEditor and fActiveEditor.InsertTimeStampEnabled;
  acFormatRemoveTrailingSpaces.Enabled:=AssignedEditor and fActiveEditor.RemoveTrailingSpacesEnabled;
  acFormatConvertTabsToSpaces.Enabled:=AssignedEditor and fActiveEditor.ConvertTabsToSpacesEnabled;
  acFormatConvertSpacesToTabs.Enabled:=AssignedEditor and fActiveEditor.ConvertSpacesToTabsEnabled;
  acFormatRemoveComments.Enabled:=AssignedEditor and fActiveEditor.RemoveCommentsEnabled;

  cbHighlighters.Enabled:=AssignedEditor;
  //acWordwrap.Checked:=EditorCfg.RightEdgeVisible;
  acWordwrap.Checked:=AssignedEditor and fActiveEditor.Wordwrap;
  acStayOnTop.Checked:=fStayOnTop;

  acEdit.Visible:=AssignedEditor;
  acFormat.Visible:=AssignedEditor and not fActiveEditor.Locked;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - FILE
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acFileExecute(Sender: TObject);
var
  AssignedEditor: boolean;
begin
  AssignedEditor:=Assigned(fActiveEditor);

  acInsertFileAtCurrentPosition.Visible:=AssignedEditor and not fActiveEditor.Locked;
  acAppendFile.Visible:=AssignedEditor and not fActiveEditor.Locked;
  acWriteBlockToFile.Visible:=AssignedEditor;
  acWriteBlockToFile.Enabled:=AssignedEditor and (fActiveEditor.SelAvail);

  acCopyTo.Enabled:=AssignedEditor;
  acExport.Enabled:=AssignedEditor;

  acRecentFiles.Enabled:=(mruFiles.Items.Count>0);
  acProjectRecent.Enabled:=(mruProjects.Items.Count>0);

  acRename.Enabled:=AssignedEditor and fActiveEditor.FileHandler.RenameEnabled;
  acRename.Visible:=AssignedEditor;

  acFileChangeToFileDir.Enabled:=AssignedEditor and not (fActiveEditor.NewFile or fActiveEditor.Unnamed);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acNewExecute(Sender: TObject);
begin
  CreateNewDocument(TRUE);
  fActiveEditor.LockHighlighterChange:=TRUE;
  fActiveEditor.FileName:='Edit'+IntToStr(FileCount);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acOpenExecute(Sender: TObject);
var
  dlg :TOpenDialog;
begin
  dlg:=CreateOpenDialog;

  try
    dlg.InitialDir:=EnvOptions.LastDir;
    if dlg.Execute then begin
      OpenMultipleFiles(dlg.Files);
      AddLastDir(dlg.Files[0]);
    end;
  finally
    dlg.Free;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acSaveExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.Save;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acSaveAsExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.Save(TRUE);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acSaveAllFilesExecute(Sender: TObject);
var
  n: integer;
  ed: TfmEditor;
begin
  n:=0;
  while Enum(ed, n) do
    if ed.Modified then
      ed.Save;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acCopyToExecute(Sender: TObject);
begin
  if Assigned(ActiveEditor) then
    ActiveEditor.FileHandler.CopyTo;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFileRevertExecute(Sender: TObject);
begin
  acFileRevertToSaved.Enabled:=Assigned(ActiveEditor) and ActiveEditor.FileHandler.RevertToSavedEnabled;
  acFileRevertToBackup.Enabled:=Assigned(ActiveEditor) and ActiveEditor.FileHandler.RevertToBackupEnabled;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFileRevertToSavedExecute(Sender: TObject);
begin
  if acFileRevertToSaved.Enabled then
    ActiveEditor.FileHandler.RevertToSaved;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFileRevertToBackupExecute(Sender: TObject);
begin
  if acFileRevertToBackup.Enabled then
    ActiveEditor.FileHandler.RevertToBackup;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acRenameExecute(Sender: TObject);
var
  old_fname :string;
  new_filename: string;
begin
  if Assigned(fActiveEditor) then begin
    new_filename:=ExtractFileName(fActiveEditor.FileName);
    if InputQuery(mlStr(ML_RENAME_FILE_CAPTION, 'Rename File'),
                  mlStr(ML_RENAME_FILE_NEW_FILENAME, 'New filename:'),
                  new_filename) then begin
      old_fname:=fActiveEditor.FileName;
      if (fActiveEditor.FileHandler.Rename(new_filename)) then begin
        mruFiles.Remove(old_fname);
        mruFiles.Add(fActiveEditor.FileName);
        UpdateHistoryPanel;
      end;
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFileChangeToFileDirExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then begin
    AddLastDir(fActiveEditor.FileName);
    SetCurrentDir(EnvOptions.LastDir);

    if Assigned(fFilePanel) and (fFilePanel.ExplorerVisible) then
      fFilePanel.Explorer.Directory:=EnvOptions.LastDir;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acPrintExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) and CheckPrinterValidity then begin
    with TPrn.Create(fActiveEditor) do
      try
        Print;
      finally
        Free;
      end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acPageSetupExecute(Sender: TObject);
begin
  with TfmPageSetup.Create(Application) do
    try
      ShowModal;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acPrintPreviewExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) and CheckPrinterValidity then begin
    with TPrn.Create(fActiveEditor) do
      try
        Preview;
      finally
        Free;
      end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acInsertFileAtCurrentPositionExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) and not fActiveEditor.Locked then begin
    with CreateOpenDialog do
      try
        if Execute and not fActiveEditor.InsertFileAtCurrentPosition(FileName) then
          DlgErrorOpenFile(FileName);
      finally
        Free;
      end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acAppendFileExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) and not fActiveEditor.Locked then begin
    with CreateOpenDialog do
      try
        if Execute and not fActiveEditor.AppendFile(FileName) then
          DlgErrorOpenFile(FileName);
      finally
        Free;
      end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acWriteBlockToFileExecute(Sender: TObject);
var
  dlg :TSaveDialog;
label
  EXECUTE_DIALOG;
begin
  if Assigned(fActiveEditor) and (fActiveEditor.SelAvail) then begin
    dlg:=TSaveDialog.Create(SELF);
    dlg.Options:=[ofHideReadOnly, ofEnableSizing];
    PrepareOpenDlgForFileType(dlg, fActiveEditor);

    try
      EXECUTE_DIALOG:
        if dlg.Execute then begin
          if DlgReplaceFile(dlg.FileName) then
            fActiveEditor.WriteBlockToFile(dlg.FileName)
          else
            goto EXECUTE_DIALOG;
        end;
    finally
      dlg.Free;
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acCloseExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.Close;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acCloseAllExecute(Sender: TObject);
var
  n      :integer;
  ed     :TfmEditor;
  str    :TStringList;
  locked :boolean;
begin
  str:=TStringList.Create;

  locked:=(MDIChildCount>2);

  try
    n:=0;
    while Enum(ed,n) do
      str.AddObject('',ed);

    if locked then LockPainting(FALSE);

    for n:=0 to str.Count-1 do
      TfmEditor(str.Objects[n]).Close;
  finally
    if locked then UnlockPainting(FALSE);
    str.Free;
  end;

  pnMainStatus.SimplePanel:=TRUE;

  if EnvOptions.MinimizeIfNoFiles and not DisableMinimizeWhenClosedAllFiles then begin
    Application.Minimize;
    PostMessage(fmMain.Handle,WM_CLEAR_ICON_CAPTION,0,0);
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acExportToHTMLExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) and not (fActiveEditor.memo.Highlighter=hlTxt) then begin
    with TfmExport.Create(SELF) do
      try
        ExportFormat:=efHTML;

        if (ExportFormat<>efNone) then begin
          Editor:=fActiveEditor;
          ShowModal;
        end;
      finally
        Free;
      end;
  end else
    MessageDlg(mlStr(ML_MAIN_CANNOT_EXPORT_TXT_FILES,'Cannot export flat text files.'),mtError,[mbOK],0);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acExportToRTFExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) and not (fActiveEditor.memo.Highlighter=hlTxt) then begin
    with TfmExport.Create(SELF) do
      try
        ExportFormat:=efRTF;

        if (ExportFormat<>efNone) then begin
          Editor:=fActiveEditor;
          ShowModal;
        end;
      finally
        Free;
      end;
  end else
    MessageDlg(mlStr(ML_MAIN_CANNOT_EXPORT_TXT_FILES,'Cannot export flat text files.'),mtError,[mbOK],0);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acExitExecute(Sender: TObject);
begin
  Close;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - EDIT
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditUndoExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.Undo;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditRedoExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.Redo;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditCutExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.CutSelection;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditCopyExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.CopySelection;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditPasteExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.PasteSelection;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditDeleteExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.DeleteSelection;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditSelectAllExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.SelectAll;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditCopyFilenameExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.CopyFilenameToClipboard;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditFindExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.Find;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditReplaceExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.Replace;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditFindNextExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.FindNext;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditFindPreviousExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.FindPrevious;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditIncrementalSearchExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.DoIncrementalSearchDialog;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditToggleSelectionModeExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.ToggleSelectionMode;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditSortTextExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.Sort;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditMatchBracesExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.MatchBraces;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acEditSelMatchBracesExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.SelectTextInBraces;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                Actions - FORMAT
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatIndentBlockExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.IndentBlock;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatUnindentBlockExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.UnindentBlock;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatToLowerCaseExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.ToLowerCase;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatToUpperCaseExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.ToUpperCase;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatInvertCaseExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.InvertCase;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatReformatParagraphExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.ReformatParagraph;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatFillBlockExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.DoFillBlockDialog;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatInsertCodeFromTemplateExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.InsertCodeFromTemplate;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatCommentUncommentCodeExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.ToggleCommentBlock;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatInsertTimeStampExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.InsertTimeStamp;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatRemoveTrailingSpacesExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.RemoveTrailingSpaces;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatConvertTabsToSpacesExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.ConvertTabsToSpaces;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatConvertSpacesToTabsExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.ConvertSpacesToTabs;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFormatRemoveCommentsExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then fActiveEditor.RemoveComments;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - VIEW
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acViewExecute(Sender: TObject);
var
  AssignedEditor: boolean;
begin
  AssignedEditor:=Assigned(fActiveEditor);

  acShowFileTabs.Checked:=FileTabsVisible;
  acSearchResults.Checked:=BottomWindowVisible and (fmBottomWindowContainer.CurrentView=bwSearchResults);
  acConsoleOutput.Checked:=BottomWindowVisible and (fmBottomWindowContainer.CurrentView=bwOutputConsole);
  acViewFilePanel.Checked:=FilePanelVisible;
  acShowToolbar.Checked:=tbToolbar.Visible;
  acViewRuler.Checked:=EditorCfg.RulerVisible;

  acGoToLine.Visible:=AssignedEditor;
  acSetBookmark.Visible:=AssignedEditor;
  acJumpToBookmark.Visible:=AssignedEditor;
  acLockFileForChanges.Enabled:=AssignedEditor;
  acLockFileForChanges.Checked:=AssignedEditor and fActiveEditor.Locked;
  acShowSpecialCharacters.Checked:=eoShowSpecialChars in EditorCfg.Options;
  acViewOEMCharset.Enabled:=AssignedEditor;
  acViewOEMCharset.Checked:=AssignedEditor and fActiveEditor.OEMView;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acShowToolbarExecute(Sender: TObject);
begin
  tbToolbar.Visible:=not tbToolbar.Visible;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acShowFileTabsExecute(Sender: TObject);
begin
  FileTabsVisible:=not FileTabsVisible;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acSearchResultsExecute(Sender: TObject);
begin
  ToggleBottomWindow(bwSearchResults);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acConsoleOutputExecute(Sender: TObject);
begin
  ToggleBottomWindow(bwOutputConsole);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acViewFilePanelExecute(Sender: TObject);
begin
  FilePanelVisible:=not FilePanelVisible;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acViewFileListExecute(Sender: TObject);
begin
  with TfmFileList.Create(SELF) do begin
    SelectedEditor:=fActiveEditor;
    if (ShowModal=mrOK) then begin
      BringEditorToFront(TfmEditor(SelectedEditor));
    end;
    Free;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acSetBookmarkExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.ToggleBookmark(TTBXItem(Sender).Tag);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acJumpToBookmarkExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.UpdateMainMenuBookmarks;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acBookmarkJumpExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.JumpToBookmark(TTBXItem(Sender).Tag);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acGoToLineExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.GoToLineDialog;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acShowSpecialCharactersExecute(Sender: TObject);
begin
  if (eoShowSpecialChars in EditorCfg.Options) then
    Exclude(EditorCfg.Options, eoShowSpecialChars)
  else
    Include(EditorCfg.Options, eoShowSpecialChars);

  ApplyEditorOptions;
  OptionsChanged:=TRUE;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acViewOEMCharsetExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.OEMView:=not fActiveEditor.OEMView;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acLockFileForChangesExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.Locked:=not fActiveEditor.Locked
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - PROJECT
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectExecute(Sender: TObject);
begin
  acProjectClose.Enabled:=PrjManager.Active;
  acProjectManageFileList.Enabled:=PrjManager.Active;
  acProjectFiles.Enabled:=PrjManager.Active;
  acProjectOpenAllFiles.Enabled:=PrjManager.Active;
  acProjectCloseAllFiles.Enabled:=PrjManager.Active;
  acProjectRecent.Enabled:=(mruProjects.Items.Count>0);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectNewExecute(Sender: TObject);
label
  EXECUTE_DIALOG;
begin
  with TSaveDialog.Create(SELF) do
    try
      Filter:='Project workspace files (*.cpr)|*.cpr';
      DefaultExt:='cpr';
      Options:=[ofHideReadOnly, ofEnableSizing];
      Title:=mlStr(ML_PRJFILES_CAPT_NEW_PRJ, 'Create New Project Workspace');

      EXECUTE_DIALOG:
        if Execute then begin
          if DlgReplaceFile(FileName) then begin
            if PrjManager.New(FileName) then
              mruProjects.Add(FileName);
          end else
            goto EXECUTE_DIALOG;

          if FilePanelVisible then begin
            FilePanel.Project:=PrjManager;
            FilePanel.ProjectBrowserVisible:=TRUE;
          end;
        end;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectOpenExecute(Sender: TObject);
begin
  with TOpenDialog.Create(SELF) do
    try
      Filter:='Project workspace files (*.cpr)|*.cpr';
      DefaultExt:='cpr';
      Options:=[ofOverwritePrompt, ofHideReadOnly, ofEnableSizing];
      Title:='Open Project Workspace';
      if Execute then
        OpenProjectFile(FileName);
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectOpenFileExecute(Sender: TObject);
var
  rec: TPrjFileData;
  ed: TfmEditor;
begin
  rec:=TPrjFileData((Sender as TTBXItem).Tag);

  if Assigned(rec) then begin
    ed:=FindOpenedFile(rec.FileName);
    if Assigned(ed) then
      BringEditorToFront(ed)
    else begin
      LockPainting(FALSE);
      PrjManager.OpenProjectFile(rec, FindMaximizedForm<>nil);
      UnlockPainting(FALSE);
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectCloseExecute(Sender: TObject);
begin
  PrjManager.Close(TRUE);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectOpenAllFilesExecute(Sender: TObject);
begin
  PrjManager.OpenAllFiles;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectCloseAllFilesExecute(Sender: TObject);
begin
  PrjManager.CloseAllFiles;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectFilesExecute(Sender: TObject);
var
  i   :integer;
  mi  :TTBXItem;
  rec :TPrjFileData;
  s   :string;
begin
  groupProjectFiles.Clear;

  if PrjManager.Active then begin
    for i:=0 to PrjManager.fPrjFiles.Count-1 do begin
      rec:=TPrjFileData(PrjManager.fPrjFiles[i]);
      mi:=TTBXItem.Create(groupProjectFiles);

      s:=IntToStr(i+1);
      if (i+1<10) then s:='&'+s;
      mi.Caption:=s+' '+rec.FileName;

      mi.Checked:=(FindOpenedFile(rec.FileName)<>nil);

      mi.Tag:=integer(rec);
      mi.OnClick:=acProjectOpenFileExecute;
      groupProjectFiles.Add(mi);
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acProjectManageFileListExecute(Sender: TObject);
begin
  if PrjManager.Active then begin
    FilePanelVisible:=TRUE;
    FilePanel.ProjectBrowserVisible:=TRUE;
  end;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - TOOLS
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acToolsExecute(Sender: TObject);
var
  i  :integer;
  AssignedEditor: boolean;
begin
  AssignedEditor:=Assigned(fActiveEditor);

  miPlayMacro.Enabled:=not Macros.Recording;
  miPlayMacro.Visible:=AssignedEditor and not fActiveEditor.Locked;
  miRecordMacro.Visible:=AssignedEditor and not fActiveEditor.Locked;

  for i:=0 to 3 do begin
    FUserCommandCtrl[i].mi.Enabled:=AssignedEditor and not (fActiveEditor.NewFile);
    FUserCommandCtrl[i].mi.Visible:=AssignedEditor;
  end;

  miToolsSep1.Visible:=AssignedEditor;
  miShellExecute.Visible:=AssignedEditor;
  miToolsSep2.Visible:=AssignedEditor;
  miSetHighlighter.Visible:=AssignedEditor;
  miConversion.Visible:=AssignedEditor and not fActiveEditor.Locked;
  miTextStatistics.Visible:=AssignedEditor;

  {$IFDEF SUPPORTS_HTML_TIDY}
    acHTMLTidy.Enabled:=HTMLTidy.Enabled;
  {$ENDIF}
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acRecordMacroExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then begin
    if not Macros.Recording then begin
      with TfmMacroStartRecording.Create(SELF) do begin
        try
          editor:=fActiveEditor;
          DlgTyp:=msrStart;
          ShowModal;

          if (modal_result=mrOK) then begin
            Macros.StartRecording(fActiveEditor, MacroName, Key, Shift);
            fActiveEditor.MacroIsRecording:=TRUE;
          end;
        finally
          Free;
        end;
      end;
    end else begin
      if Macros.StopRecording(fActiveEditor) then
        fActiveEditor.MacroIsRecording:=FALSE;
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acPlayMacroExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) and (not fActiveEditor.Locked) then begin
    with TfmMacroSelect.Create(SELF) do
      try
        ShowModal;
        if Assigned(SelectedMacro) then
          macros.Play(fActiveEditor, SelectedMacro^.Key, SelectedMacro^.Shift);
      finally
        Free;
      end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acManageMacrosExecute(Sender: TObject);
begin
  with TfmMacroManage.Create(SELF) do
    try
      ShowModal;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acUserCommandExecute(Sender: TObject);
var
  lines :TStringList;
  fname :string;
begin 
  if PrjManager.Active and (PrjManager.MakeFile<>nil) and
     (not Assigned(fActiveEditor) or (Assigned(fActiveEditor) and fActiveEditor.ProjectFile)) then begin
    fname:=PrjManager.MakeFile.FileName;
    lines:=TStringList.Create;
    try
      lines.LoadFromFile(fname);
      ExecUserCommand(nil, lines, TComponent(Sender).Tag-1, fname);
    except
      DlgErrorOpenFile(fname);
    end;
    lines.Free;
  end else begin
    if Assigned(fActiveEditor) and not (fActiveEditor.Unnamed) then
      ExecUserCommand(fActiveEditor, fActiveEditor.memo.Lines, TComponent(Sender).Tag-1, fActiveEditor.FileName);
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acShellExecuteExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.ShellExecFile;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acHTMLTidyExecute(Sender: TObject);
begin
  {$IFDEF SUPPORTS_HTML_TIDY}
    UpdateHTMLTidyProfiles;
  {$ENDIF}
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acHTMLTidyManageExecute(Sender: TObject);
begin
  {$IFDEF SUPPORTS_HTML_TIDY}
    CreateHTMLTidyManageProfilesDialog;
  {$ENDIF}
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acFileCompareExecute(Sender: TObject);
begin
  with TfmFileCompare.Create(SELF) do
    try
      ShowModal;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acTextStatisticsExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    CreateTextStatsDialog(fActiveEditor);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acCustomizeTypesExecute(Sender: TObject);
var
  ed :TfmEditor;
  n  :integer;
  HL :TSynCustomHighLighter;
begin
  with TfmCustomizeType.Create(SELF) do
    try
      ShowModal;

      if (modal_result=mrOK) then begin
        n:=0;
        while Enum(ed, n) do
          SetHighlighter(ed, ed.FileName);

        // iz nekog razloga nestane cursor u aktivnom editoru pa �emo ga ovako vratiti... bug?
        if Assigned(fActiveEditor) then begin
          HL:=fActiveEditor.memo.Highlighter;
          fActiveEditor.memo.Highlighter:=nil;
          fActiveEditor.memo.Highlighter:=HL;
        end;
        SaveChangedCustomHighlighters;
      end;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acSetHighlighterExecute(Sender: TObject);
var
  i  :integer;
  n  :integer;
  HL :TSynCustomHighLighter;
begin
  if not Assigned(fActiveEditor) then EXIT;

  if (Sender=acSetHighlighter) then begin
    for i:=0 to groupHighlighters.Count-1 do
      groupHighlighters.Items[i].Checked:=(integer(fActiveEditor.memo.HighLighter)=groupHighlighters.Items[i].Tag);
  end else begin
    HL:=nil;

    if (Sender=cbHighLighters) then begin
      HL:=TSynCustomHighLighter(cbHighlighters.Strings.Objects[cbHighlighters.ItemIndex]);
    end else begin
      if (TTBXItem(Sender).Tag<>0) then
        HL:=TSynCustomHighLighter(TTBXItem(Sender).Tag);
    end;

    if Assigned(HL) then begin
      n:=0;
      while (n<HIGHLIGHTERS_COUNT) do begin
        if (HighLighters[n].HL=HL) then begin
          SetHighlighter(fActiveEditor, fActiveEditor.FileName, @HighLighters[n]);
          BREAK;
        end;
        inc(n);
      end;

      fActiveEditor.ApplyOtherHLColors(fActiveEditor.memo.HighLighter);

      if (Sender=cbHighLighters) then
        SendMessage(fActiveEditor.Handle, WM_SETFOCUS,0,0);
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acConversionExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) and (not fActiveEditor.Locked) then begin
    if (Sender=acConversion) then begin
      acConvertToDOS.Checked:=(fActiveEditor.TextFormat=tfNormal);
      acConvertToUnicode.Checked:=(fActiveEditor.TextFormat=tfUnicode);
      acConvertToUNIX.Checked:=(fActiveEditor.TextFormat=tfUNIX);
      acConvertToMAC.Checked:=(fActiveEditor.TextFormat=tfMAC);
    end else
      if (Sender=acConvertToDOS) then
        fActiveEditor.TextFormat:=tfNormal
      else
        if (Sender=acConvertToUnicode) then
          fActiveEditor.TextFormat:=tfUnicode
        else
          if (Sender=acConvertToUNIX) then
            fActiveEditor.TextFormat:=tfUNIX
          else
            if (Sender=acConvertToMAC) then
              fActiveEditor.TextFormat:=tfMAC;
  end;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - OPTIONS
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acPreferencesExecute(Sender: TObject);
begin
  with TfmOptions.Create(SELF) do
    try
      if Assigned(fActiveEditor) then
        ActiveHighlighter:=fActiveEditor.memo.Highlighter
      else
        ActiveHighlighter:=nil;

      ShowModal;
    finally
      Free;
    end;

  SaveChangedCustomHighlighters;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acCodeTemplateExecute(Sender: TObject);
begin
  with TfmCodeTemplate.Create(SELF) do
    try
      if Assigned(fActiveEditor) then
        ActiveHighlighter:=fActiveEditor.memo.Highlighter
      else
        ActiveHighlighter:=nil;

      ShowModal;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acWordwrapExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.Wordwrap:=not fActiveEditor.Wordwrap;
  {
  EditorCfg.RightEdgeVisible:=not EditorCfg.RightEdgeVisible;
  miWordwrap.Checked:=EditorCfg.RightEdgeVisible;
  ApplyEditorOptions;
  }
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acViewRulerExecute(Sender: TObject);
begin
  EditorCfg.RulerVisible:=not EditorCfg.RulerVisible;
  ApplyEditorOptions;
  OptionsChanged:=TRUE;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acStayOnTopExecute(Sender: TObject);
begin
  StayOnTop:=not StayOnTop;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acExportRegistrySettingsExecute(Sender: TObject);
begin
  SaveSettings;
  ExportRegSettings;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - WINDOW
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acWindowExecute(Sender: TObject);
var
  n: integer;
  ed: TfmEditor;
  Item: TTBXItem;
  str: TStringList;
begin
  groupOpenWindows.Clear;

  n:=0;
  str:=GetEditorStrList;
  try
    while (n<str.Count) and (n<9) do begin
      ed:=TfmEditor(str.Objects[n]);
      if Assigned(ed) then begin
        Item:=TTBXItem.Create(SELF);
        Item.OnClick:=WindowMenu_OnClick;
        Item.Checked:=(ed=fActiveEditor);
        Item.Caption:=Format('&%d %s',[n+1, ed.FileName]);
        Item.Tag:=integer(ed);
        groupOpenWindows.Add(Item);
        inc(n);
      end;
    end;
  finally
    str.Free;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.WindowMenu_OnClick(Sender: TObject);
begin
  if Assigned(TTBXItem(Sender).Owner) then
    BringEditorToFront(TfmEditor(TTBXItem(Sender).Tag));
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acCascadeExecute(Sender: TObject);
begin
  Cascade;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acTileHorizontalExecute(Sender: TObject);
begin
  TileMode:=tbHorizontal;
  Tile;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acTileVerticalExecute(Sender: TObject);
begin
  TileMode:=tbVertical;
  Tile;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acNextWindowExecute(Sender: TObject);
begin
  Next;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acPreviousWindowExecute(Sender: TObject);
begin
  Previous;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - HELP
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acHelpOnKeywordExecute(Sender: TObject);
begin
  if Assigned(fActiveEditor) then
    fActiveEditor.InvokeHelpFile;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acHelpContentsExecute(Sender: TObject);
begin
  Application.HelpCommand(HELP_FINDER, 0);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acAboutExecute(Sender: TObject);
begin
  with TfmAbout.Create(SELF) do
    try
      ShowModal;
    finally
      Free;
    end;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                   Actions - OTHER
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.acTrayRestoreExecute(Sender: TObject);
begin
  ShowWindow(Application.Handle, SW_SHOWNORMAL);

  TrayIcon.Active:=FALSE;
  SetForegroundWindow(Application.Handle);
  Application.BringToFront;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.acCloseBottomWindowExecute(Sender: TObject);
begin
  if Assigned(ActiveEditor) and Assigned(ActiveEditor.IncrementalSearchPanel) then
    ActiveEditor.IncrementalSearchPanel.Free
  else
    BottomWindowVisible:=FALSE;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                     Menu events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.mruFilesClick(Sender: TObject; const Filename: String);
begin
  OpenFile(Filename);
  UpdateHistoryPanel;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.mruProjectsClick(Sender: TObject; const Filename: String);
begin
  OpenProjectFile(FileName,TRUE);
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                 FileTabs Events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.tabFilesChange(Sender: TObject);
var
  ed :TfmEditor;
begin
  ed:=TfmEditor(tabFiles.Tabs.Objects[tabFiles.TabIndex]);

  if Assigned(ed) then
    BringEditorToFront(ed);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.tabFilesMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  ClickedTabIndex: integer;
begin
  ClickedTabIndex:=tabFiles.GetTabAt(X, Y);

  if (ClickedTabIndex<>-1) then begin
    case Button of
      mbLeft:
        begin
          if (ssShift in Shift) and (EnvOptions.ShiftClickClosesFileTab) then
            TfmEditor(tabFiles.Tabs.Objects[ClickedTabIndex]).Close;
        end;
      mbRight:
        begin
          tabFiles.TabIndex:=ClickedTabIndex;
          tabFilesChange(SELF);
        end;
    end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.tabFilesChanging(Sender: TObject; var AllowChange: Boolean);
begin
  AllowChange:=FALSE;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.tabFilesMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  tabFiles.AllowTabShifting:=not (GetKeyState(VK_SHIFT));
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.tabFilesMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.tabFilesTabShift(Sender: TObject);
var
  i: integer;
  Editor: TfmEditor;
begin
  tabFiles.ImageIndexes.BeginUpdate;
  tabFiles.TabHints.BeginUpdate;

  try
    tabFiles.ImageIndexes.Clear;
    tabFiles.TabHints.Clear;

    for i:=0 to tabFiles.Tabs.Count-1 do begin
      Editor:=TfmEditor(tabFiles.Tabs.Objects[i]);
      tabFiles.TabHints.Add(Editor.FileName);

      if Editor.NewFile then
        tabFiles.ImageIndexes.Add(IntToStr(FileIconPool.NewFileIndex))
      else
        tabFiles.ImageIndexes.Add(IntToStr(FileIconPool.GetIconIndex(Editor.FileName)));
    end;

  finally
    UpdateTabsSize;
    tabFiles.ImageIndexes.EndUpdate;
    tabFiles.TabHints.EndUpdate;
  end;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                     Events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.pnMainStatusResize(Sender: TObject);
begin
  // XP Repaint bug
  with (Sender as TStatusBar) do
    if HandleAllocated then
     InvalidateRect(Handle, nil, True);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.dpFilePanelClose(Sender: TObject);
begin
  fFilePanelVisible:=FALSE;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.dpBottomClose(Sender: TObject);
begin
  fBottomWindowVisible:=FALSE;
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                 Drag and drop
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.FormDragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
  Accept:=Assigned(FilePanel) and Assigned(FilePanel.DragFiles);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.FormDragDrop(Sender, Source: TObject; X, Y: Integer);
begin
  if Assigned(FilePanel.DragFiles) then
    OpenMultipleFiles(FilePanel.DragFiles.FileList);
end;
//------------------------------------------------------------------------------------------


////////////////////////////////////////////////////////////////////////////////////////////
//                                  Form events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------
procedure TfmMain.FormShortCut(var Msg: TWMKey; var Handled: Boolean);
var
  key :integer;
  ss  :TShiftState;
begin
  key:=TranslateShortcut(Msg,ss);

  case key of
    // brzo selektiranje editora
    ord('0')..ord('9'):
      if (ss=[ssAlt]) then begin
        dec(key,ord('0')+1);
        if (key<0) then key:=9;

        if (key<tabFiles.Tabs.Count) then begin
          tabFiles.TabIndex:=key;
          tabFilesChange(SELF);
        end;
        Handled:=TRUE;
      end;
    // full screen on/off
    VK_RETURN:
      if (ss=[ssAlt]) then begin
        FullScreen:=not FullScreen;
        Handled:=TRUE;
      end;
  end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.FormCreate(Sender: TObject);
begin
  LoadSysTrayIcon;
  LoadLanguageConfig;

  FFileIconPool:=TFileIconPool.Create;
  FilePosHistory:=TFilePosHistory.Create;
  PrjManager:=TProjectManager.Create(tabFiles);

  FUserCommandCtrl[0].mi:=miUserCommand1; FUserCommandCtrl[0].action:=acUserCommand1;
  FUserCommandCtrl[1].mi:=miUserCommand2; FUserCommandCtrl[1].action:=acUserCommand2;
  FUserCommandCtrl[2].mi:=miUserCommand3; FUserCommandCtrl[2].action:=acUserCommand3;
  FUserCommandCtrl[3].mi:=miUserCommand4; FUserCommandCtrl[3].action:=acUserCommand4;

  CreateMutex(nil, FALSE, 'ConTEXTEditorMutex');

  acNew.Hint:=mlStr(ML_MAIN_TB_HINT_NEW, 'New file');
  acOpen.Hint:=mlStr(ML_MAIN_TB_HINT_OPEN, 'Open file');
  acSave.Hint:=mlStr(ML_MAIN_TB_HINT_SAVE, 'Save file');
  acSaveAllFiles.Hint:=mlStr(ML_MAIN_TB_HINT_SAVE_ALL, 'Save all files');
  acClose.Hint:=mlStr(ML_MAIN_TB_HINT_CLOSE, 'Close file');
  acPrint.Hint:=mlStr(ML_MAIN_TB_HINT_PRINT, 'Print file');
  acPrintPreview.Hint:=mlStr(ML_MAIN_TB_HINT_PRINT_PREVIEW, 'Print preview');
  acEditCut.Hint:=mlStr(ML_MAIN_TB_HINT_CUT, 'Cut selected text to clipboard');
  acEditCopy.Hint:=mlStr(ML_MAIN_TB_HINT_COPY, 'Copy selected text to clipboard');
  acEditPaste.Hint:=mlStr(ML_MAIN_TB_HINT_PASTE, 'Paste text from clipboard');
  acEditUndo.Hint:=mlStr(ML_MAIN_TB_HINT_UNDO, 'Undo');
  acEditRedo.Hint:=mlStr(ML_MAIN_TB_HINT_REDO, 'Redo');
  acEditFind.Hint:=mlStr(ML_MAIN_TB_HINT_FIND, 'Find text');
  acEditFindNext.Hint:=mlStr(ML_MAIN_TB_HINT_FIND_NEXT, 'Find next occurence');
  acEditReplace.Hint:=mlStr(ML_MAIN_TB_HINT_REPLACE, 'Replace text');
  acWordwrap.Hint:=mlStr(ML_MAIN_TB_HINT_WORDWRAP, 'Word wrap');
  acStayOnTop.Hint:=mlStr(ML_MAIN_TB_HINT_STAY_ON_TOP, 'Stay on top');
  cbHighlighters.Hint:=mlStr(ML_MAIN_TB_HINT_ACTIVE_HIGHLIGHTER, 'Select active highlighter');
  acHelp.Hint:=mlStr(ML_MAIN_TB_HINT_HELP, 'Help');

  dpFilePanel.Caption:=mlStr(ML_EXPL_CAPTION, 'File Panel');

  TbxSwitcher.Theme:='OfficeXP';

  {$IFDEF SUPPORTS_HTML_TIDY}
    HTMLTidy:=THTMLTidy.Create;
    acHTMLTidy.Visible:=TRUE;
    acHTMLTidyManage.Visible:=TRUE;
  {$ELSE}
    acHTMLTidy.Visible:=FALSE;
    acHTMLTidyManage.Visible:=FALSE;
  {$ENDIF}
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.DoCommandLine;
var
  i   :integer;
  str :TStringList;
  ed  :TfmEditor;
begin
  SetCurrentDir(StartDir);

  str:=TStringList.Create;
  for i:=1 to ParamCount do
    str.Add(ParamStr(i));

  CmdLine_Init;

  if not CmdLine_Analyze(str) then begin
    case EnvOptions.StartAction of
      saNone:
        ;
      saCreateNewDocument:
        begin
          acNewExecute(SELF);
          fActiveEditor.DefaultEmptyFile:=TRUE;
        end;
      saOpenLastFiles:
        begin
          if (Length(EditorCfg.LastOpenProject)>0) and FileExists(EditorCfg.LastOpenProject) then
            OpenProjectFile(EditorCfg.LastOpenProject);
          OpenMultipleFiles(EditorCfg.LastOpenFilesList, TRUE);

          if (Length(EditorCfg.LastActiveFile)>0) then begin
            ed:=FindOpenedFile(EditorCfg.LastActiveFile);
            if Assigned(ed) then
            BringEditorToFront(ed, TRUE);
          end;
        end;
    end;
  end else
    CmdLine_Execute;

  CmdLine_Done;
  str.Free;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.FormShow(Sender: TObject);
const
  FirstStart :boolean = TRUE;
begin
  if FirstStart then begin
    FirstStart:=FALSE;

    GetDefaultAnimation;
    SetAnimation(FALSE);

    DefineHighlighters;
    CreateBookmarkMenuItems;
    EditorCfg.LastOpenFilesList:=TStringList.Create;

    LoadSettings;

    Macros:=TMacros.Create;

    DoCommandLine;
    SetAnimation(TRUE);

    Application.OnActivate:=OnApplicationActivate;
    Application.OnDeactivate:=OnApplicationDeactivate;
    Application.OnMinimize:=OnApplicationMinimize;
    Application.OnMessage:=AppMessage;

    Application.HelpFile:=ApplicationDir+'ConTEXT.hlp';

    PrepareAppForLargeFontMess;

    if EnvOptions.RememberLastDir then
      SetCurrentDir(EnvOptions.LastDir);

  ////////////////////////////////////////////////////////////////////////
  //  mlExtractAllComponents(StartDir+'language\components.txt');
  ////////////////////////////////////////////////////////////////////////

    DragAcceptFiles(Handle, TRUE);

    if fFormInitialMaximized then begin
      LockPainting(FALSE);
      WindowState:=wsMaximized;
      UnlockPainting(FALSE);
    end;
 end;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin
  Resize:=NewWidth>300;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.FormResize(Sender: TObject);
begin
  UpdateTabsSize;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.FormClose(Sender: TObject; var Action: TCloseAction);
var
  H :hWnd;
begin
  ExitingContext:=TRUE;

  SaveSettings;

  FreeAndNil(Macros);

  PrjManager.UpdateAllEditors;
  PrjManager.Close(FALSE);

  FreeAndNil(FilePosHistory);
  FreeAndNil(PrjManager);

  if Assigned(FFilePanel) then
    FreeAndNil(FFilePanel);

  FreeAndNil(EditorCfg.LastOpenFilesList);
  FreeAndNil(FFileIconPool);

  uCodeTemplate.DestroyAllTemplates;
  FreeCustomHighlighters;

  if Assigned(KeyMap) then
    FreeAndNil(KeyMap);

  if Assigned(KeyMapDefault) then
    FreeAndNil(KeyMapDefault);

  StayOnTop:=FALSE;
  SetAnimation(TRUE);

  // iz nekog razloga, nakon postavljanja trayicon komponente, kad se ugasi context
  //  nijedna aplikacija nema fokus. ovime cemo uzeti sljedeci prozor ispod contexta
  //  i postaviti mu focus prije gasenja
  H:=GetNextWindow(SELF.Handle, GW_HWNDNEXT);
  SetForegroundWindow(H);
end;
//------------------------------------------------------------------------------------------
destructor TfmMain.Destroy;
begin
  if Assigned(fmBottomWindowContainer) then
    FreeAndNil(fmBottomWindowContainer);

  inherited;
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.OnApplicationActivate(Sender: TObject);
begin
  PostMessage(Handle, WM_CHECK_FILETIMES, 0, 0);
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.OnApplicationDeactivate(Sender: TObject);
begin
end;
//------------------------------------------------------------------------------------------
procedure TfmMain.OnApplicationMinimize(Sender: TObject);
begin
  if EnvOptions.MinimizeToTray then begin
    TrayIcon.Active:=TRUE;
    TrayIcon.ToolTip:=Caption;
    ShowWindow(Application.Handle, SW_HIDE);
  end;
end;
//------------------------------------------------------------------------------------------

end.
