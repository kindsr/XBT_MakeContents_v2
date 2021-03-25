unit frmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  System.Actions, Vcl.ActnList, Vcl.CategoryButtons, Vcl.WinXCtrls, Vcl.StdCtrls,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, scControls, scModernControls, scGPControls,
  scAdvancedControls, Vcl.Mask, scExtControls, scGPExtControls, scStyledForm,
  scStyleManager, uConst, uFunction, System.StrUtils;

type
  TMain = class(TForm)
    ActionList1: TActionList;
    actHome: TAction;
    imlIcons: TImageList;
    SV: TscSplitView;
    btnProcImage: TscButton;
    btnExit: TscButton;
    btnOption: TscButton;
    btnProcUpload: TscButton;
    btnProcAllFile: TscButton;
    pnlBackground: TscGPPanel;
    pnlTitle: TscGPPanel;
    CloseButton: TscGPGlyphButton;
    MinButton: TscGPGlyphButton;
    labelTitle: TscLabel;
    scGPGlyphButton4: TscGPGlyphButton;
    MaxButton: TscGPGlyphButton;
    btnDetail: TscGPGlyphButton;
    svOption: TscSplitView;
    scLabel5: TscLabel;
    scScrollBox1: TscScrollBox;
    scListGroupPanel1: TscListGroupPanel;
    scLabel6: TscLabel;
    scLabel9: TscLabel;
    swiOverlayMode: TscGPSwitch;
    swiAnimation: TscGPSwitch;
    scListGroupPanel3: TscListGroupPanel;
    scLabel12: TscLabel;
    scLabel17: TscLabel;
    scPasswordEdit1: TscPasswordEdit;
    scEdit2: TscEdit;
    scListGroupPanel4: TscListGroupPanel;
    scLabel18: TscLabel;
    cbxMaximize: TscCheckBox;
    cbxSizeBox: TscCheckBox;
    pnlStatusBar: TscGPPanel;
    scGPTrackBar1: TscGPTrackBar;
    scGPGlyphButton10: TscGPGlyphButton;
    scGPGlyphButton11: TscGPGlyphButton;
    scGPSizeBox1: TscGPSizeBox;
    lblStatusText: TscLabel;
    scStyleManager1: TscStyleManager;
    scStyledForm1: TscStyledForm;
    btnHome: TscButton;
    cbxSkin: TscComboBox;
    btnSaveConfig: TscGPGlyphButton;
    scLabel1: TscLabel;
    swiCloseMode: TscGPSwitch;
    pnlSubForm: TscGPPanel;
    actProcImage: TAction;
    actProcAllFile: TAction;
    actUpload: TAction;
    pgBar: TscGPProgressBar;
    cbxStayOnTop: TscCheckBox;
    ListBox1: TListBox;
    procedure btnDetailClick(Sender: TObject);
    procedure cbxSkinChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure MaxButtonClick(Sender: TObject);
    procedure MinButtonClick(Sender: TObject);
    procedure OptionClick(Sender: TObject);
    procedure swiOverlayModeChangeState(Sender: TObject);
    procedure swiAnimationChangeState(Sender: TObject);
    procedure cbxSizeBoxClick(Sender: TObject);
    procedure cbxMaximizeClick(Sender: TObject);
    procedure labelTitleDblClick(Sender: TObject);
    procedure labelTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure labelTitleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure labelTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure btnSaveConfigClick(Sender: TObject);
    procedure swiCloseModeChangeState(Sender: TObject);
    procedure actHomeExecute(Sender: TObject);
    procedure actProcImageExecute(Sender: TObject);
    procedure actProcAllFileExecute(Sender: TObject);
    procedure cbxStayOnTopClick(Sender: TObject);
    procedure actUploadExecute(Sender: TObject);
  private
    FOldBoundsRect: TRect;
    FMaximized: Boolean;
    FDown: Boolean;
    FDownP: TPoint;
    procedure ShowSubForm(ASubForm: TForm);
    { Private declarations }
  public
    procedure DoMaximize;
    procedure DoRestore;
    procedure DoSizeCheck;
    { Public declarations }
  end;

var
  Main: TMain;

implementation

uses
  Vcl.Themes, frmSubImageProc, frmSubAllFileProc, frmUploadProc, uVersionInfo;

{$R *.dfm}

procedure TMain.actHomeExecute(Sender: TObject);
var
  i: Integer;
begin
  Tag := 0;

  if Assigned(ImageProc) then
  begin
    ImageProc.Close;
    FreeAndNil(ImageProc);
  end;
  if Assigned(AllFileProc) then
  begin
    AllFileProc.Close;
    FreeAndNil(AllFileProc);
  end;
  if Assigned(Upload) then
  begin
    Upload.Close;
    FreeAndNil(Upload);
  end;

  ListBox1.Visible := True;
