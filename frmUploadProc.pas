unit frmUploadProc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, AdvUtil, Vcl.ExtCtrls, Vcl.StdCtrls,
  DB, DBAdvGrid, Vcl.Grids, AdvObj, BaseGrid, AdvGrid, scControls, scGPControls,
  Data.Bind.EngExt, Vcl.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs, Vcl.Bind.Editors,
  tmsAdvGridExcel, Data.Bind.Components, uConst, uDM, ShlObj, ShellAPI, Soap.EncdDecd;

type
  TUpload = class(TForm)
    Panel7: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    lblSelectedTable: TLabel;
    Label15: TLabel;
    lblSelectedColumn: TLabel;
    Label20: TLabel;
    btnUploadFolder: TscGPGlyphButton;
    edtUploadFolder: TEdit;
    btnDisconnect: TButton;
    edtUploadFile: TEdit;
    btnUploadFile: TscGPGlyphButton;
    AdvStringGrid1: TAdvStringGrid;
    btnConnect: TButton;
    btnUploadInit: TButton;
    btnUpload: TButton;
    ListBox1: TListBox;
    DBAdvGrid1: TDBAdvGrid;
    btnUploadImage: TButton;
    Panel8: TPanel;
    mmUploadLog: TMemo;
    Splitter4: TSplitter;
    BindingsList1: TBindingsList;
    LinkFillControlToPropertyCaption: TLinkFillControlToProperty;
    AdvGridExcelIO1: TAdvGridExcelIO;
    ProgressTimer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure btnDisconnectClick(Sender: TObject);
    procedure btnUploadFolderClick(Sender: TObject);
    procedure btnUploadFileClick(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure btnUploadImageClick(Sender: TObject);
    procedure btnUploadClick(Sender: TObject);
    procedure ProgressTimerTimer(Sender: TObject);
    procedure AdvStringGrid1ClickCell(Sender: TObject; ARow, ACol: Integer);
  private
    procedure ClearComponents(caArea: TClearArea);
    procedure MakeQryList(var slQryList: TStringList; const infoTable: TInfoTable);
    procedure MakeUpdQryList(var slQryList: TStringList; const infoTable: TInfoTable);
    function DoSearch(const Path: string; const FileExts: TStringList; const afAction: TActFunction): Boolean;
    function FindAllFiles(const Path, FileExt: string; const afAction: TActFunction): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Upload: TUpload;
  slQueryList: TStringList;
  InfoTable: TInfoTable;
  gSelectedTable: string;
  gSelectedColumn: Integer;
  gProgressBarMax, gProgressBarNow: Integer;

implementation

uses
  uQuery, frmMain;

{$R *.dfm}

procedure TUpload.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(DM) then DM.Free;
  Action := caFree;
end;

procedure TUpload.FormCreate(Sender: TObject);
begin
  DM := TDM.Create(nil);
end;

procedure TUpload.FormShow(Sender: TObject);
begin
  ClearComponents(caUpload);
  DM.qryDBGrid.SQL.Clear;
end;

procedure TUpload.ListBox1DblClick(Sender: TObject);
var
  i: Integer;
begin
  if not DM.UniConnection1.Connected then
    Exit;

  if ListBox1.ItemIndex = -1 then
    Exit;

  gSelectedTable := TListBox(Sender).Items[TListBox(Sender).ItemIndex];

  with DM.qryDBGrid do
  begin
    Close;
    SQL.Text := 'select * from ' + gSelectedTable + ' where rownum = 1';
    Open;
  end;
  DBAdvGrid1.AutoSize := True;

  // Col count 만큼 돌면서 컬럼명 및 데이터 타입 저장
//  ShowMessage(IntToStr(DBAdvGrid1.ColCount));
  SetLength(InfoTable.colInfo, 0);
  SetLength(InfoTable.colInfo, DBAdvGrid1.ColCount - 1);
  InfoTable.tableName := gSelectedTable;
  InfoTable.colCount := DBAdvGrid1.ColCount - 1;
  InfoTable.blobCount := 0;
  for i := Low(InfoTable.colInfo) to High(InfoTable.colInfo) do
  begin
    InfoTable.colInfo[i].colName := DBAdvGrid1.Columns[i + 1].FieldName;
    InfoTable.colInfo[i].colType := DBAdvGrid1.Columns[i + 1].Field.DataType;
    InfoTable.colInfo[i].colLength := DBAdvGrid1.Columns[i + 1].Field.DataSize;
    InfoTable.colInfo[i].blobFinish := False;
    if DBAdvGrid1.Columns[i + 1].Field.DataType in [ftBlob, ftOraBlob] then
      Inc(InfoTable.blobCount);
  end;
end;

procedure TUpload.AdvStringGrid1ClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  if ARow > 0 then Exit;

  if MessageDlg('선택하신 컬럼과 이미지 폴더가 같아야 합니다. ' + sLineBreak + AdvStringGrid1.Cells[ACol, 0] + '컬럼이 맞습니까?', mtConfirmation, mbYesNo, 0) = mrYes then
  begin
    lblSelectedColumn.Caption := AdvStringGrid1.Cells[ACol, 0];
    gSelectedColumn := ACol;
  end;
end;

procedure TUpload.btnConnectClick(Sender: TObject);
begin
  if DM.UniConnection1.Connected then
  begin
    if MessageDlg('Aleady connected. Would you like to disconnect?', mtConfirmation, mbYesNo, 0) = mrYes then
    begin
      DM.UniConnection1.Disconnect;
      Exit;
    end;
  end
  else
  begin
    if not DM.fn_SetDBConnect then
    begin
      ShowMessage('Cannot Connect DB Server!');
      Exit;
    end
    else
    begin
      ListBox1.Items.Clear;

      // Show DB Tables in ListView
      with DM.qryTables do
      begin
        Close;
        SQL.Text := SEL_TABLENAMES;
        ParamCheck := True;
        ParamByName('user_id').AsString := DM.UniConnection1.Username;
        Open;
        First;

        while not Eof do
        begin
          ListBox1.Items.Add(FieldByName('TABLE_NAME').AsString);
          Next;
        end;
      end;
    end;
  end;
end;

procedure TUpload.btnDisconnectClick(Sender: TObject);
begin
  DM.UniConnection1.Disconnect;
end;

procedure TUpload.btnUploadClick(Sender: TObject);
var
  i, j: Integer;
  iCnt: Integer;
  sQuery: string;
begin
  if (AdvStringGrid1.RowCount < 2) or (Trim(AdvStringGrid1.Cells[0, 1]) = '') then
  begin
    ShowMessage('엑셀파일을 먼저 선택하세요!');
    Exit;
  end;

  if (DBAdvGrid1.RowCount < 2) or (Trim(DBAdvGrid1.Cells[1, 0]) = '') then
  begin
    ShowMessage('입력할 테이블을 선택하세요!');
    Exit;
  end;

  // 불러온 엑셀파일의 헤더와 컬럼명이 맞는지 비교
  for j := Low(InfoTable.colInfo) to High(InfoTable.colInfo) do
  begin
    if not InfoTable.colInfo[j].colName.Equals(AdvStringGrid1.Cells[j, 0]) then
    begin
      ShowMessage('선택한 테이블과 엑셀파일이 일치하지 않습니다. 다시 시도해 주십시오.');
      Exit;
    end;
  end;

  // StartProgress
  gProgressBarMax := AdvStringGrid1.RowCount - 1;
  Main.pgBar.MaxValue := gProgressBarMax;
  gProgressBarNow := 0;
  ProgressTimer.Enabled := True;

  try
    // 불러온 엑셀파일의 데이터를 DB에 저장
    if not DM.UniConnection1.InTransaction then
      DM.UniConnection1.StartTransaction;

    slQueryList := TStringList.Create;
    try
    // 엑셀 Row별 쿼리 생성 후 StringList 에
      MakeQryList(slQueryList, InfoTable);
//      mmUploadLog.Lines.Add(slQueryList.Text);
      for sQuery in slQueryList do
      begin
        DM.qryCRUD.SQL.Text := sQuery;
        DM.qryCRUD.ExecSQL;
        Inc(gProgressBarNow);
      end;
    finally
      slQueryList.Free;
    end;

    iCnt := DM.qryCRUD.RowsAffected;
    DM.UniConnection1.Commit;
    mmUploadLog.Lines.Add('업로드가 완료 되었습니다.');
    ProgressTimer.Enabled := False;
  except
    on E: Exception do
    begin
      mmUploadLog.Lines.Add(E.Message + ' :: ' + DM.qryCRUD.SQL.Text);
      if DM.UniConnection1.InTransaction then
        DM.UniConnection1.Rollback;
      ProgressTimer.Enabled := False;
    end;
  end;
end;

procedure TUpload.btnUploadFileClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
  try
    Title := 'Select Excel File';
    Options := [fdoFileMustExist, fdoForceFileSystem]; // YMMV

    DefaultFolder := GetCurrentDir;
    FileName := GetCurrentDir;
    with FileTypes.Add do
    begin
      DisplayName := 'All Files';
      FileMask := '*.*';
    end;
    with FileTypes.Add do
    begin
      DisplayName := 'Excel Files';
      FileMask := '*.xlsx;*.xls';
    end;

    if Execute then
    begin
      if TButton(Sender).Name = 'btnUploadFile' then
        edtUploadFile.Text := FileName;

      if edtUploadFile.Text <> '' then
      begin
        AdvStringGrid1.LoadFromXLS(edtUploadFile.Text);
        AdvStringGrid1.AutoSize := True;
      end;
    end;
  finally
    Free;
  end;
end;

procedure TUpload.btnUploadFolderClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
  try
    Title := 'Select Directory';
    Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem]; // YMMV
    DefaultFolder := GetCurrentDir;
    FileName := GetCurrentDir;
    if Execute then
    begin
      if TButton(Sender).Name = 'btnUploadFolder' then
        edtUploadFolder.Text := FileName;
    end;
  finally
    Free;
  end;
