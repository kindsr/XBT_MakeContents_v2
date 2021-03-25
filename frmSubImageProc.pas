unit frmSubImageProc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  scGPControls, scControls, uConst, uFunction, ShlObj, ShellAPI, uGDIUnit,
  AARotate, AARotate_Fast;

type
  TImageProc = class(TForm)
    Panel1: TPanel;
    lblCurrentNum: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    lblNextNum: TLabel;
    Label7: TLabel;
    Label9: TLabel;
    btnRun: TButton;
    edtMainNum: TEdit;
    cbxImageInfo: TscCheckBox;
    btnInit: TButton;
    btnOpenImages: TscGPGlyphButton;
    btnCheckFolder: TButton;
    edtCheckFolder: TEdit;
    Button1: TButton;
    edtCurCount: TEdit;
    edtResizeWidth: TEdit;
    rbColor: TRadioButton;
    rbBnW: TRadioButton;
    Panel2: TPanel;
    Splitter2: TSplitter;
    imgLeft: TImage;
    imgRight: TImage;
    Panel5: TPanel;
    mmLog: TMemo;
    Splitter1: TSplitter;
    Splitter3: TSplitter;
    ProgressTimer: TTimer;
    procedure btnInitClick(Sender: TObject);
    procedure btnRunClick(Sender: TObject);
    procedure btnCheckFolderClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnOpenImagesClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ImageClick(Sender: TObject);
    procedure ProgressTimerTimer(Sender: TObject);
  private
    procedure ClearComponents(caArea: TClearArea);
    function DoSearch(const Path: string; const FileExts: TStringList; const afAction: TActFunction): Boolean;
    function FindAllFiles(const Path, FileExt: string; const afAction: TActFunction): Integer;
    { Private declarations }
  public
    gCurFilePath, gCurFileName, gCurrentMainNum, gCurrentSubNum: string;
    { Public declarations }
  end;

var
  ImageProc: TImageProc;
  ptLeftBegin, ptLeftEnd, ptRightBegin, ptRightEnd: TPoint;
  ptLeftBoxBegin, ptLeftBoxEnd, ptRightBoxBegin, ptRightBoxEnd: TPoint;
  iRotatedCntLeft, iRotatedCntRight: Integer;
  gProgressBarMax, gProgressBarNow: Integer;

implementation

uses
  frmMain, frmEditImage, jpeg;

{$R *.dfm}

procedure TImageProc.btnCheckFolderClick(Sender: TObject);
var
  i: Integer;
  slAllFiles: TStringList;
  slTargetPaths: TStringList;
