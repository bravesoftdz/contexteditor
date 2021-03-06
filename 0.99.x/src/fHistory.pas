// Copyright (c) 2009, ConTEXT Project Ltd
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
// Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
// Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
// Neither the name of ConTEXT Project Ltd nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

unit fHistory;

interface

{$I ConTEXT.inc}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ImgList, ActnList, ComCtrls, uMultiLanguage, TB2MRU,
  Registry, uCommon, uCommonClass, TB2Item, SpTBXItem, TB2Dock, TB2Toolbar;

type
  TfmHistory = class(TForm)
    lv: TListView;
    acHistory: TActionList;
    acRemove: TAction;
    acOpen: TAction;
    acShowPath: TAction;
    acRemoveAll: TAction;
    TBXDock1: TSpTBXDock;
    TBXToolbar1: TSpTBXToolbar;
    TBItemContainer1: TTBItemContainer;
    TBXSubmenuItem1: TSpTBXSubmenuItem;
    TBXItem3: TSpTBXItem;
    TBXItem2: TSpTBXItem;
    TBXItem1: TSpTBXItem;
    TBXSeparatorItem1: TSpTBXSeparatorItem;
    TBXItem4: TSpTBXItem;
    TBXPopupMenu1: TSpTBXPopupMenu;
    procedure FormDeactivate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure acHistoryUpdate(Action: TBasicAction; var Handled: Boolean);
    procedure acOpenExecute(Sender: TObject);
    procedure acRemoveExecute(Sender: TObject);
    procedure acShowPathExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure acRemoveAllExecute(Sender: TObject);
    procedure lvStartDrag(Sender: TObject; var DragObject: TDragObject);
  private
    FPathVisible: boolean;
    FLockUpdate: boolean;
    FFilesMRU: TTBMRUList;

    procedure SetPathVisible(const Value: boolean);
    procedure SetLockUpdate(const Value: boolean);
    procedure ClearList;
    procedure SetFilesMRU(const Value: TStrings);
    procedure LoadConfig;
    procedure SaveConfig;
  public
    procedure UpdateList;
    property FilesMRU: TStrings write SetFilesMRU;
    property LockUpdate: boolean read FLockUpdate write SetLockUpdate;
    property PathVisible: boolean read FPathVisible write SetPathVisible;
  end;

implementation

{$R *.DFM}

uses
  fFilePane, fMain;

////////////////////////////////////////////////////////////////////////////////////////////
//				     Property functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmHistory.SetFilesMRU(const Value: TStrings);
begin
  FFilesMRU.Items := value;
  UpdateList;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.SetPathVisible(const Value: boolean);
var
  i: integer;
  rec: TFileData;
begin
  if (FPathVisible <> Value) then
  begin
    FPathVisible := Value;

    lv.Items.BeginUpdate;
    try
      for i := 0 to lv.Items.Count - 1 do
      begin
        rec := TFileData(lv.Items[i].Data);

        if Value then
          lv.Items[i].Caption := rec.FileName
        else
          lv.Items[i].Caption := ExtractFileName(rec.FileName);
      end;
    finally
      lv.Items.EndUpdate;
    end;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.SetLockUpdate(const Value: boolean);
begin
  if (FLockUpdate <> Value) then
  begin
    FLockUpdate := Value;

    if not Value then
      UpdateList;
  end;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//				                              Functions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmHistory.ClearList;
var
  i: integer;
begin
  lv.Items.BeginUpdate;

  try
    lv.Items.Clear;

    for i := 0 to lv.Items.Count - 1 do
      if Assigned(lv.Items[i].Data) then
        TFileData(lv.Items[i].Data).Free;
  finally
    lv.Items.EndUpdate;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.UpdateList;
var
  SelectedFile: string;
  rec: TFileData;
  i: integer;
  Item: TListItem;
begin
  if LockUpdate then
    EXIT;

  if Assigned(lv.Selected) then
    SelectedFile := UpperCase(TFileData(lv.Selected.Data).FileName)
  else
    SelectedFile := '';

  lv.Items.BeginUpdate;

  ClearList;

  for i := 0 to FFilesMRU.Items.Count - 1 do
  begin
    rec := TFileData.Create(FFilesMRU.Items[i]);

    Item := lv.Items.Add;
    with Item do
    begin
      if PathVisible then
        Caption := rec.FileName
      else
        Caption := ExtractFileName(rec.FileName);
      ImageIndex := rec.IconIndex;
      Data := rec;
    end;

    if (UpperCase(rec.FileName) = SelectedFile) then
      lv.Selected := Item;
  end;

  lv.Items.EndUpdate;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.LoadConfig;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;

  with reg do
  begin
    OpenKey(CONTEXT_REG_KEY + 'FileHistory', TRUE);
    PathVisible := ReadRegistryBool(reg, 'ShowPath', TRUE);
    Free;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.SaveConfig;
