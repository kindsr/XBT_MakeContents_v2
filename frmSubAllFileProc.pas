unit frmSubAllFileProc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, scControls, scGPControls,
  Vcl.StdCtrls, Vcl.ExtCtrls, uConst, ShlObj, ShellAPI, StrUtils, uFunction;

type
  TAllFileProc = class(TForm)
    Panel6: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label19: TLabel;
    edtPath: TEdit;
    btnResizeAllImage: TButton;
    Button2: TButton;
    mmResizeLog: TMemo;
    edtResizeAllWidth: TEdit;
    edtSubFolder: TEdit;
    btnOpenFolder: TscGPGlyphButton;
    btnRenameOnly: TButton;
    btnSeperateImage: TButton;
    btnDevide: TButton;
    edtRenStart: TEdit;
    btnCompareWH: TButton;
    ProgressTimer: TTimer;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure btnResizeAllImageClick(Sender: TObject);
    procedure ProgressTimerTimer(Sender: TObject);
    procedure btnSeperateImageClick(Sender: TObject);
    procedure btnDevideClick(Sender: TObject);
    procedure btnCompareWHClick(Sender: TObject);
    procedure btnRenameOnlyClick(Sender: TObject);
    procedure btnOpenFolderClick(Sender: TObject);
  private
    procedure ClearComponents(caArea: TClearArea);
    function DoSearch(const Path: String; const FileExts: TStringList;
      const afAction: TActFunction): Boolean;
    function FindAllFiles(const Path, FileExt: String;
      const afAction: TActFunction): Integer;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AllFileProc: TAllFileProc;
  gRenamePath,
  gRenameBasePath,
  gResizePath,
  gResizeBasePath,
  gSeperateFrontPath,
  gSeperateFrontBasePath,
  gSeperateSidePath,
  gSeperateSideBasePath,
  gPackPath,
  gPackBasePath,
  gDevidePath,
  gDevideBasePath,
  gCurFileName,
  gCurrentMainNum,
  gCurrentSubNum : string;
  gProgressBarMax, gProgressBarNow: Integer;

implementation

uses
  frmMain;

{$R *.dfm}

procedure TAllFileProc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TAllFileProc.FormShow(Sender: TObject);
begin
  ClearComponents(caAll);
end;

procedure TAllFileProc.ProgressTimerTimer(Sender: TObject);
begin
  ProgressTimer.Enabled := False;
  Main.pgBar.Value := gProgressBarNow;
  ProgressTimer.Enabled := True;
end;

procedure TAllFileProc.btnCompareWHClick(Sender: TObject);
var
  i : Integer;
  slAllFiles : TStringList;
  slTargetPaths : TStringList;
