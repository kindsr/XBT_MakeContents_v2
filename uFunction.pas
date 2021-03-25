unit uFunction;

interface

uses
  Windows, Classes, StrUtils, SysUtils, Vcl.Forms, Vcl.Graphics, jpeg, uConst,
  ShlObj, ShellAPI, Winapi.CommCtrl, Controls, Winapi.Messages, scGPControls,
  scControls, scGPVertPagers, IOUtils, System.IniFiles;

type
  TRGBArray = array[Word] of TRGBTriple;
  pRGBArray = ^TRGBArray;

{Image Handling}
procedure SmoothResize(Src: TBitmap; Dst: TBitmap);
procedure ResizeBMP2JPG(const src: TMemoryStream; var des: TMemoryStream; const iWidth: Integer);

{Ini File}
procedure SaveConfig(const FileName: string; const rConfig: TConfigInfo);
procedure LoadConfig(const FileName: string; var rConfig: TConfigInfo);

implementation

procedure SmoothResize(Src: TBitmap; Dst: TBitmap);
var
  x, y: Integer;
  xP, yP: Integer;
  xP2, yP2: Integer;
  SrcLine1, SrcLine2: pRGBArray;
  t3: Integer;
  z, z2, iz2: Integer;
  DstLine: pRGBArray;
  DstGap: Integer;
  w1, w2, w3, w4: Integer;
begin
  Src.PixelFormat := pf24Bit;
  Dst.PixelFormat := pf24Bit;

  if (Src.Width = Dst.Width) and (Src.Height = Dst.Height) then
    Dst.Assign(Src)
  else
  begin
    DstLine := Dst.ScanLine[0];
    DstGap := Integer(Dst.ScanLine[1]) - Integer(DstLine);

    xP2 := MulDiv(pred(Src.Width), $10000, Dst.Width);
    yP2 := MulDiv(pred(Src.Height), $10000, Dst.Height);
    yP := 0;

    for y := 0 to pred(Dst.Height) do
    begin
      xP := 0;

      SrcLine1 := Src.ScanLine[yP shr 16];

      if (yP shr 16 < pred(Src.Height)) then
        SrcLine2 := Src.ScanLine[succ(yP shr 16)]
      else
        SrcLine2 := Src.ScanLine[yP shr 16];

      z2 := succ(yP and $FFFF);
      iz2 := succ((not yP) and $FFFF);
      for x := 0 to pred(Dst.Width) do
      begin
        t3 := xP shr 16;
        z := xP and $FFFF;
        w2 := MulDiv(z, iz2, $10000);
        w1 := iz2 - w2;
        w4 := MulDiv(z, z2, $10000);
        w3 := z2 - w4;
        DstLine[x].rgbtRed := (SrcLine1[t3].rgbtRed * w1 + SrcLine1[t3 + 1].rgbtRed * w2 + SrcLine2[t3].rgbtRed * w3 + SrcLine2[t3 + 1].rgbtRed * w4) shr 16;
        DstLine[x].rgbtGreen := (SrcLine1[t3].rgbtGreen * w1 + SrcLine1[t3 + 1].rgbtGreen * w2 + SrcLine2[t3].rgbtGreen * w3 + SrcLine2[t3 + 1].rgbtGreen * w4) shr 16;
        DstLine[x].rgbtBlue := (SrcLine1[t3].rgbtBlue * w1 + SrcLine1[t3 + 1].rgbtBlue * w2 + SrcLine2[t3].rgbtBlue * w3 + SrcLine2[t3 + 1].rgbtBlue * w4) shr 16;
        Inc(xP, xP2);
      end; {for}
      Inc(yP, yP2);
      DstLine := pRGBArray(Integer(DstLine) + DstGap);
    end; {for}
  end; {if}
end; {SmoothResize}

procedure ResizeBMP2JPG(const src: TMemoryStream; var des: TMemoryStream; const iWidth: Integer);
var
  OldBitmap: Vcl.Graphics.TBitmap;
  NewBitmap: Vcl.Graphics.TBitmap;
  jpg: TJPEGImage;
begin
  jpg := TJPEGImage.Create;
  OldBitmap := Vcl.Graphics.TBitmap.Create;
  try
    src.Position := 0;
    OldBitmap.LoadFromStream(src);

    if (OldBitmap.Width > iWidth) then
    begin
      NewBitmap := Vcl.Graphics.TBitmap.Create;
      try
        NewBitmap.Width := iWidth;
        NewBitmap.Height := MulDiv(iWidth, OldBitmap.Height, OldBitmap.Width);
        SmoothResize(OldBitmap, NewBitmap);
        jpg.Assign(NewBitmap);
        jpg.CompressionQuality := 75;
//        jpg.SaveToFile('.\ResizeJPG.jpg');
        des.Clear;
        des.Position := 0;
        jpg.SaveToStream(des);
      finally
        NewBitmap.Free;
      end; {try}
    end
    else
    begin
      jpg.Assign(OldBitmap);
      jpg.CompressionQuality := 75;
//        jpg.SaveToFile('.\ResizeJPG.jpg');
      des.Clear;
      des.Position := 0;
      jpg.SaveToStream(des);
    end; {if}
  finally
    FreeAndNil(OldBitmap);
    FreeAndNil(jpg);
  end; {try}
end; {ResizeImage}

procedure SaveConfig(const FileName: string; const rConfig: TConfigInfo);
var
  ini: TMemIniFile;
begin
  ini := TMemIniFile.Create(FileName);
  try
    ini.WriteString('FORM', 'OverlayMode', IfThen(rConfig.OverlayMode, '1', '0'));
    ini.WriteString('FORM', 'Animation', IfThen(rConfig.Animation, '1', '0'));
    ini.WriteInteger('FORM', 'CompactWidth', rConfig.CompactWidth);
    ini.WriteInteger('FORM', 'SkinComboIndex', rConfig.SkinComboIndex);
    ini.WriteString('FORM', 'Maximize', IfThen(rConfig.Maximize, '1', '0'));
    ini.WriteString('FORM', 'Sizable', IfThen(rConfig.Sizable, '1', '0'));
    ini.WriteString('FORM', 'StayOnTop', IfThen(rConfig.StayOnTop, '1', '0'));
    ini.UpdateFile;
  finally
    ini.Free;
  end;
end; {SaveConfig}

procedure LoadConfig(const FileName: string; var rConfig: TConfigInfo);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(FileName);
  try
    if ini.ReadString('FORM', 'OverlayMode', '1') = '1' then rConfig.OverlayMode := True else rConfig.OverlayMode := False;
    if ini.ReadString('FORM', 'Animation', '1') = '1' then rConfig.Animation := True else rConfig.Animation := False;
    rConfig.CompactWidth := ini.ReadInteger('FORM', 'CompactWidth', 0);
    rConfig.SkinComboIndex := ini.ReadInteger('FORM', 'SkinComboIndex', 0);
    if ini.ReadString('FORM', 'Maximize', '1') = '1' then rConfig.Maximize := True else rConfig.Maximize := False;
    if ini.ReadString('FORM', 'Sizable', '1') = '1' then rConfig.Sizable := True else rConfig.Sizable := False;
    if ini.ReadString('FORM', 'StayOnTop', '1') = '1' then rConfig.StayOnTop := True else rConfig.StayOnTop := False;
  finally
    ini.Free;
  end;
end; {LoadConfig}


end.