var
  reg: TRegistry;
begin
  reg := TRegistry.Create;

  with reg do
  begin
    OpenKey(CONTEXT_REG_KEY + 'FileHistory', TRUE);
    WriteBool('ShowPath', PathVisible);
    Free;
  end;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//				      Actions
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmHistory.acHistoryUpdate(Action: TBasicAction;
  var Handled: Boolean);
begin
  acOpen.Enabled := Assigned(lv.Selected);
  acRemove.Enabled := Assigned(lv.Selected);
  acRemoveAll.Enabled := lv.Items.Count > 0;
  acShowPath.Checked := fPathVisible;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.acOpenExecute(Sender: TObject);
var
  i: integer;
  str: TStringList;
  rec: TFileData;
begin
  str := TStringList.Create;

  try
    for i := 0 to lv.Items.Count - 1 do
      if (lv.Items[i].Selected) then
      begin
        rec := TFileData(lv.Items[i].Data);
        if Assigned(rec) then
          str.Add(rec.FileName);
      end;
    fmMain.OpenMultipleFiles(str);
  finally
    str.Free;
  end;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.acRemoveExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lv.Items.Count - 1 do
    if lv.Items[i].Selected then
      FFilesMRU.Remove(TFileData(lv.Items[i].Data).FileName);

  UpdateList;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.acRemoveAllExecute(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to lv.Items.Count - 1 do
    FFilesMRU.Remove(TFileData(lv.Items[i].Data).FileName);

  ClearList;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.acShowPathExecute(Sender: TObject);
begin
  PathVisible := not PathVisible;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//                                       lv events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmHistory.lvStartDrag(Sender: TObject;
  var DragObject: TDragObject);
var
  str: TStringList;
  rec: TFileData;
  i: integer;
begin
  with lv do
  begin
    if (SelCount > 1) then
      DragCursor := crMultiDrag
    else
      DragCursor := crDrag;
  end;

  str := TStringList.Create;
  for i := 0 to lv.Items.Count - 1 do
    if lv.Items[i].Selected then
    begin
      rec := TFileData(lv.Items[i].Data);
      if not rec.IsDirectory then
        str.Add(rec.FileName);
    end;

  TFilePanelDragFiles.Create(fmMain.FilePanel, lv, str);
  str.Free;
end;
//------------------------------------------------------------------------------------------

////////////////////////////////////////////////////////////////////////////////////////////
//				     Form events
////////////////////////////////////////////////////////////////////////////////////////////
//------------------------------------------------------------------------------------------

procedure TfmHistory.FormCreate(Sender: TObject);
begin
  lv.SmallImages := fmMain.FileIconPool.ImageList;

  LoadConfig;

  acOpen.Hint := mlStr(ML_EXPL_HINT_OPEN, 'Open selected files');
  acRemove.Hint := mlStr(ML_EXPL_HINT_REMOVE,
    'Remove selected files from list');
  acRemoveAll.Hint := mlStr(ML_EXPL_HINT_REMOVE_ALL,
    'Remove all files from list');
  acShowPath.Hint := mlStr(ML_EXPL_HINT_TOGGLEPATH, 'Toggle show/hide path');

  acOpen.Caption := mlStr(ML_FAV_OPEN, '&Open');
  acRemove.Caption := mlStr(ML_FAV_REMOVE, '&Remove');
  acRemoveAll.Caption := mlStr(ML_FAV_REMOVE_ALL, 'Remove A&ll');
  acShowPath.Caption := mlStr(ML_FAV_SHOW_PATH, '&Show Path');
  FFilesMRU := TTBMRUList.Create(self);
  FFilesMRU.MaxItems := 99; // will only be loaded with maxitems from main screen
  FFilesMRU.AddFullPath := true;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.FormActivate(Sender: TObject);
begin
  acHistory.State := asNormal;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.FormDeactivate(Sender: TObject);
begin
  acHistory.State := asSuspended;
end;
//------------------------------------------------------------------------------------------

procedure TfmHistory.FormDestroy(Sender: TObject);
begin
  SaveConfig;
  ClearList;
end;
//------------------------------------------------------------------------------------------

end.