begin
  btnCompareWH.Enabled := False;

  if Trim(edtPath.Text) = '' then
  begin
    ShowMessage('길이를 비교할 이미지가 있는 폴더를 선택해 주십시오.');
    edtPath.SetFocus;
    btnCompareWH.Enabled := True;
    Exit;
  end;

  slAllFiles := TStringList.Create;
  slAllFiles.Add('bmp');
  slAllFiles.Add('jpg');
  slTargetPaths := TStringList.Create;

  mmResizeLog.Lines.Add('Start Search Image in ' + edtPath.Text);

  try
    slTargetPaths.Add(edtPath.Text + '\');

    for i := 0 to slTargetPaths.Count - 1 do
    begin
      DoSearch(slTargetPaths.Strings[i], slAllFiles, afCompWH);
    end;
  finally
    slTargetPaths.Free;
  end;

  mmResizeLog.Lines.Add('Finished Search Image in ' + edtPath.Text);
  btnCompareWH.Enabled := True;
end;

procedure TAllFileProc.btnDevideClick(Sender: TObject);
var
  i : Integer;
  slAllFiles : TStringList;
  slTargetPaths : TStringList;
begin
  btnDevide.Enabled := False;

  if Trim(edtPath.Text) = '' then
  begin
    ShowMessage('각각의 폴더로 분리할 이미지의 폴더를 입력해 주십시오.');
    edtPath.SetFocus;
    btnDevide.Enabled := True;
    Exit;
  end;

  mmResizeLog.Lines.Add('Start Devide in ' + edtPath.Text);

  slAllFiles := TStringList.Create;
  slAllFiles.Add('bmp');
  slAllFiles.Add('jpg');

  gDevideBasePath := edtPath.Text + '\' + IfThen(Trim(edtSubFolder.Text)='','Devide',edtSubFolder.Text) + '\';

  try
    DoSearch(edtPath.Text + '\', slAllFiles, afDevide);
  finally
    slAllFiles.Free;
  end;

  mmResizeLog.Lines.Add('Finished Devide in ' + edtPath.Text);

  btnDevide.Enabled := True;
end;

procedure TAllFileProc.btnOpenFolderClick(Sender: TObject);
begin
  with TFileOpenDialog.Create(nil) do
    try
      Title := 'Select Directory';
      Options := [fdoPickFolders, fdoPathMustExist, fdoForceFileSystem]; // YMMV
      DefaultFolder := GetCurrentDir;
      FileName := GetCurrentDir;
      if Execute then
      begin
        if TButton(Sender).Name = 'btnOpenFolder' then
          edtPath.Text := FileName;
      end;
    finally
      Free;
    end;
end;

procedure TAllFileProc.btnRenameOnlyClick(Sender: TObject);
var
  i : Integer;
  slAllFiles : TStringList;
  slTargetPaths : TStringList;
begin
  if btnRenameOnly.Tag > 0 then Exit;

  btnRenameOnly.Tag := 1;

  if Trim(edtPath.Text) = '' then
  begin
    ShowMessage('리네임할 이미지의 폴더를 입력해 주십시오.');
    edtPath.SetFocus;
    btnRenameOnly.Tag := 0;
    Exit;
  end;

  mmResizeLog.Lines.Add('Start Rename Only in ' + edtPath.Text);

  slAllFiles := TStringList.Create;
  slAllFiles.Add('bmp');
  slAllFiles.Add('jpg');

  gRenameBasePath := edtPath.Text + '\' + IfThen(Trim(edtSubFolder.Text)='','Rename',edtSubFolder.Text) + '\';

  try
    DoSearch(edtPath.Text + '\', slAllFiles, afRenameOnly);
  finally
    slAllFiles.Free;
  end;

  mmResizeLog.Lines.Add('Finished Rename Only in ' + edtPath.Text);

  btnRenameOnly.Tag := 0;
end;

procedure TAllFileProc.btnResizeAllImageClick(Sender: TObject);
var
  i : Integer;
  slAllFiles : TStringList;
  slTargetPaths : TStringList;
begin
  if btnResizeAllImage.Tag > 0 then Exit;

  btnResizeAllImage.Tag := 1;

  if Trim(edtPath.Text) = '' then
  begin
    ShowMessage('리사이즈할 이미지의 폴더를 입력해 주십시오.');
    edtPath.SetFocus;
    btnResizeAllImage.Tag := 0;
    Exit;
  end;

  if edtResizeAllWidth.Text = '' then
  begin
    ShowMessage('리사이즈할 가로길이를 입력해 주십시오.');
    edtResizeAllWidth.SetFocus;
    btnResizeAllImage.Tag := 0;
    Exit;
  end;

  mmResizeLog.Lines.Add('Start Resize All Images in ' + edtPath.Text);

  slAllFiles := TStringList.Create;
  slAllFiles.Add('bmp');

  gResizeBasePath := edtPath.Text + '\' + IfThen(Trim(edtSubFolder.Text)='','Resize',edtSubFolder.Text) + '\';

  // Progress 용 카운터
  gProgressBarMax := 0;
  try
    DoSearch(edtPath.Text + '\', slAllFiles, afProgressCount);
  finally
  end;

  // StartProgress
  Main.pgBar.MaxValue := gProgressBarMax;
  gProgressBarNow := 0;
  ProgressTimer.Enabled := True;

  try
    DoSearch(edtPath.Text + '\', slAllFiles, afResizeAll);
  finally
    slAllFiles.Free;
  end;

  mmResizeLog.Lines.Add('Finished Resize All Images in ' + edtPath.Text);

  ProgressTimer.Enabled := False;
  btnResizeAllImage.Tag := 0;
end;

procedure TAllFileProc.btnSeperateImageClick(Sender: TObject);
var
  i : Integer;
  slAllFiles : TStringList;
  slTargetPaths : TStringList;
begin
  if btnSeperateImage.Tag > 0 then Exit;

  btnSeperateImage.Tag := 1;

  if Trim(edtPath.Text) = '' then
  begin
    ShowMessage('분리할 이미지의 폴더를 입력해 주십시오.');
    edtPath.SetFocus;
    btnSeperateImage.Tag := 0;
    Exit;
  end;

  mmResizeLog.Lines.Add('Start Seperate Images in ' + edtPath.Text);

  slAllFiles := TStringList.Create;
  slAllFiles.Add('bmp');
  slAllFiles.Add('jpg');

  gSeperateFrontBasePath := '정면\';
  gSeperateSideBasePath := '측면\';

  try
    DoSearch(edtPath.Text + '\', slAllFiles, afSeperate);
  finally
    slAllFiles.Free;
  end;

  mmResizeLog.Lines.Add('Finished Seperate Images in ' + edtPath.Text);

  btnSeperateImage.Tag := 0;
end;

procedure TAllFileProc.Button2Click(Sender: TObject);
begin
  mmResizeLog.Lines.Clear;
end;

procedure TAllFileProc.ClearComponents(caArea: TClearArea);
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

function TAllFileProc.DoSearch(const Path: String; const FileExts: TStringList; const afAction: TActFunction) : Boolean;
var
  SR: TSearchRec;
  i, j: Integer;
  CurFileCount : Integer;
begin
  Result := False;

  Main.lblStatusText.Caption := Path;
  Application.ProcessMessages;

  case afAction of
    afCompWH:
      begin
        CurFileCount := 0;

        for i:=0 to FileExts.Count-1 do
        begin
          CurFileCount := FindAllFiles(Path, '*.' + FileExts.Strings[i], afCompWH);
        end;

        if CurFileCount > 0 then
          mmResizeLog.Lines.Add(Path);

        // 하위 디렉토리 검색
        if FindFirst(Path + '*.*', faDirectory, SR) = 0 then
          try
            repeat
              if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
              begin
                DoSearch(Path + SR.Name + '\', FileExts, afCompWH);
              end;
            until (FindNext(SR) <> 0);
          finally
            FindClose(SR);
          end;
      end;
    afResizeAll:
      begin
        for i:=0 to FileExts.Count-1 do
        begin
          FindAllFiles(Path, '*.' + FileExts.Strings[i], afResizeAll);
        end;

        // 하위 디렉토리 검색
        if FindFirst(Path + '*.*', faDirectory, SR) = 0 then
          try
            repeat
              if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
              begin
                if Pos(LowerCase(IfThen(Trim(edtSubFolder.Text)='','Resize',edtSubFolder.Text)), LowerCase(SR.Name)) > 0 then Continue;

                gResizePath := gResizeBasePath + SR.Name;
                try
                  if not DirectoryExists(gResizePath) then
                    ForceDirectories(gResizePath);
                except
                  on E: Exception do
                  begin
                    btnResizeAllImage.Tag := 0;
                    Exit;
                  end;
                end;

                DoSearch(Path + SR.Name + '\', FileExts, afResizeAll);
              end;
            until (FindNext(SR) <> 0);
          finally
            FindClose(SR);
          end;
      end;
    afRenameOnly:
      begin
        for i:=0 to FileExts.Count-1 do
        begin
          FindAllFiles(Path, '*.' + FileExts.Strings[i], afRenameOnly);
        end;

        // 하위 디렉토리 검색
        if FindFirst(Path + '*.*', faDirectory, SR) = 0 then
          try
            repeat
              if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
              begin
                if Pos(LowerCase(IfThen(Trim(edtSubFolder.Text)='','Rename',edtSubFolder.Text)), LowerCase(SR.Name)) > 0 then Continue;

                gRenamePath := gRenameBasePath + SR.Name;
                if not DirectoryExists(gRenamePath) then
                  ForceDirectories(gRenamePath);

                DoSearch(Path + SR.Name + '\', FileExts, afRenameOnly);
              end;
            until (FindNext(SR) <> 0);
          finally
            FindClose(SR);
          end;
      end;
    afSeperate:
      begin
        for i:=0 to FileExts.Count-1 do
        begin
          FindAllFiles(Path, '*.' + FileExts.Strings[i], afSeperate);
        end;

        // 하위 디렉토리 검색
        if FindFirst(Path + '*.*', faDirectory, SR) = 0 then
          try
            repeat
              if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
              begin
                if Pos(LowerCase(IfThen(Trim(edtSubFolder.Text)='','Rename',edtSubFolder.Text)), LowerCase(SR.Name)) > 0 then Continue;

                gSeperateFrontPath := gSeperateFrontBasePath + SR.Name;
                gSeperateSidePath := gSeperateSideBasePath + SR.Name;

                if not DirectoryExists(gSeperateFrontPath) then
                  ForceDirectories(gSeperateFrontPath);
                if not DirectoryExists(gSeperateSidePath) then
                  ForceDirectories(gSeperateSidePath);

                DoSearch(Path + SR.Name + '\', FileExts, afSeperate);
              end;
            until (FindNext(SR) <> 0);
          finally
            FindClose(SR);
          end;
      end;
    afDevide:
      begin
        for i:=0 to FileExts.Count-1 do
        begin
          FindAllFiles(Path, '*.' + FileExts.Strings[i], afDevide);
        end;

        // 하위 디렉토리 검색
        if FindFirst(Path + '*.*', faDirectory, SR) = 0 then
          try
            repeat
              if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
              begin
                if Pos(LowerCase(IfThen(Trim(edtSubFolder.Text)='','Devide',edtSubFolder.Text)), LowerCase(SR.Name)) > 0 then Continue;

                DoSearch(Path + SR.Name + '\', FileExts, afDevide);
              end;
            until (FindNext(SR) <> 0);
          finally
            FindClose(SR);
          end;
      end;
    afProgressCount:
      begin
        for i:=0 to FileExts.Count-1 do
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

function TAllFileProc.FindAllFiles(const Path, FileExt: String; const afAction: TActFunction): Integer;
var
  SR: TSearchRec;
  FilePart: PChar; // a pointer to the filename
  F, FC : TShFileOpStruct;
  mem, mem2: TMemoryStream;
  FileNum: Integer;
  i, j: Integer;
  pic: TPicture;
begin
  Result := 0;

  if FindFirst(Path + FileExt, faArchive, SR) = 0 then
  begin
    try
      repeat
        if (FileExt <> '*.*') and ( LowerCase(FileExt) <> LowerCase('*' + ExtractFileExt(SR.Name)) ) then
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
          afCompWH:
            begin
              pic := TPicture.Create;
              try
                pic.LoadFromFile(Path + SR.Name);
                if pic.Width < pic.Height then
                  Inc(Result);
              finally
                pic.Free;
              end;
            end;
          afResizeAll:
            begin
              if ExtractFileExt(SR.Name) = '.bmp' then
              begin
                Inc(Result);
                Inc(gProgressBarNow);
                mem := TMemoryStream.Create;
                mem2 := TMemoryStream.Create;
                try
                  mem.LoadFromFile(Path + SR.Name);
                  ResizeBMP2JPG(mem, mem2, StrToInt(edtResizeAllWidth.Text));
                  mem2.SaveToFile(gResizePath + '\' + StringReplace(SR.Name, '.bmp', '.jpg', [rfReplaceAll]));
//                  mmResizeLog.Lines.Add(Path + SR.Name + ' save as ' + gResizePath + '\' + StringReplace(SR.Name, '.bmp', '.jpg', [rfReplaceAll]));
                finally
                  mem2.Free;
                  mem.Free;
                end;
              end;
            end;
          afRenameOnly:
            begin
              Inc(Result);
              FC.Wnd := Handle;     // if 0, then no parent and can task switch away
              FC.wFunc := FO_COPY;
              FC.fFlags := FOF_ALLOWUNDO or FOF_RENAMEONCOLLISION;
              FC.pFrom := PChar(Path + SR.Name + #0);
//              ShowMessage(ExtractFileName(gRenamePath));
              FC.pTo := PChar(gRenamePath + '\' + ExtractFileName(gRenamePath) + '-' + IntToStr(Result+StrToIntDef(edtRenStart.Text, 1)-1) + ExtractFileExt(SR.Name) + #0);
              if ShFileOperation(FC) <> 0 then ShowMessage('Copy Failed');
            end;
          afSeperate:
            begin
              Inc(Result);
              FC.Wnd := Handle;     // if 0, then no parent and can task switch away
              FC.wFunc := FO_COPY;
              FC.fFlags := FOF_ALLOWUNDO or FOF_RENAMEONCOLLISION;

              if not TryStrToInt(Copy(ExtractFileName(SR.Name), ExtractFileName(SR.Name).IndexOf('-')+2, 3), FileNum) then
              begin
                ShowMessage('파일명이 형식과 맞지 않습니다. 다시 시도해 주십시오.');
                Exit;
              end;
              // 101~110, 201~210, 401 정면
              // 111~120, 211~220, 402 측면
//              ShowMessage(Copy(ExtractFileName(SR.Name), ExtractFileName(SR.Name).IndexOf('-')+2, 3));
              FC.pFrom := PChar(Path + SR.Name + #0);
              if (FileNum in [101..110, 201..210]) or (FileNum = 401) then
                FC.pTo := PChar(gSeperateFrontPath + '\' + ExtractFileName(SR.Name) + #0)
              else if (FileNum in [111..120, 211..220]) or (FileNum = 402) then
                FC.pTo := PChar(gSeperateSidePath + '\' + ExtractFileName(SR.Name) + #0);

              if ShFileOperation(FC) <> 0 then ShowMessage('Copy Failed');
            end;
          afDevide:
            begin
              Inc(Result);

              gDevidePath := gDevideBasePath + Copy(ExtractFileName(SR.Name), 1, ExtractFileName(SR.Name).IndexOf('-'));

              if not DirectoryExists(gDevidePath) then
                ForceDirectories(gDevidePath);

              F.Wnd := Handle;     // if 0, then no parent and can task switch away
              F.wFunc := FO_MOVE;
              F.fFlags := FOF_ALLOWUNDO or FOF_RENAMEONCOLLISION;
              F.pFrom := PChar(Path + SR.Name + #0);
              F.pTo := PChar(gDevidePath + '\' + ExtractFileName(SR.Name) + #0);
              if ShFileOperation(F) <> 0 then ShowMessage('Move Failed');
            end;
        end;

        Application.ProcessMessages;

      until (FindNext(SR) <> 0);
    finally
      FindClose(SR);
    end;

    case afAction of
      afResizeAll, afRenameOnly:
        begin
          mmResizeLog.Lines.Add(Path + ' Done. :: 파일갯수 : ' + IntToStr(Result));
        end;
    end;
  end;
end;

end.

