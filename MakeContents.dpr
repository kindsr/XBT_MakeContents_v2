program MakeContents;

uses
  Vcl.Forms,
  frmMain in 'frmMain.pas' {Main},
  Vcl.Themes,
  Vcl.Styles,
  uFunction in 'uFunction.pas',
  uConst in 'uConst.pas',
  frmSubImageProc in 'frmSubImageProc.pas' {ImageProc},
  uVersionInfo in 'uVersionInfo.pas',
  frmEditImage in 'frmEditImage.pas' {EditImage},
  uFileCatcher in 'uFileCatcher.pas',
  frmSubAllFileProc in 'frmSubAllFileProc.pas' {AllFileProc},
  AARotate in 'AARotate.pas',
  AARotate_Fast in 'AARotate_Fast.pas',
  frmUploadProc in 'frmUploadProc.pas' {Upload},
  uDM in 'uDM.pas' {DM: TDataModule},
  uQuery in 'uQuery.pas',
  frmDBLogin in 'frmDBLogin.pas' {DBLogin};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Amethyst Kamri');
  Application.CreateForm(TMain, Main);
  Application.CreateForm(TDBLogin, DBLogin);
  Application.Run;
end.
