unit frmToolTip;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls, uConst, uQuery,
  scGPExtControls, scControls, scGPControls, Vcl.ComCtrls, Data.DB, DBAccess,
  Uni, MemDS;

type
  TPageNames = (pgProcImage, pgProcAllFiles, pgPackage, pgImageUpload);

const
  pageProcImage : string = '1. ����� �÷�/��� ��� �κ��� ĸ�ĺ��忡 �����մϴ�.'
            + sLineBreak + '   1.1 �÷�/����� ������� �ʴ� ��� ��� ȯ�漳���� ���Ͽ� '
            + sLineBreak + '       ���� ��¼����� �����մϴ�.'
            + sLineBreak + '   1.2 ���� ���̽�(���������) X-Ray ����� ��� ������ �������� '
            + sLineBreak + '       ����(ID:004, PW:94866)�Ͽ� �ӽ� ������ �����մϴ�.'
            + sLineBreak + ''
            + sLineBreak + '2. ĸ�ĺ����� �ػ󵵴� 1280 * 1024�� ĸ�� �̹����� �����δ� '
            + sLineBreak + '   ������ ������ �����մϴ�.'
            + sLineBreak + '   2.1 ������ �Կ��� ���� �� ���ʵ����͸� �ۼ��ϱ� ���Ͽ� ������ '
            + sLineBreak + '   �۾��� Excel�� �غ��մϴ�.'
            + sLineBreak + ''
            + sLineBreak + '3. ĸ�ĸ� �޴� ������ ������ �����ϴ�. (��:���̽�)'
            + sLineBreak + '   3.1 normal(1��) -> O2(1��) -> HI(1��) -> NEG(1��) -> '
            + sLineBreak + '       (normal -> �ּ� ���� -> ���� 15 ��� = 1 ��)'
            + sLineBreak + '       -> ���� 15 ���(1��) -> ���� 5 ���(1��) -> ���� 5 ���(1��) '
            + sLineBreak + '       -> ���� 5 ���(1��) -> ���� 5 ���(1��)'
            + sLineBreak + '   3.2 �� 10���� ������ ĸ���ϸ� �������� �� ������'
            + sLineBreak + '       ���� �÷� + 10 / ���� ��� + 10 / ���� �÷� + 10 / '
            + sLineBreak + '       ���� ��� + 10 / ���� ����(normal) +1 / ���� ����(normal) +1 / '
            + sLineBreak + '       �ǻ� �������� �� 43��(������ ���� ��� ��ǰ�� ��� 41��)�� '
            + sLineBreak + '       �������� �Կ��Ǿ�� �մϴ�.'
            + sLineBreak + ''
            + sLineBreak + '4. ĸ�ĺ��带 ���Ͽ� ����Ǵ� �̹��������� ��ġ�� XBT Make Contents '
            + sLineBreak + '   Tool(���� MCT) �� �����մϴ�.'
            + sLineBreak + '   4.1 MCT �̹��� ó�� �ʱ� ������ ������ �����ϴ�.'
            + sLineBreak + '   4.2 ��) ���� X-Ray ������ ���� ��'
            + sLineBreak + '           ���� : ���� ���۹�ȣ = X0001, ���� ���۹�ȣ 1 ���� '
            + sLineBreak + '           20 �� ����, ��ü ���� ���� 22��'
            + sLineBreak + '           ���� : ���� ���۹�ȣ = X0001, ���� ���۹�ȣ 2 ���� '
            + sLineBreak + '           20 �� ����, ��ü ���� ���� 20��'
            + sLineBreak + '       ��) ��ǰ X-Ray ������ ���� ��'
            + sLineBreak + '           ���� : ���� ���۹�ȣ = U0001, ���� ���۹�ȣ 1 ���� '
            + sLineBreak + '           5 �� ����, ��ü ���� ���� 5��'
            + sLineBreak + '           ���� : ���� ���۹�ȣ = U0001, ���� ���۹�ȣ 2 ���� '
            + sLineBreak + '           5 �� ����, ��ü ���� ���� 5��'
            + sLineBreak + '   4.3 ������ ��� ����/���� normal X-Ray �̹����� �������� ����Ǿ� '
            + sLineBreak + '       �����Ǿ� 22���� ������ �����˴ϴ�.'
            + sLineBreak + '   4.4 ���������� �ϳ��� ������ �̵��ȴٸ� ���� ���� ��ȣ �� ���� '
            + sLineBreak + '       ��ȣ�� ���� �������� ����˴ϴ�.'
            + sLineBreak + ''
            + sLineBreak + '5. 1�� �̹��� �۾� (��ǰ ������ ����)'
            + sLineBreak + '   5.1 �Կ��� ��ǰ�� ���� ������ �Կ��մϴ�.'
            + sLineBreak + '   5.2 ��ǰ�� X-Ray ��� �̿��Ͽ� X-Ray �̹��� �۾��� �����մϴ�.'
            + sLineBreak + '   5.1 ĸ�ĵ� �̹����� ���� 5�� / ���� 5���� ������ �� MCT �̹���ó�� '
            + sLineBreak + '       ���� ��ư�� Ŭ�� '
            + sLineBreak + '   5.2 ���α׷��� ���α׷� ��ġ ��ġ �Ϻ� -> ���� ���۹�ȣ�� ���� '
            + sLineBreak + '       �ڵ� ����'
            + sLineBreak + '   5.3 ������ ������ ���� ���۹�ȣ + 101 ~ 105 (���� �÷�) '
            + sLineBreak + '       ���� ���۹�ȣ + 201 ~ 205 (���� ���)�� �ڵ��з� �˴ϴ�.'
            + sLineBreak + ''
            + sLineBreak + '6. 1�� �̹��� �۾� (���� ������ ����)'
            + sLineBreak + '   6.1 �Կ��� ������ ���� ��ǰ�� �ٷ��� ������ �Կ��մϴ�.'
            + sLineBreak + '   6.1 ĸ�ĵ� �̹����� ���� 20�� / ���� 20���� ������ �� MCT '
            + sLineBreak + '       �̹���ó�� ���� ��ư�� Ŭ�� '
            + sLineBreak + '   6.2 ���α׷��� ���α׷� ��ġ ��ġ �Ϻ� -> ���� ���۹�ȣ�� '
            + sLineBreak + '       ���� �ڵ� ����'
            + sLineBreak + '   6.3 ������ ������ ���� ���۹�ȣ + 101 ~ 110 (���� �÷�), ���� '
            + sLineBreak + '       ���۹�ȣ + 111 ~ 120 (���� �÷�)'
            + sLineBreak + '       ���� ���۹�ȣ + 201 ~ 210 (���� ���), '
            + sLineBreak + '       ���� ���۹�ȣ + 210 ~ 220 (���� ���)'
            + sLineBreak + '       ���� ���۹�ȣ + 401 (���� normal �÷� ����), '
            + sLineBreak + '       ���� ���۹�ȣ + 402 (���� normal �÷� ����)�� �ڵ��з� �˴ϴ�.'
            + sLineBreak + ''
            + sLineBreak + '7. 5�� 6���� �۾��� ���Ͽ� X-Ray ��� �̿��� �Կ��� ������ �Ѵ�.'
            + sLineBreak + '   7.1 �۾��� �Ϸ� �� �� ���丮�� �÷�/��� �ΰ����� ������ '
            + sLineBreak + '       ������ ���������� �����Ǿ� ������ �˴ϴ�.';



  pageProcAllFiles: string = '8. 2�� �̹��� �۾� (������¡)'
              + sLineBreak + '   8.1 1�� �̹��� �۾��� ���Ͽ� ������ BMP ������ JPG �̹����� '
              + sLineBreak + '       �����մϴ�. '
              + sLineBreak + '   8.2 ���� �Կ� �̹����� 1280 * 1024 ������ �̻��̶�� '
              + sLineBreak + '       ��������(���α���)�� 1280�� �Է� �� �������� Ŭ���� �ش� '
              + sLineBreak + '       ������� ������¡�� �˴ϴ�.'
              + sLineBreak + ''
              + sLineBreak + '9. 3�� �̹��� �۾� (������ �и�)'
              + sLineBreak + '   9.1 ������ �и��� ���� �������� ����� ���� �̹����� �и��ϴ� '
              + sLineBreak + '       �۾��Դϴ�.'
              + sLineBreak + '   9.2 �и��� ������ ������ �÷�/��鿡 ���� ������ '
              + sLineBreak + '       101~110, 201~210, 401~402 (����), 111~120, 211~220 (����)�� '
              + sLineBreak + '       �������� �и��մϴ�.'
              + sLineBreak + '   9.2 ������¡�� �Ϸ�� �� MCT �����ϰ�ó���� ������¡�� �Ϸ�� '
              + sLineBreak + '       ���丮�� �����մϴ�.'
              + sLineBreak + '   9.3 Sub ���� �׸� ������ ��(��: ����/����)�� �Է��մϴ�.'
              + sLineBreak + '   9.4 ������ �и��� ���� �� �������� 9.2 ������ ��Ģ�� ���� '
              + sLineBreak + '       ���� X-Ray �̹����� ���� X-Ray �̹����� ������ ���丮 '
              + sLineBreak + '       ������ ���� �ΰ��� ������ �������ϴ�.'
              + sLineBreak + ''
              + sLineBreak + '11. 5�� �̹��� �۾� (ũ��/������)'
              + sLineBreak + '   11.1 ũ���� JPGCrops Tool�� �̿��Ͽ� �����մϴ�.'
              + sLineBreak + '   11.2 ũ���� �Ϸ�� �̹����� �ϳ��� ������ ������ ���ϸ����� '
              + sLineBreak + '        ��ġ�ϰԵ˴ϴ�.'
              + sLineBreak + '        �ٽ� ������ ���� ������ ������ ���� ������ ��ư�� Ŭ���Ͽ� '
              + sLineBreak + '        ũ���ϱ� �� ���� ������ �����մϴ�.';

  pagePackage : string = '10. 4�� �̹��� �۾� (��Ű¡)'
          + sLineBreak + '   10.1 �������� n���� ������ �̿� �ݺ� �۾��� �մϴ�. X-Ray ������ '
          + sLineBreak + '        ��翡 ���� �Կ��Ǵ� �̹����� ������ ũ�ӿ����� ������ �˴ϴ�.'
          + sLineBreak + '        ũ���� �ϰ�ó���� ���Ͽ� ������ �۾������� �۾��� Excel�� �̿�'
          + sLineBreak + '        ������ID�� ����ID�� ��ȸ�Ͽ� ���溰�� �̹����� ��Ű¡�մϴ�.';

  pageImageUpload : string = '12. 6�� �̹��� �۾� (DB ���ε�)'
              + sLineBreak + '   12.1 ũ���� �Ϸ�� �̹����� �����Ͱ� ������ Excel������ �غ��մϴ�.'
              + sLineBreak + '   12.2 ��� �����Ͽ� ������ �����մϴ�.'
              + sLineBreak + '   12.3 ���ε��� �̹����� ������ �����մϴ�.'
              + sLineBreak + '   12.4 �� Ű���� �� �׸��� ���� �ش��� �����մϴ�.'
              + sLineBreak + '   12.5 ������ ���ε� �ϰ� �̹����� ���ε� �մϴ�. ';