end;

procedure TMain.actProcAllFileExecute(Sender: TObject);
begin
  if Assigned(ImageProc) then
  begin
    ImageProc.Close;
    FreeAndNil(ImageProc);
  end;
  if Assigned(Upload) then
  begin
    Upload.Close;
    FreeAndNil(Upload);
  end;
  ListBox1.Visible := False;
  // SubForm AllFileProc
  AllFileProc := TAllFileProc.Create(pnlSubForm);
  ShowSubForm(AllFileProc);
end;

procedure TMain.actProcImageExecute(Sender: TObject);
begin
  if Assigned(AllFileProc) then
  begin
    AllFileProc.Close;
    FreeAndNil(AllFileProc);
  end;
  if Assigned(Upload) then
  begin
    Upload.Close;
    FreeAndNil(Upload);
  end;
  ListBox1.Visible := False;
  // SubForm ImageProc
  ImageProc := TImageProc.Create(pnlSubForm);
  ShowSubForm(ImageProc);
end;

procedure TMain.actUploadExecute(Sender: TObject);
begin
  if Assigned(ImageProc) then
  begin
    ImageProc.Close;
    FreeAndNil(ImageProc);
  end;
  if Assigned(AllFileProc) then
  begin
    AllFileProc.Close;
    FreeAndNil(AllFileProc);
  end;
  ListBox1.Visible := False;
  // SubForm
  Upload := TUpload.Create(pnlSubForm);
  ShowSubForm(Upload);
end;

procedure TMain.btnDetailClick(Sender: TObject);
begin
  if SV.Opened then
    SV.Close
  else
    SV.Open;
end;

procedure TMain.btnSaveConfigClick(Sender: TObject);
var
  ConfigInfo: TConfigInfo;
begin
  // SaveConfig
  ConfigInfo.OverlayMode := swiOverlayMode.IsOn;
  ConfigInfo.Animation := swiAnimation.IsOn;
  ConfigInfo.CompactWidth := StrToInt(IfThen(swiCloseMode.IsOn, '50', '0'));
  ConfigInfo.SkinComboIndex := cbxSkin.ItemIndex;
  ConfigInfo.Maximize := cbxMaximize.Checked;
  ConfigInfo.Sizable := cbxSizeBox.Checked;
  ConfigInfo.StayOnTop := cbxStayOnTop.Checked;
  SaveConfig(ChangeFileExt(Application.ExeName,'.ini'), ConfigInfo);
end;

procedure TMain.cbxMaximizeClick(Sender: TObject);
begin
  MaxButton.Left := CloseButton.Left;
  MaxButton.Visible := cbxMaximize.Checked;
end;

procedure TMain.cbxSizeBoxClick(Sender: TObject);
begin
  scGPSizeBox1.Visible := cbxSizeBox.Checked;
  DoSizeCheck;
end;

procedure TMain.cbxSkinChange(Sender: TObject);
begin
  TStyleManager.SetStyle(cbxSkin.Items[cbxSkin.ItemIndex]);
end;

procedure TMain.DoMaximize;
begin
  FOldBoundsRect := BoundsRect;
  BoundsRect := scStyledForm1.GetMaximizeBounds;
  FMaximized := True;
  MaxButton.GlyphOptions.Kind := scgpbgkRestore;
  scGPSizeBox1.Visible := False;
end;

procedure TMain.DoRestore;
begin
  BoundsRect := FOldBoundsRect;
  FMaximized := False;
  labelTitle.DragForm := True;
  MaxButton.GlyphOptions.Kind := scgpbgkMaximize;
  scGPSizeBox1.Visible := cbxSizeBox.Checked;
end;

procedure TMain.DoSizeCheck;
begin
  if cbxSizeBox.Checked then
  begin
    Main.Constraints.MinWidth := Round(800 * scStyledForm1.ScaleFactor);
    Main.Constraints.MinHeight := Round(450 * scStyledForm1.ScaleFactor);
  end
  else
  begin
    Main.Constraints.MinWidth := 0;
    Main.Constraints.MinHeight := 0;
  end;
end;

procedure TMain.FormCreate(Sender: TObject);
var
  ConfigInfo: TConfigInfo;
