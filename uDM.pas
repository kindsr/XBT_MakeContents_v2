unit uDM;

interface

uses
  System.SysUtils, System.Classes, UniProvider, SQLServerUniProvider, Data.DB,
  MemDS, DBAccess, Uni, Controls, Dialogs, OracleUniProvider, EMS.Consts, EMS.Services;

type
  TDM = class(TDataModule)
    UniConnection1: TUniConnection;
    dsTables: TUniDataSource;
    qryTables: TUniQuery;
    SQLServerUniProvider1: TSQLServerUniProvider;
    OracleUniProvider1: TOracleUniProvider;
    qryDBGrid: TUniQuery;
    dsDBGrid: TUniDataSource;
    qryCRUD: TUniQuery;
    procedure UniConnection1AfterDisconnect(Sender: TObject);
    procedure UniConnection1AfterConnect(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure ClearSql;
    function fn_SetDBConnect: Boolean;
  end;

var
  DM: TDM;

implementation

uses
  frmDBLogin, frmUploadProc;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

function TDM.fn_SetDBConnect: Boolean;
var
  FDB : TDBLogin;
  er : EDAError;
begin
  ClearSql;
  Result := False;

  FDB := TDBLogin.Create(nil);

  with UniConnection1 do
  try
    if UniConnection1.Connected then Connected := False;

    if FDB.ShowModal = mrOk then
    begin
      ProviderName:= FDB.AdvComboBox1.Text;
      Server      := FDB.eServerName.Text;
      Port        := StrToIntDef(FDB.eServerPort.Text, 0);
      Username    := FDB.eUsername.Text;
      Password    := FDB.ePassword.Text;
      Database    := FDB.eDatabase.Text;

      try
        Connect;
      except
        on E : EUniError do
        begin
          er := E.InnerError;
          ShowMessage(er.Message);
        end;
      end;

      if Connected then
        Result := True;
    end;
  except
    Result := False;
  end;
end;

procedure TDM.UniConnection1AfterConnect(Sender: TObject);
begin
  Upload.btnDisconnect.Enabled := True;
  Upload.btnConnect.Enabled := False;
end;

procedure TDM.UniConnection1AfterDisconnect(Sender: TObject);
begin
  Upload.btnDisconnect.Enabled := False;
  Upload.btnConnect.Enabled := True;
end;

procedure TDM.ClearSql;
begin
  qryCRUD.Active := False;
  qryCRUD.SQL.Text := '';
end;

end.