type
  TToolTip = class(TForm)
    Panel1: TPanel;
    btnClose: TscGPButton;
    mmToolTip: TscGPMemo;
    qryToolTip: TUniQuery;
    DBConn: TUniConnection;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    procedure Clear(caArea: TClearArea);
    procedure LoadToolTip(var slList: TStringList; const FromNum, ToNum: Integer); overload;
    procedure LoadToolTip(pageName: TPageNames); overload;
    { Public declarations }
  end;

var
  ToolTip: TToolTip;

implementation

{$R *.dfm}

procedure TToolTip.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TToolTip.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
  ToolTip := nil;
end;

procedure TToolTip.FormCreate(Sender: TObject);
begin
  Clear(caAll);
end;

procedure TToolTip.Clear(caArea: TClearArea);
var
  i, j: Integer;
begin
  for i := 0 to ComponentCount - 1 do
  begin
    if caArea in [caAll] then
    begin
      if Components[i].ClassType = TLabel then
      begin
        if Pos('lbl',TLabel(Components[i]).Name) > 0 then
        begin
          TLabel(Components[i]).Caption := '';
        end;
      end
      else if Components[i].ClassType = TEdit then
      begin
        if Pos('edt',TEdit(Components[i]).Name) > 0 then
        begin
          TEdit(Components[i]).Text := '';
        end;
      end
      else if Components[i].ClassType = TscGPMemo then
      begin
        if Pos('mm',TscGPMemo(Components[i]).Name) > 0 then
        begin
          TscGPMemo(Components[i]).Lines.Clear;
        end;
      end;
    end;
  end;
end;

procedure TToolTip.LoadToolTip(var slList: TStringList; const FromNum, ToNum: Integer);
begin
  mmToolTip.Lines.Clear;
  slList.Clear;

  if not DBConn.Connected then DBConn.Connect;

  with qryToolTip do
  begin
    SQL.Text := SEL_TOOLTIP;

    ParamCheck := True;
    ParamByName('fromnum').AsInteger := FromNum;
    ParamByName('tonum').AsInteger := ToNum;

    Open;
    First;

    while not Eof do
    begin
      slList.Add(FieldByName('CONTENT').AsString);
      Next;
    end;
  end;
end;

procedure TToolTip.LoadToolTip(pageName: TPageNames);
begin
  mmToolTip.Lines.Clear;
  case pageName of
    pgProcImage: mmToolTip.Lines.Add(pageProcImage);
    pgProcAllFiles: mmToolTip.Lines.Add(pageProcAllFiles);
    pgPackage: mmToolTip.Lines.Add(pagePackage);
    pgImageUpload: mmToolTip.Lines.Add(pageImageUpload);
  end;
end;


end.