begin
  labelTitle.Caption := labelTitle.Caption + ' :: ' + fnGetVersionInfo(tvFileVersion);
  // Load Config
  LoadConfig(ChangeFileExt(Application.ExeName,'.ini'), ConfigInfo);

  cbxSkin.Items.Clear;
  cbxSkin.Items.AddStrings(TStyleManager.StyleNames);

  with ConfigInfo do
  begin
    if OverlayMode then swiOverlayMode.State := scswOn else swiOverlayMode.State := scswOff;
    if Animation then swiAnimation.State := scswOn else swiAnimation.State := scswOff;
    cbxStayOnTop.Checked := ConfigInfo.StayOnTop;
    cbxMaximize.Checked := ConfigInfo.Maximize;
    if cbxMaximize.Checked then
    begin
      MaxButton.Left := CloseButton.Left;
      MaxButton.Visible := cbxMaximize.Checked;
    end;
    cbxSizeBox.Checked := ConfigInfo.Sizable;
    scGPSizeBox1.Visible := cbxSizeBox.Checked;
    DoSizeCheck;
    if ConfigInfo.SkinComboIndex <> -1 then
      cbxSkin.ItemIndex := ConfigInfo.SkinComboIndex
    else
      cbxSkin.ItemIndex := cbxSkin.Items.IndexOf(TStyleManager.ActiveStyle.Name);
    SV.CompactWidth := ConfigInfo.CompactWidth;
    if SV.CompactWidth > 0 then swiCloseMode.State := scswOn else swiCloseMode.State := scswOff;
    SV.Opened := False;
  end;
  TStyleManager.SetStyle(cbxSkin.Items[cbxSkin.ItemIndex]);
end;

procedure TMain.labelTitleDblClick(Sender: TObject);
begin
  if not cbxMaximize.Checked then Exit;

  if FMaximized then
    DoRestore
  else
    DoMaximize;
end;

procedure TMain.labelTitleMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (Button = mbLeft) and not (ssDouble in Shift) and FMaximized then
  begin
    GetCursorPos(FDownP);
    FDown := True;
  end;
end;

procedure TMain.labelTitleMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  P: TPoint;
  W, H, L, T: Integer;
begin
  if FMaximized and FDown then
  begin
    GetCursorPos(P);
    W := FOldBoundsRect.Width;
    H := FOldBoundsRect.Height;
    L := Round(W * (P.X - Left) / Width);
    T := P.Y - Top;
    FOldBoundsRect.Left := P.X - L;
    FOldBoundsRect.Top := P.Y - T;
    FOldBoundsRect.Right := FOldBoundsRect.Left + W;
    FOldBoundsRect.Height := FOldBoundsRect.Top + H;
    DoRestore;
  end;
end;

procedure TMain.labelTitleMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  FDown := False;
end;

procedure TMain.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMain.MaxButtonClick(Sender: TObject);
begin
  if not cbxMaximize.Checked then Exit;

  if FMaximized then
    DoRestore
  else
    DoMaximize;
end;

procedure TMain.MinButtonClick(Sender: TObject);
begin
  Application.Minimize;
end;

procedure TMain.OptionClick(Sender: TObject);
begin
  svOption.Opened := not svOption.Opened;
end;

procedure TMain.cbxStayOnTopClick(Sender: TObject);
begin
  if cbxStayOnTop.Checked then FormStyle := fsStayOnTop
  else FormStyle := fsNormal;
end;

procedure TMain.swiAnimationChangeState(Sender: TObject);
begin
  SV.Animation := swiAnimation.IsOn;
  svOption.Animation := swiAnimation.IsOn;
end;

procedure TMain.swiCloseModeChangeState(Sender: TObject);
begin
  SV.CompactWidth := StrToInt(IfThen(swiCloseMode.IsOn, '50', '0'));
end;

procedure TMain.swiOverlayModeChangeState(Sender: TObject);
begin
  if SV.DisplayMode = scsvmDocked then
    SV.DisplayMode := scsvmOverlay
  else
    SV.DisplayMode := scsvmDocked;
end;

procedure TMain.ShowSubForm(ASubForm: TForm);
begin
  // SubForm AllFileProc
  ASubForm.Parent := pnlSubForm;
  ASubForm.Left := 0;
  ASubForm.Top := 0;
  if Main.Constraints.MinWidth < ASubForm.Width+SV.Width+svOption.Width+2 then
    ClientWidth := ASubForm.Width+SV.Width+svOption.Width+2;
  if Main.Constraints.MinHeight < ASubForm.Height+pnlTitle.Height+pnlStatusBar.Height+2 then
    ClientHeight := ASubForm.Height+pnlTitle.Height+pnlStatusBar.Height+2;
  ASubForm.Show;

  DoSizeCheck;
  if not pnlSubForm.Visible then pnlSubForm.Visible := True;
end;

end.