end;

procedure TUpload.btnUploadImageClick(Sender: TObject);
var
  i, iCnt: Integer;
  slAllFiles: TStringList;
  slTargetPaths: TStringList;
begin
  if (AdvStringGrid1.RowCount < 2) or (Trim(AdvStringGrid1.Cells[1, 1]) = '') then
  begin
    ShowMessage('엑셀파일을 먼저 선택하세요!');
    Exit;
  end;

  if (DBAdvGrid1.RowCount < 2) or (Trim(DBAdvGrid1.Cells[1, 0]) = '') then
  begin
    ShowMessage('입력할 테이블을 선택하세요!');
    Exit;
  end;

  if edtUploadFolder.Text = '' then
  begin
    ShowMessage('이미지 폴더를 입력하세요.');
    edtUploadFolder.SetFocus;
    Exit;
  end;

  if lblSelectedColumn.caption = '' then
  begin
    ShowMessage('그리드에서 폴더명과 일치시킬 컬럼을 선택하세요.');
    AdvStringGrid1.SetFocus;
    Exit;
  end;

  // 초기화
  for i := Low(InfoTable.colInfo) to High(InfoTable.colInfo) do
  begin
    if (InfoTable.colInfo[i].colType in [ftBlob, ftOraBlob]) then
    begin
      InfoTable.colInfo[i].blobFinish := False;
    end;
  end;

  slAllFiles := TStringList.Create;
  slAllFiles.Add('jpg');

  try
    if not DM.UniConnection1.Connected then
      DM.UniConnection1.Connect;

    // 불러온 엑셀파일의 데이터를 DB에 저장