begin
  if edtCheckFolder.Text = '' then
  begin
    ShowMessage('확인할 파일 갯수를 입력하세요.');
    edtCheckFolder.SetFocus;
    Exit;
  end;

  slAllFiles := TStringList.Create;
  slAllFiles.Add('bmp');
  slAllFiles.Add('jpg');
  slTargetPaths := TStringList.Create;

  try
    slTargetPaths.Add(GetCurrentDir + '\');

    for i := 0 to slTargetPaths.Count - 1 do
    begin
      DoSearch(slTargetPaths.Strings[i], slAllFiles, afCount);
    end;
  finally
    slTargetPaths.Free;
  end;
end;

procedure TImageProc.btnInitClick(Sender: TObject);
begin
  ClearComponents(caAction);
end;

procedure TImageProc.btnOpenImagesClick(Sender: TObject);
var
  i: Integer;
  slAllFiles: TStringList;
begin
  if btnOpenImages.Tag > 0 then
    Exit;

  if not (rbColor.Checked or rbBnW.Checked) then
  begin
    ShowMessage('컬러또는 흑백을 선택해 주십시오.');
    rbColor.SetFocus;
    Exit;
  end;

  if edtCurCount.Text = '' then
  begin
    ShowMessage('확인할 파일 갯수를 입력하세요.');
    edtCurCount.SetFocus;
    Exit;
  end;

  btnOpenImages.Tag := 1;

  slAllFiles := TStringList.Create;
  slAllFiles.Add('bmp');
  slAllFiles.Add('jpg');

  DoSearch(GetCurrentDir + '\', slAllFiles, afLoadImage);

  btnOpenImages.Tag := 0;
end;

procedure TImageProc.btnRunClick(Sender: TObject);
var
  i: Integer;
  slAllFiles: TStringList;
  slTargetPaths: TStringList;
  infoTextFile: TextFile;
begin
  if btnRun.Tag > 0 then
    Exit;

  if edtMainNum.Text = '' then
  begin
    ShowMessage('메인 시작번호를 입력해 주십시오.');
    edtMainNum.SetFocus;
    Exit;
  end;

  if not (rbColor.Checked or rbBnW.Checked) then
  begin
    ShowMessage('컬러또는 흑백을 선택해 주십시오.');
    rbColor.SetFocus;
    Exit;
  end;

  btnRun.Tag := 1;

  slAllFiles := TStringList.Create;
  slAllFiles.Add('bmp');
  slTargetPaths := TStringList.Create;

  if lblCurrentNum.Caption = '' then
  begin
    gCurrentMainNum := edtMainNum.Text;
  end;

  if rbColor.Checked then
    gCurrentSubNum := '101'
  else if rbBnW.Checked then
    gCurrentSubNum := '201';

  gCurFileName := gCurrentMainNum + '-' + gCurrentSubNum;
  lblCurrentNum.Caption := gCurrentMainNum;
  lblNextNum.Caption := Copy(gCurrentMainNum, 1, 1) + IntToStr(StrToInt(Copy(gCurrentMainNum, 2, Length(gCurrentMainNum) - 1)) + 1).PadLeft(Length(gCurrentMainNum) - 1, '0');
  gCurFilePath := GetCurrentDir + '\' + gCurrentMainNum + '\';

  try
    if not DirectoryExists(GetCurrentDir + '\' + gCurrentMainNum) then
      ForceDirectories(GetCurrentDir + '\' + gCurrentMainNum);
    if not DirectoryExists(GetCurrentDir + '\Origin\' + gCurrentMainNum) then
      ForceDirectories(GetCurrentDir + '\Origin\' + gCurrentMainNum);
  except
    on E: Exception do
    begin
      btnRun.Tag := 0;
      Exit;
    end;
  end;

  // StartProgress
  Main.pgBar.MaxValue := gProgressBarMax;
  gProgressBarNow := 0;
  ProgressTimer.Enabled := True;

  DoSearch(GetCurrentDir + '\', slAllFiles, afMoveFile);

  if Tag > 0 then
  begin
    if cbxImageInfo.Checked then
    begin
      AssignFile(infoTextFile, 'ImageInfo.txt');

      if FileExists('ImageInfo.txt') then
        Append(infoTextFile)
      else
        Rewrite(infoTextFile);

      Write(infoTextFile, gCurrentMainNum + '|' + IntToStr(ptLeftBoxBegin.X) + '|' + IntToStr(ptLeftBoxBegin.Y) + '|' +
                                                  IntToStr(ptLeftBoxEnd.X)   + '|' + IntToStr(ptLeftBoxEnd.Y) + '|' +
                                                  IntToStr(ptRightBoxBegin.X)+ '|' + IntToStr(ptRightBoxBegin.Y) + '|' +
                                                  IntToStr(ptRightBoxEnd.X)  + '|' + IntToStr(ptRightBoxEnd.Y) + '|' + sLineBreak);

      CloseFile(infoTextFile);
    end;

    mmLog.Lines.Add(gCurrentMainNum + ' Done.');
    gCurrentMainNum := Copy(gCurrentMainNum, 1, 1) + IntToStr(StrToInt(Copy(gCurrentMainNum, 2, Length(gCurrentMainNum) - 1)) + 1).PadLeft(Length(gCurrentMainNum) - 1, '0');
  end;

  ProgressTimer.Enabled := False;
  Main.pgBar.Value := gProgressBarNow;
  Tag := 0;
  btnRun.Tag := 0;

  imgLeft.Picture := nil;
  imgRight.Picture := nil;
end;

procedure TImageProc.Button1Click(Sender: TObject);
begin
  mmLog.Lines.Clear;
end;

procedure TImageProc.ClearComponents(caArea: TClearArea);
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

function TImageProc.DoSearch(const Path: string; const FileExts: TStringList; const afAction: TActFunction): Boolean;
var
  SR: TSearchRec;
  i, j: Integer;
  CurFileCount: Integer;
begin
  Result := False;

  Main.lblStatusText.Caption := Path;
  Application.ProcessMessages;

  case afAction of
    afCount:
      begin
        for i := 0 to FileExts.Count - 1 do
        begin
          FindAllFiles(Path, '*.' + FileExts.Strings[i], afCount);
        end;

        // 하위 디렉토리 검색
        if FindFirst(Path + '*.*', faDirectory, SR) = 0 then
        try
          repeat
            if ((SR.Attr and faDirectory) <> 0) and (SR.Name[1] <> '.') then
            begin
              DoSearch(Path + SR.Name + '\', FileExts, afCount);
            end;
          until (FindNext(SR) <> 0);
        finally
          FindClose(SR);
        end;
      end;
    afMoveFile:
      begin
        for i := 0 to FileExts.Count - 1 do
        begin
          FindAllFiles(Path, '*.' + FileExts.Strings[i], afMoveFile);
        end;
      end;
    afLoadImage:
      begin
        CurFileCount := 0;
        for i := 0 to FileExts.Count - 1 do
        begin
          CurFileCount := CurFileCount + FindAllFiles(Path, '*.' + FileExts.Strings[i], afLoadImage);
        end;

        if CurFileCount <> StrToInt(edtCurCount.Text) then
        begin
          ShowMessage('파일 갯수가 ' + edtCurCount.Text + '개가 아닙니다. 다시 진행하세요. :: ' + gCurrentMainNum);
          RemoveDirectory(PChar(gCurFilePath));
          btnOpenImages.Tag := 0;
          Exit;
        end;
        // Progress 용 카운터
        gProgressBarMax := CurFileCount;
      end;
  end;
end;

function TImageProc.FindAllFiles(const Path, FileExt: string; const afAction: TActFunction): Integer;
var
  SR: TSearchRec;
  F: TShFileOpStruct;
  i: Integer;
  bmp, bmpRotated: TBitmap;
  jpg: TJPEGImage;
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
          afMoveFile:
            begin
              // Bitmap load 후 Crop 저장
              bmp := TBitmap.Create;
              jpg := TJPEGImage.Create;

              try
                bmp.LoadFromFile(Path + SR.Name);

                if Result in [0..9] then
                begin
                  bmp.Canvas.CopyRect(Rect(0, 0, ptLeftEnd.X - ptLeftBegin.X, ptLeftEnd.Y - ptLeftBegin.Y), bmp.Canvas, Rect(ptLeftBegin.X + 1, ptLeftBegin.Y + 1, ptLeftEnd.X - 1, ptLeftEnd.Y - 1));
                  bmp.Width := ptLeftEnd.X - ptLeftBegin.X;
                  bmp.Height := ptLeftEnd.Y - ptLeftBegin.Y;

                  if iRotatedCntLeft > 0 then
                  begin
                    bmpRotated := TBitmap.Create;
                    try
                      bmpRotated := FastAARotatedBitmap(bmp, 90, TColor($00ff00ff){bgcolor}, True, False, False, 1.0);
                      bmpRotated.PixelFormat := bmp.PixelFormat;
                      jpg.Assign(bmpRotated);
                    finally
                      bmpRotated.Free;
                    end;
                  end
                  else
                  begin
                    jpg.Assign(bmp);
                  end;
                end
                else if Result in [10..19] then
                begin
                  bmp.Canvas.CopyRect(Rect(0, 0, ptRightEnd.X - ptRightBegin.X, ptRightEnd.Y - ptRightBegin.Y), bmp.Canvas, Rect(ptRightBegin.X + 1, ptRightBegin.Y + 1, ptRightEnd.X - 1, ptRightEnd.Y - 1));
                  bmp.Width := ptRightEnd.X - ptRightBegin.X;
                  bmp.Height := ptRightEnd.Y - ptRightBegin.Y;

                  if iRotatedCntRight > 0 then
                  begin
                    bmpRotated := TBitmap.Create;
                    try
                      bmpRotated := FastAARotatedBitmap(bmp, 90, TColor($00ff00ff){bgcolor}, True, False, False, 1.0);
                      bmpRotated.PixelFormat := bmp.PixelFormat;
                      jpg.Assign(bmpRotated);
                    finally
                      bmpRotated.Free;
                    end;
                  end
                  else
                  begin
                    jpg.Assign(bmp);
                  end;
                end;

                jpg.CompressionQuality := 75;
                jpg.SaveToFile(Path + gCurrentMainNum + '\' + gCurFileName + '.jpg');

                if Result = 19 then
                begin
                  jpg.Assign(imgLeft.Picture.Graphic);
                  jpg.CompressionQuality := 75;
                  jpg.SaveToFile(Path + gCurrentMainNum + '\' + gCurrentMainNum + '-501.jpg');
                  jpg.Assign(imgRight.Picture.Graphic);
                  jpg.CompressionQuality := 75;
                  jpg.SaveToFile(Path + gCurrentMainNum + '\' + gCurrentMainNum + '-502.jpg');
                end;
              finally
                bmp.Free;
                jpg.Free;
              end;

              // 원본파일 이동
              F.Wnd := Handle;     // if 0, then no parent and can task switch away
              F.wFunc := FO_MOVE;
              F.fFlags := FOF_ALLOWUNDO or FOF_RENAMEONCOLLISION;
              F.pFrom := PChar(Path + SR.Name + #0);
              F.pTo := PChar(Path + 'Origin\' + gCurrentMainNum + '\' + gCurFileName + ExtractFileExt(SR.Name) + #0);
              if ShFileOperation(F) <> 0 then
                mmLog.Lines.Add(Path + SR.Name + ' Move Failed.');

              Tag := Tag + 1;
              Inc(Result);
              Inc(gProgressBarNow);

              if Result > 20 then
                ShowMessage('파일 20개 초과');

              gCurrentSubNum := IntToStr(StrToInt(gCurrentSubNum) + 1).PadLeft(3, '0');
              if Result = 10 then
                gCurrentSubNum := IntToStr(StrToInt(gCurrentSubNum) + 200).PadLeft(3, '0');

              gCurFileName := gCurrentMainNum + '-' + gCurrentSubNum;
            end;
          afLoadImage:
            begin
              if ((Result = 0) or (Result = 10)) and (rbColor.Checked) then
              begin
                if Result = 0 then
                  imgLeft.Picture.LoadFromFile(Path + SR.Name)
                else if Result = 10 then
                  imgRight.Picture.LoadFromFile(Path + SR.Name);
                mmLog.Lines.Add(Path + SR.Name + ' File Loaded.');
              end;

              Tag := Tag + 1;
              Inc(Result);
            end;
        end;

        Application.ProcessMessages;

      until (FindNext(SR) <> 0);
    finally
      FindClose(SR);
    end;

    case afAction of
      afCount:
        begin
          if Result <> StrToInt(edtCheckFolder.Text) then
          begin
            mmLog.Lines.Add('경로 : ' + Path + '  ::  파일갯수 : ' + IntToStr(Result));
          end;
        end;
    end;
  end;
end;

procedure TImageProc.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TImageProc.FormResize(Sender: TObject);
begin
  imgLeft.Width := Round(Panel2.Width / 2) - 2;
end;

procedure TImageProc.FormShow(Sender: TObject);
begin
  ClearComponents(caAll);
end;

procedure TImageProc.ImageClick(Sender: TObject);
var
  sLog: string;
begin
  if ((Sender as TImage).Picture.Width = 0) and ((Sender as TImage).Picture.Height = 0) then
    Exit;

  EditImage := TEditImage.Create(Self);
//  ShowMessageFmt('Width %d :: Height %d',[(Sender as TImage).Picture.Width, (Sender as TImage).Picture.Height]);
  try
    with EditImage do
    begin
      imgEdit.Picture := (Sender as TImage).Picture;

      if ShowModal = mrOk then
      begin
        (Sender as TImage).Picture.Bitmap := imgEdit.Picture.Bitmap;
        if (Sender as TImage).Name = 'imgLeft' then
        begin
          ptLeftBegin := CropBeginPoint;
          ptLeftEnd := CropEndPoint;
          ptLeftBoxBegin := BoxBeginPoint;
          ptLeftBoxEnd := BoxEndPoint;
          iRotatedCntLeft := RotatedCount;
          sLog := '정면이미지 Crop: Begin(%d,%d) End(%d,%d) :: Box: Begin(%d,%d) End(%d,%d)';
          if RotatedCount > 0 then
            sLog := sLog + ' :: Rotated.';
          mmLog.Lines.Add(Format(sLog, [CropBeginPoint.X, CropBeginPoint.Y, CropEndPoint.X, CropEndPoint.Y, BoxBeginPoint.X, BoxBeginPoint.Y, BoxEndPoint.X, BoxEndPoint.Y]));
        end
        else if (Sender as TImage).Name = 'imgRight' then
        begin
          ptRightBegin := CropBeginPoint;
          ptRightEnd := CropEndPoint;
          ptRightBoxBegin := BoxBeginPoint;
          ptRightBoxEnd := BoxEndPoint;
          iRotatedCntRight := RotatedCount;
          sLog := '측면이미지 Crop: Begin(%d,%d) End(%d,%d) :: Box: Begin(%d,%d) End(%d,%d)';
          if RotatedCount > 0 then
            sLog := sLog + ' :: Rotated.';
          mmLog.Lines.Add(Format(sLog, [CropBeginPoint.X, CropBeginPoint.Y, CropEndPoint.X, CropEndPoint.Y, BoxBeginPoint.X, BoxBeginPoint.Y, BoxEndPoint.X, BoxEndPoint.Y]));
        end;
      end;
    end;
  finally
    EditImage.Free;
  end;
end;

procedure TImageProc.ProgressTimerTimer(Sender: TObject);
begin
  ProgressTimer.Enabled := False;
  Main.pgBar.Value := gProgressBarNow;
  ProgressTimer.Enabled := True;
end;

end.

