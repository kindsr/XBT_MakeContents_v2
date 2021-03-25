unit frmDBLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, AdvPanel,
  AdvObj, Vcl.StdCtrls, AdvLabel, AdvEdit, AeroButtons, IniFiles,
  slstbox, AdvCombo, Vcl.Menus;

type
  TDBLogin = class(TForm)
    AdvPanel1: TAdvPanel;
    AdvPanel2: TAdvPanel;
    AdvLabel1: TAdvLabel;
    AdvLabel2: TAdvLabel;
    AdvLabel3: TAdvLabel;
    AdvLabel4: TAdvLabel;
    AdvLabel5: TAdvLabel;
    eServerName: TAdvEdit;
    eServerPort: TAdvEdit;
    eUsername: TAdvEdit;
    ePassword: TAdvEdit;
    eDatabase: TAdvEdit;
    AeroBitBtn1: TAeroBitBtn;
    AeroBitBtn2: TAeroBitBtn;
    AeroBitBtn3: TAeroBitBtn;
    ListBox1: TListBox;
    AdvComboBox1: TAdvComboBox;
    PopupMenu1: TPopupMenu;
    t1: TMenuItem;
    procedure AeroBitBtn2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure ListBox1Click(Sender: TObject);
    procedure AeroBitBtn3Click(Sender: TObject);
    procedure AeroBitBtn1Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure eServerNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eServerPortKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eUsernameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure ePasswordKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure eDatabaseKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure t1Click(Sender: TObject);
    procedure AdvComboBox1Change(Sender: TObject);
  private
    { Private declarations }
    FIni: TMemIniFile;
    procedure ClearComp;
  public
    { Public declarations }
  end;

var
  DBLogin: TDBLogin;

implementation

{$R *.dfm}

procedure TDBLogin.AdvComboBox1Change(Sender: TObject);
begin
  if Trim(AdvComboBox1.Text) = 'Oracle' then
    eServerPort.Enabled := False
  else
    eServerPort.Enabled := True;
end;

procedure TDBLogin.AeroBitBtn1Click(Sender: TObject);
begin
  if AdvComboBox1.ItemIndex <= 0 then
  begin
    ShowMessage('Provider 종류를 선택하십시오.');
    AdvComboBox1.SetFocus;
    Exit;
  end
  else if eServerName.Text = '' then
  begin
    ShowMessage('서버IP를 입력하십시오.');
    eServerName.SetFocus;
    Exit;
  end
  else if (Trim(AdvComboBox1.Text) <> 'Oracle') and (eServerPort.Text = '') then
  begin
    ShowMessage('포트를 입력하십시오.');
    eServerPort.SetFocus;
    Exit;
  end
  else if eUsername.Text = '' then
  begin
    ShowMessage('접속 ID를 입력하십시오.');
    eUsername.SetFocus;
    Exit;
  end
  else if ePassword.Text = '' then
  begin
    ShowMessage('패스워드를 입력하십시오.');
    ePassword.SetFocus;
    Exit;
  end
//  else if eDatabase.Text = '' then
//  begin
//    ShowMessage('DB명을 입력하십시오.');
//    eDatabase.SetFocus;
//    Exit;
//  end
  else
    ModalResult := mrOk;
end;

procedure TDBLogin.AeroBitBtn2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TDBLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FIni.Free;
  Action := caFree;
end;

procedure TDBLogin.FormCreate(Sender: TObject);
begin
  FIni := TMemIniFile.Create(ExtractFilePath(Application.ExeName) + 'DBConfig.ini');
  ClearComp;
  FIni.ReadSections(ListBox1.Items);
end;

procedure TDBLogin.ListBox1Click(Sender: TObject);
var
  Section : string;
begin
  if ListBox1.ItemIndex >= 0 then
  begin
    Section := ListBox1.Items[ListBox1.ItemIndex];
    eServerName.Text := FIni.ReadString(Section, 'SERVER NAME', 'file.g-antech.com');
    eServerPort.Text := FIni.ReadString(Section, 'SERVER PORT', '1521');
    eUsername.Text := FIni.ReadString(Section, 'SERVER USER', 'abcuser');
    ePassword.Text := FIni.ReadString(Section, 'SERVER PASS', '!1wldks123');
    eDatabase.Text := FIni.ReadString(Section, 'DATABASE', 'master');
    AdvComboBox1.ItemIndex := AdvComboBox1.Items.IndexOf(FIni.ReadString(Section, 'PROVIDER', 'SQL Server'));
    AdvComboBox1Change(nil);
  end
  else
  begin
    ShowMessage('Select DB Server or Insert DB Server Information Here!');
    eServerName.SetFocus;
    Exit;
  end;
end;

procedure TDBLogin.ListBox1DblClick(Sender: TObject);
begin
  ListBox1Click(nil);
  AeroBitBtn1.Click;
end;

procedure TDBLogin.t1Click(Sender: TObject);
begin
  if ListBox1.ItemIndex < 0 then
  begin
    ShowMessage('Select data to delete.');
    Exit;
  end
  else
  begin
    if FIni.SectionExists(eServerName.Text + '|' + eDatabase.Text) then
    begin
      FIni.EraseSection(eServerName.Text + '|' + eDatabase.Text);
      FIni.UpdateFile;
      ShowMessage('Success deleting data that ' + eServerName.Text + '|' + eDatabase.Text);
      FIni.ReadSections(ListBox1.Items);
    end;
  end;
end;

procedure TDBLogin.AeroBitBtn3Click(Sender: TObject);
begin
  try
    if not FIni.SectionExists(eServerName.Text + '|' + eDatabase.Text) then
    begin
      FIni.WriteString(eServerName.Text + '|' + eDatabase.Text, 'SERVER NAME', eServerName.Text);
      FIni.WriteString(eServerName.Text + '|' + eDatabase.Text, 'SERVER PORT', eServerPort.Text);
      FIni.WriteString(eServerName.Text + '|' + eDatabase.Text, 'SERVER USER', eUsername.Text);
      FIni.WriteString(eServerName.Text + '|' + eDatabase.Text, 'SERVER PASS', ePassword.Text);
      FIni.WriteString(eServerName.Text + '|' + eDatabase.Text, 'DATABASE', eDatabase.Text);
      FIni.WriteString(eServerName.Text + '|' + eDatabase.Text, 'PROVIDER', AdvComboBox1.Text);
      FIni.UpdateFile;
      FIni.ReadSections(ListBox1.Items);
    end
    else
      ShowMessage('Already exist Server Name');
  finally

  end;
end;

procedure TDBLogin.ClearComp;
begin
  eServerName.Clear;
  eServerPort.Clear;
  eUsername.Clear;
  ePassword.Clear;
  eDatabase.Clear;
end;

procedure TDBLogin.eDatabaseKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TDBLogin.ePasswordKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TDBLogin.eServerNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TDBLogin.eServerPortKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

procedure TDBLogin.eUsernameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_ESCAPE then
    Close;
end;

end.