//    if not DM.UniConnection1.InTransaction then
//      DM.UniConnection1.StartTransaction;

    slTargetPaths := TStringList.Create;
    slQueryList := TStringList.Create;

    try
      MakeUpdQryList(slQueryList, InfoTable);
//      mmUploadLog.Lines.Add(slQueryList.Text);
      slTargetPaths.Add(edtUploadFolder.Text + '\');

      // Progress 용 카운터
      gProgressBarMax := 0;
      for i := 0 to slTargetPaths.Count - 1 do
      begin
        DoSearch(slTargetPaths.Strings[i], slAllFiles, afProgressCount);
      end;

      if gProgressBarMax > AdvStringGrid1.RowCount - 1 then
        gProgressBarMax := AdvStringGrid1.RowCount - 1;

      // StartProgress
      Main.pgBar.MaxValue := gProgressBarMax;
      gProgressBarNow := 0;
      ProgressTimer.Enabled := True;

      // 실제 업로드 진행
      for i := 0 to slTargetPaths.Count - 1 do
      begin
        DoSearch(slTargetPaths.Strings[i], slAllFiles, afUploadImage);
      end;
    finally
      slQueryList.Free;
      slTargetPaths.Free;
    end;

    iCnt := DM.qryCRUD.RowsAffected;
//    DM.UniConnection1.Commit;
    mmUploadLog.Lines.Add('이미지 업로드가 완료 되었습니다.');
    ProgressTimer.Enabled := False;
  except
    on E: Exception do
    begin
      mmUploadLog.Lines.Add(E.Message + ' :: ' + DM.qryCRUD.SQL.Text);
//      if DM.UniConnection1.InTransaction then
//        DM.UniConnection1.Rollback;
      ProgressTimer.Enabled := False;
    end;
  end;
end;

procedure TUpload.ClearComponents(caArea: TClearArea);
var
  i, j: Integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if caArea in [caAll] then
    begin
      if Components[i].ClassType = TLabel then
      begin
        if Pos('lbl', TLabel(Components[i]).Name) > 0 then
        begin
          TLabel(Components[i]).Caption := '';
        end;
      end
      else if Components[i].ClassType = TButton then
      begin
        if Pos('btn', TEdit(Components[i]).Name) > 0 then
        begin
          TButton(Components[i]).Tag := 0;
        end;
      end
      else if Components[i].ClassType = TEdit then
      begin
        if Pos('edt', TEdit(Components[i]).Name) > 0 then
        begin
          TEdit(Components[i]).Text := '';
        end;
      end
      else if Components[i].ClassType = TMemo then
      begin
        if Pos('mm', TMemo(Components[i]).Name) > 0 then
        begin
          TMemo(Components[i]).Lines.Clear;
        end;
      end;
    end
    else if caArea in [caAction] then
    begin
      if Components[i].ClassType = TLabel then
      begin
        if Pos('lbl', TLabel(Components[i]).Name) > 0 then
        begin
          TLabel(Components[i]).Caption := '';
        end;
      end
      else if Components[i].ClassType = TEdit then
      begin
        if Pos('edt', TEdit(Components[i]).Name) > 0 then
        begin
          TEdit(Components[i]).Text := '';
        end;
      end;
    end
    else if caArea in [caUpload] then
    begin
      if Components[i].ClassType = TLabel then
      begin
        if Pos('lbl', TLabel(Components[i]).Name) > 0 then
        begin
          TLabel(Components[i]).Caption := '';
        end;
      end
      else if Components[i].ClassType = TEdit then
      begin
        if Pos('edt', TEdit(Components[i]).Name) > 0 then
        begin
          TEdit(Components[i]).Text := '';
        end;
      end
      else if Components[i].ClassType = TMemo then
      begin
        if Pos('mm', TMemo(Components[i]).Name) > 0 then
        begin
          TMemo(Components[i]).Lines.Clear;
        end;
      end
      else if Components[i].ClassType = TDBAdvGrid then
      begin
        TDBAdvGrid(Components[i]).ClearAll;
      end
      else if Components[i].ClassType = TAdvStringGrid then
      begin
        TAdvStringGrid(Components[i]).ClearAll;
      end;
    end
    else if caArea in [caImage] then
    begin
      if Components[i].ClassType = TImage then
      begin
        if Pos('img', TLabel(Components[i]).Name) > 0 then
        begin
          TImage(Components[i]).Picture := nil;
        end;
      end;
    end
    else if caArea in [caLog] then
    begin
      if Components[i].ClassType = TMemo then
      begin
        if Pos('mm', TMemo(Components[i]).Name) > 0 then
        begin
          TMemo(Components[i]).Lines.Clear;
        end;
      end;
    end;
  end;
end;

procedure TUpload.MakeQryList(var slQryList: TStringList; const infoTable: TInfoTable);
var
  i, j: Integer;
  sqlInsert, sqlInsertValue: string;
begin
  sqlInsert := 'INSERT INTO ' + infoTable.tableName + ' (';
  for i := Low(infoTable.colInfo) to High(infoTable.colInfo) do
  begin
    sqlInsert := sqlInsert + infoTable.colInfo[i].colName;

    if i = High(infoTable.colInfo) then
      sqlInsert := sqlInsert + ') VALUES ('
    else
      sqlInsert := sqlInsert + ', ';
  end;

  for j := 1 to AdvStringGrid1.RowCount - 1 do
  begin
    sqlInsertValue := '';

    for i := 0 to infoTable.colCount - 1 do
    begin
      if infoTable.colInfo[i].colType = ftString then
        sqlInsertValue := sqlInsertValue + QuotedStr(AdvStringGrid1.Cells[i, j])
      else if infoTable.colInfo[i].colType in [ftDate, ftDateTime] then
      begin
        if AdvStringGrid1.Cells[i, j] = '' then
          sqlInsertValue := sqlInsertValue + 'sysdate'
        else
          sqlInsertValue := sqlInsertValue + 'to_date(' + QuotedStr(AdvStringGrid1.Cells[i, j]) + ', ' + QuotedStr('yyyymmddhh24miss') + ')';
      end
      else if infoTable.colInfo[i].colType in [ftInteger, ftFloat] then
        sqlInsertValue := sqlInsertValue + AdvStringGrid1.Cells[i, j]
      else
      begin
        if Trim(AdvStringGrid1.Cells[i, j]) = '' then
          sqlInsertValue := sqlInsertValue + 'null'
        else
          sqlInsertValue := sqlInsertValue + AdvStringGrid1.Cells[i, j];
      end;

      if i <> infoTable.colCount - 1 then
        sqlInsertValue := sqlInsertValue + ', ';
    end;

    sqlInsertValue := sqlInsert + sqlInsertValue + ')';
    slQryList.Add(sqlInsertValue);
  end;
end;

procedure TUpload.MakeUpdQryList(var slQryList: TStringList; const infoTable: TInfoTable);
var
  i, j: Integer;
  sqlUpdate, sqlUpdateValue: string;
begin
  sqlUpdate := 'UPDATE ' + infoTable.tableName + ' SET ';
  for i := Low(infoTable.colInfo) to High(infoTable.colInfo) do
  begin
    if infoTable.colInfo[i].colType in [ftBlob, ftOraBlob] then
    begin
//      if AdvStringGrid1.ColumnByHeader(infoTable.colInfo[i].colName) < 0 then Continue;
      sqlUpdate := sqlUpdate + infoTable.colInfo[i].colName + ' = :' + LowerCase(infoTable.colInfo[i].colName) + ', ';
    end;

    if i = High(infoTable.colInfo) then
    begin
      sqlUpdate := Copy(sqlUpdate, 1, Length(sqlUpdate) - 2);
      sqlUpdate := sqlUpdate + ' WHERE ' + AdvStringGrid1.Cells[gSelectedColumn, 0] + ' = ';
    end;
  end;

  for j := 1 to AdvStringGrid1.RowCount - 1 do
  begin
    if infoTable.colInfo[gSelectedColumn].colType = ftString then
      sqlUpdateValue := QuotedStr(AdvStringGrid1.Cells[gSelectedColumn, j])
    else
      sqlUpdateValue := AdvStringGrid1.Cells[gSelectedColumn, j];

    sqlUpdateValue := sqlUpdate + sqlUpdateValue;
    slQryList.Add(sqlUpdateValue);
  end;
end;

function TUpload.DoSearch(const Path: string; const FileExts: TStringList; const afAction: TActFunction): Boolean;
var
  SR: TSearchRec;
  i, j: Integer;
  CurFileCount: Integer;
begin
  Result := False;

  Main.lblStatusText.Caption := Path;
  Application.ProcessMessages;

  case afAction of
    afUploadImage:
      begin
        for i := 0 to FileExts.Count - 1 do
        begin
          FindAllFiles(Path, '*.' + FileExts.Strings[i], afUploadImage);
        end;

        // 하위 디렉토리 검색
        if FindFirst(Path + '*.*', faDirectory, SR) = 0 then
        try
          repeat
            if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
            begin
              DoSearch(Path + SR.Name + '\', FileExts, afUploadImage);
            end;
          until (FindNext(SR) <> 0);
        finally
          FindClose(SR);
        end;
      end;
    afProgressCount:
      begin
        for i := 0 to FileExts.Count - 1 do
        begin
          gProgressBarMax := gProgressBarMax + FindAllFiles(Path, '*.' + FileExts.Strings[i], afProgressCount);
        end;

        // 하위 디렉토리 검색
        if FindFirst(Path + '*.*', faDirectory, SR) = 0 then
        try
          repeat
            if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
            begin
              DoSearch(Path + SR.Name + '\', FileExts, afProgressCount);
            end;
          until (FindNext(SR) <> 0);
        finally
          FindClose(SR);
        end;
      end;
  end;

  Result := True;
end;

function TUpload.FindAllFiles(const Path, FileExt: string; const afAction: TActFunction): Integer;
var
  SR: TSearchRec;
  i, j: Integer;
  BlobTag: Integer;
  /////////////////////////
  BlobStream: TMemoryStream;
  BlobString: string;
  BlobBytes: TBytes;
  /////////////////////////
begin
  Result := 0;

  if FindFirst(Path + FileExt, faArchive, SR) = 0 then
  begin
    try
      repeat
        if (FileExt <> '*.*') and (LowerCase(FileExt) <> LowerCase('*' + ExtractFileExt(SR.Name))) then
          Continue;

        if (Path + SR.Name) = Application.ExeName then
          continue;

        Application.ProcessMessages;

        // Separate Action of function
        case afAction of
          afCount, afPreCount, afProgressCount:
            begin
              Inc(Result);
            end;
          afUploadImage:
            begin
              for i := 1 to AdvStringGrid1.RowCount - 1 do
              begin
                if AdvStringGrid1.Cells[gSelectedColumn, i] = ExtractFileName(Copy(Path, 1, Length(Path) - 1)) then
                begin
                  for j := Low(infoTable.colInfo) to High(infoTable.colInfo) do
                  begin
                    if not (infoTable.colInfo[j].colType in [ftBlob, ftOraBlob]) then
                      Continue;
                    if infoTable.colInfo[j].blobFinish then
                      Continue;

                    BlobStream := TMemoryStream.Create;
                    try
                      BlobStream.LoadFromFile(Path + SR.Name);
                      BlobStream.Position := 0;

                      BlobString := EncodeBase64(BlobStream.Memory, BlobStream.Size);
                      BlobString := StringReplace(BlobString, sLineBreak, '', [rfReplaceAll]);

                      SetLength(BlobBytes, Length(BlobString));
                      BlobBytes := TEncoding.UTF8.GetBytes(BlobString);
                    finally
                      BlobStream.Free;
                    end;

                    DM.qryCRUD.SQL.Text := slQueryList[i - 1];
                    DM.qryCRUD.ParamCheck := True;
                    DM.qryCRUD.ParamByName(LowerCase(infoTable.colInfo[j].colName)).ParamType := ptInput;
                    DM.qryCRUD.ParamByName(LowerCase(infoTable.colInfo[j].colName)).DataType := infoTable.colInfo[j].colType;
                    DM.qryCRUD.ParamByName(LowerCase(infoTable.colInfo[j].colName)).AsBytes := BlobBytes;

                    infoTable.colInfo[j].blobFinish := True;
                    Inc(BlobTag);
                    Break;
                  end;
                end;

                if infoTable.blobCount = BlobTag then
                begin
                  DM.qryCRUD.ExecSQL;
                  BlobTag := 0;
                  Inc(gProgressBarNow);
                  for j := Low(infoTable.colInfo) to High(infoTable.colInfo) do
                  begin
                    if (infoTable.colInfo[j].colType in [ftBlob, ftOraBlob]) then
                    begin
                      infoTable.colInfo[j].blobFinish := False;
                    end;
                  end;
                end;
              end;
            end;
        end;

        Application.ProcessMessages;

      until (FindNext(SR) <> 0);
    finally
      FindClose(SR);
    end;
  end;
end;

procedure TUpload.ProgressTimerTimer(Sender: TObject);
begin
  ProgressTimer.Enabled := False;
  Main.pgBar.Value := gProgressBarNow;
  ProgressTimer.Enabled := True;
end;

end.

